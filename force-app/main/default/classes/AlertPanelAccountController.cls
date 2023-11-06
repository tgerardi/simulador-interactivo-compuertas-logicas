/**
 * @description       :
 * @author            : Agustin Ignacio Martinez Bisagno
 * @group             : Xappia
 * @last modified on  : 10-04-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
global with sharing class AlertPanelAccountController {
    private final Account client;

    public List<Alerta__c> alerts { get; private set; }
    public CMDP_Prestamo__c CMDP { get; set; }

    public AlertPanelAccountController(ApexPages.StandardController controller) {
        client = [
            SELECT Id, Fecha_ultima_verificacion__c, CUIT__c, Id_Cliente_BHSeg__c
            FROM Account
            WHERE Id = :controller.getId()
        ];
    }

    public void updateAlerts() {
        deleteAlerts();
        createAlerts();

        createAndDeletePolizaAlert();

        showAlerts();
    }

    @RemoteAction
    global static void closeOpportunity(String oppId) {
        /*Alerta__c alert = [
            SELECT Id
            FROM Alerta__c
            WHERE Oportunidad__c = :oppId
        ];
        delete alert;

        Opportunity opp = [
            SELECT Id, StageName, AccountId
            FROM Opportunity
            WHERE Id = :oppId
        ];
        //915 - This JIRA requests change the stagename to a new one called Contactado.
        opp.stagename = 'Contactado';
        update opp;*/
    }

    public void deleteAlert() {
        String alertId = Apexpages.currentPage().getParameters().get('alertId');
        system.debug(alertId);

        Alerta__c alert = new Alerta__c(Id = alertId);
        delete alert;

        showAlerts();
    }

    private void deleteAlerts() {
        deleteContactVerificationAlerts();
        deleteRejectedCases90Days();
        deleteCustomAlerts();
    }

    private void deleteContactVerificationAlerts() {
        if (client.Fecha_ultima_verificacion__c != null) {
            Integer numDays = client.Fecha_ultima_verificacion__c.daysBetween(Date.today());
            if (numDays < 30) {
                List<Alerta__c> currentAlerts = [
                    SELECT Id, Cuenta__c
                    FROM Alerta__c
                    WHERE Cuenta__c = :client.Id AND Titulo__c = 'Debe verificar datos de contacto'
                ];
                delete currentAlerts;
            }
        }
    }

    private void deleteRejectedCases90Days() {
        List<Alerta__c> currentAlerts = [
            SELECT Id, Cuenta__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id AND Titulo__c = 'Cliente con casos de RNC'
        ];
        delete currentAlerts;
    }

    private void deleteCustomAlerts() {
        List<Alerta__c> currentAlerts = [
            SELECT Id, Cuenta__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id AND Definicion_de_Alerta__c != NULL
        ];

        delete currentAlerts;
    }

    private void createAlerts() {
        createRejectedCases90Days();
        createContactVerificationAlert();
        createCustomAlerts();
        if (checkIfTheClientHaveACMDPRecord(client.Id_Cliente_BHSeg__c)) {
            if (!checkIfTheClientAlreadyHaveAnALert(client.Id_Cliente_BHSeg__c)) {
                createCMDPAlert(client.Id_Cliente_BHSeg__c);
            } else {
                boolean shouldReplace = checkIfTheAlertShouldBeReplaced(client.Id_Cliente_BHSeg__c);
                System.debug('shouldReplace: ' + shouldReplace);
                if (shouldReplace) {
                    replaceAlert(client.Id_Cliente_BHSeg__c);
                }
            }
        }
    }

    private void createRejectedCases90Days(){
        List<Case> cases = [
            SELECT Id
            FROM Case
            WHERE AccountId = :client.Id
                AND Subject = 'Riesgo no cubierto'
                AND CreatedDate <= LAST_90_DAYS
        ];
        if(cases.size() > 0){
            insert new Alerta__c(
                Titulo__c = 'Cliente con casos de RNC',
                Contenido__c = 'El cliente tiene '+ String.valueOf(cases.size()) +' de casos registrados de Riesgo No Cubierto en los últimos 90 días.',
                Tipo_de_Alerta__c = 'Informacion',
                Cuenta__c = client.Id,
                Eliminable__c = false
            );
        }
    }

    public void createAndDeletePolizaAlert() {
        System.debug('createAndDeletePolizaAlert()');
        //NTDB = no tiene designación de beneficiarios
        
        //}------------------------- Identificadores -------------------------{//
        final String identiTelemedicina = 'Telemedicina-'+client.Id_Cliente_BHSeg__c;
        final String identiTCVisaBH = 'PoseeTCVisaBH-'+client.Id_Cliente_BHSeg__c;
        final String identiOsuti = 'PolizaOsuti-' +client.Id_Cliente_BHSeg__c;
        final String identiIBBroker = 'PolizaIBBroker-'+client.Id_Cliente_BHSeg__c;
        
        Map<String, Alerta__c> alertsToInsert = new Map<String, Alerta__c>();
        List<Alerta__c> correctAlerts = new List<Alerta__c>();
        Boolean telemedicinaAlertAlreadyExist = false;

        List<Poliza__c> listPol = [
            SELECT
                Id,
                Name,
                Cuenta__c,
                Vigente__c,
                Estado_Vigencia__c,
                Alerta_Designacion_de_Beneficiarios__c,
                Asistencias_Extras__c
            FROM Poliza__c
            WHERE
                Estado__c = 'VIGENTE'
                AND Cuenta__c = :client.Id
                AND (Alerta_Designacion_de_Beneficiarios__c = TRUE
                OR Asistencias_Extras__c INCLUDES ('Telemedicina'))
        ];


        // Se deben analizar todas las polizas sin tener en cuenta su Estado debido al requerimiento EV-2024.
        List<Poliza__c> allClientPolicies = [
            SELECT
                Id,
                Name,
                Cuenta__c,
                Origen_de_Pago__c,
                Cuenta_Pago__c,
                Medio_de_pago__c,
                Productor_IdBHSeg__c,
                Ramo_IdBHSeg__c,
                Producto_IdBHSeg__c,
                Estado__c
            FROM Poliza__c
            WHERE Cuenta__c = :client.Id
        ];

        List<Alerta__c> currentAlerts = [
            SELECT Id, Titulo__c, Cuenta__c, Identificador_Adicional__c
            FROM Alerta__c
            WHERE
                Cuenta__c = :client.Id
                AND (Identificador_Adicional__c LIKE '%NTDB'
                OR Identificador_Adicional__c = :identiTelemedicina
                OR Identificador_Adicional__c = :identiTCVisaBH
                OR Identificador_Adicional__c = :identiOsuti
                OR Identificador_Adicional__c = :identiIBBroker)
        ];

        List<Bin_Tarjeta__c> binesBHSignaturePlatinum = [
            SELECT 
                Bin__c
            FROM Bin_Tarjeta__c
            WHERE Emisor__c = 'Banco Hipotecario'
        ];

        //************************************//
        //*********** ALL POLICIES ***********//
        //************************************//
        Set<String> binesBH = new Set<String>();
        for (Bin_Tarjeta__c bin : binesBHSignaturePlatinum) {
            binesBH.add(bin.Bin__c);
        }

        for (Poliza__c pol : allClientPolicies) {
            String binCuentaPagoPoliza = pol.Cuenta_Pago__c != null ? pol.Cuenta_Pago__c.substring(0, 6) : '';
            Boolean hasTCVisaHBAlert = false;
            Boolean hasOsutiPolicyAlert = false;
            Boolean hasIBBrokerPolicyAlert = false;

            for (Alerta__c al : currentAlerts) {                
                if (identiIBBroker.equalsIgnoreCase(al.Identificador_Adicional__c) && checkPolicyProductor(pol, '602', '9', '255', true)) {
                    correctAlerts.add(al);
                    hasIBBrokerPolicyAlert = true;
                    break;
                }

                if (identiOsuti.equalsIgnoreCase(al.Identificador_Adicional__c) && checkPolicyProductor(pol, '606', '19', '272', false)) {
                    correctAlerts.add(al);
                    hasOsutiPolicyAlert = true;
                    break;
                }

                if (identiTCVisaBH.equalsIgnoreCase(al.Identificador_Adicional__c) && binesBH.contains(binCuentaPagoPoliza)) {
                    correctAlerts.add(al);
                    hasTCVisaHBAlert = true;
                    break;
                }
            }

            if(!hasIBBrokerPolicyAlert && checkPolicyProductor(pol, '602', '9', '255', true)) {
                Alerta__c alert = new Alerta__c();

                alert.Titulo__c = 'CLIENTE CON SEGURO PROTECCION DE CELULAR DEL ORGANIZADOR “IB BROKER"';
                alert.Identificador_Adicional__c = identiIBBroker;
                alert.Contenido__c = 'DERIVAR AL CLIENTE QUE LLAME AL TELEFONO: 0810-220-4000';
                alert.Tipo_de_Alerta__c = 'Alerta';
                alert.Cuenta__c = client.Id;
                alert.Eliminable__c = false;

                alertsToInsert.put(alert.Identificador_Adicional__c, alert);
            }

            if (!hasOsutiPolicyAlert && checkPolicyProductor(pol, '606', '19', '272', false)) {
                Alerta__c alert = new Alerta__c();
                alert.Titulo__c = 'Cliente con poliza de vida Osuti';
                alert.Identificador_Adicional__c = identiOsuti;
                alert.Contenido__c = '¡NO BRINDAR INFORMACIÓN SOBRE LA MISMA!';
                alert.Tipo_de_Alerta__c = 'Alerta';
                alert.Cuenta__c = client.Id;
                alert.Eliminable__c = false;

                alertsToInsert.put(identiOsuti, alert);
            }

            if (!hasTCVisaHBAlert && binesBH.contains(binCuentaPagoPoliza)) {
                Alerta__c alert = new Alerta__c();
                alert.Titulo__c = 'Cliente con TC Visa Signature/Platinum del BH';
                alert.Identificador_Adicional__c = identiTCVisaBH;
                alert.Contenido__c = 'El cliente ya cuenta con Tarjeta Visa Signature o Planitum del Banco Hipotecario';
                alert.Tipo_de_Alerta__c = 'Exclamacion';
                alert.Cuenta__c = client.Id;
                alert.Eliminable__c = false;

                alertsToInsert.put(identiTCVisaBH, alert);
            }
        }
        //************************************//
        //******** (END) ALL POLICIES ********//
        //************************************//

        //************************************//
        //***** ONLY SPECIFIED POLICIES *****//
        //**********************************//
        for (Poliza__c pol : listPol) {
            System.debug('entre');
            String tituloAlert = 'La Póliza ' + pol.Name + ' aún no tiene designación de beneficiarios';
            String identi = pol.Name + '-' + 'NTDB';

            Boolean alertAlreadyExist = false;
            Boolean telemedicinaAlreadyExist = false;

            for (Alerta__c currAle : currentAlerts) {
                if (
                    pol.Alerta_Designacion_de_Beneficiarios__c &&
                    identi.equalsIgnoreCase(currAle.Identificador_Adicional__c)
                ) {
                    correctAlerts.add(currAle);
                    alertAlreadyExist = true;
                }

                if (
                    !telemedicinaAlertAlreadyExist &&
                    String.isNotBlank(pol.Asistencias_Extras__c) &&
                    pol.Asistencias_Extras__c.contains('Telemedicina') &&
                    identiTelemedicina.equalsIgnoreCase(currAle.Identificador_Adicional__c)
                ) {
                    correctAlerts.add(currAle);
                    telemedicinaAlreadyExist = true;
                    telemedicinaAlertAlreadyExist = true;
                }
            }
            if (pol.Alerta_Designacion_de_Beneficiarios__c && !alertAlreadyExist) {
                Alerta__c alert = new Alerta__c();

                alert.Titulo__c = tituloAlert;
                alert.Identificador_Adicional__c = identi;
                alert.Contenido__c = 'Verifica la información';
                alert.Tipo_de_Alerta__c = 'Exclamacion';
                alert.Cuenta__c = client.Id;
                alert.Eliminable__c = false;

                alertsToInsert.put(alert.Identificador_Adicional__c, alert);
            }

            if (
                String.isNotBlank(pol.Asistencias_Extras__c) &&
                pol.Asistencias_Extras__c.contains('Telemedicina') &&
                !alertsToInsert.containsKey(identiTelemedicina) &&
                !telemedicinaAlertAlreadyExist &&
                !telemedicinaAlreadyExist
            ) {
                Alerta__c alert = new Alerta__c();
                alert.Titulo__c = 'Cliente con Telemedicina';
                alert.Identificador_Adicional__c = identiTelemedicina;
                alert.Contenido__c = 'El cliente ya cuenta con una asistencia de Telemedicina.';
                alert.Tipo_de_Alerta__c = 'Informacion';
                alert.Cuenta__c = client.Id;
                alert.Eliminable__c = false;

                alertsToInsert.put(identiTelemedicina, alert);
            }
        }
        //************************************//
        //*** (END) ONLY CURRENT POLICIES ***//
        //**********************************//

        List<Alerta__c> alertsToDelete = new List<Alerta__c>();
        for (Alerta__c currAle : currentAlerts) {
            Boolean toDelete = true;
            for (Alerta__c coAle : correctAlerts) {
                if (currAle.Id == coAle.Id) {
                    toDelete = false;
                    break;
                }
            }
            if (toDelete) {
                alertsToDelete.add(currAle);
            }
        }

        System.debug('Alertas existentes a borrar: ' + alertsToDelete);
        if (alertsToDelete.size() > 0) {
            DELETE alertsToDelete;
        }

        System.debug('Alertas nuevas a crear: ' + alertsToInsert);
        if (alertsToInsert.size() > 0) {
            INSERT alertsToInsert.values();
        }
    }

    public Boolean checkPolicyProductor(Poliza__c poliza, String productor, String ramo, String producto, Boolean flagEstado) {
        // El flag me indica si me interesa o no chequear el estado de la poliza.
        return productor.equalsIgnoreCase(poliza.Productor_IdBHSeg__c) &&
            ramo.equalsIgnoreCase(poliza.Ramo_IdBHSeg__c) &&
            producto.equalsIgnoreCase(poliza.Producto_IdBHSeg__c) &&
            (!flagEstado || 'VIGENTE'.equalsIgnoreCase(poliza.Estado__c));
    }

    public void replaceAlert(String clientId) {
        System.debug('replaceAlert()');

        List<Alerta__c> clientAlert = [
            SELECT Id, Titulo__c
            FROM Alerta__c
            WHERE
                Cuenta__r.id_cliente_bhseg__c = :clientId
                AND Titulo__c = 'Participa de la campaña CMDP(Prestamos a Vencer) - (En Curso)'
        ];
        if (clientAlert.size() == 1) {
            delete clientAlert;

            Alerta__c alert = new Alerta__c();
            alert.Titulo__c = 'Participa de la campaña CMDP(Prestamos a Vencer) - (Finalizada)';
            alert.Contenido__c = '';
            alert.Tipo_de_Alerta__c = 'Comentario';
            alert.Cuenta__c = client.Id;
            alert.Eliminable__c = false;
            insert alert;
        }
    }

    public boolean checkIfTheAlertShouldBeReplaced(String clientId) {
        System.debug('checkIfTheAlertShouldBeReplaced()');
        System.debug('clientId: ' + clientId);

        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c
            FROM Alerta__c
            WHERE
                Cuenta__r.id_cliente_bhseg__c = :clientId
                AND (Titulo__c = 'Participa de la campaña CMDP(Prestamos a Vencer) - (En Curso)'
                OR Titulo__c = 'Participa de la campaña CMDP(Prestamos a Vencer) - (Finalizada)')
        ];

        System.debug('alerts: ' + alerts);
        if (alerts.size() == 1) {
            if (!alerts[0].Titulo__c.contains('Finalizada')) {
                boolean shouldInsertNewAlert = checkIfTheCMDPRecordHaveARequestAssigned(clientId);
                if (shouldInsertNewAlert) {
                    return true;
                }
            }
        }

        return false;
    }

    public boolean checkIfTheCMDPRecordHaveARequestAssigned(String clientId) {
        System.debug('checkIfTheCMDPRecordHaveARequestAssigned()');

        for (CMDP_Prestamo__c prestamo : [
            SELECT Gestion__c
            FROM CMDP_Prestamo__c
            WHERE id_cliente_bhseg__c = :clientId
        ]) {
            if (prestamo.gestion__c != null) {
                return true;
            }
        }

        return false;
    }

    public boolean checkIfTheClientAlreadyHaveAnALert(String clientId) {
        System.debug('checkIfTheClientAlreadyHaveAnALert()');

        Id clientSFId = [
            SELECT ID
            FROM ACCOUNT
            WHERE Id_Cliente_BHSeg__c = :clientId
        ]
        .Id;

        if (
            0 !=
            [
                SELECT COUNT()
                FROM Alerta__c
                WHERE
                    Cuenta__c = :clientSFId
                    AND (Titulo__c = 'Participa de la campaña CMDP(Prestamos a Vencer) - (Finalizada)'
                    OR Titulo__c = 'Participa de la campaña CMDP(Prestamos a Vencer) - (En Curso)')
            ]
        ) {
            return true;
        }

        return false;
    }

    public void createCMDPAlert(String clientId) {
        System.debug('createCMDPAlert()');

        Alerta__c alert = new Alerta__c();

        if (CMDP.Gestion__c != null) {
            alert.Titulo__c = 'Participa de la campaña CMDP(Prestamos a Vencer) - (Finalizada)';
        } else {
            alert.Titulo__c = 'Participa de la campaña CMDP(Prestamos a Vencer) - (En Curso)';
        }

        alert.Contenido__c = '';
        alert.Tipo_de_Alerta__c = 'Comentario';
        alert.Cuenta__c = client.Id;
        alert.Eliminable__c = false;
        insert alert;
    }

    public boolean checkIfTheClientHaveACMDPRecord(String clientId) {
        System.debug('checkIfTheClientHaveACMDPRecord()');

        if (
            0 !=
            [
                SELECT COUNT()
                FROM CMDP_Prestamo__c
                WHERE id_cliente_bhseg__c = :clientId
            ]
        ) {
            CMDP = [
                SELECT Id, Gestion__c
                FROM CMDP_Prestamo__c
                WHERE id_cliente_bhseg__c = :clientId
                LIMIT 1
            ];
            return true;
        }

        return false;
    }

    private void createContactVerificationAlert() {
        Boolean createVerifyContactAlert = false;
        if (client.Fecha_ultima_verificacion__c == null) {
            createVerifyContactAlert = true;
        } else {
            Integer numDays = client.Fecha_ultima_verificacion__c.daysBetween(Date.today());
            if (numDays >= 30) {
                createVerifyContactAlert = true;
            }
        }
        if (createVerifyContactAlert) {
            List<Alerta__c> currentAlerts = [
                SELECT Id, Cuenta__c
                FROM Alerta__c
                WHERE Cuenta__c = :client.Id AND Titulo__c = 'Debe verificar datos de contacto'
            ];

            if (currentAlerts.size() == 0) {
                Alerta__c alert = new Alerta__c();
                alert.Titulo__c = 'Debe verificar datos de contacto';
                if (client.Fecha_ultima_verificacion__c == null) {
                    alert.Contenido__c = 'Nunca se ha realizado la comprobacion';
                } else {
                    alert.Contenido__c =
                        'La ultima verificacion de los datos de contacto fue el: ' +
                        client.Fecha_ultima_verificacion__c.format();
                }
                alert.Tipo_de_Alerta__c = 'Exclamacion';
                alert.Cuenta__c = client.Id;
                alert.Eliminable__c = false;
                insert alert;
            }
        }
    }

    private void createCustomAlerts() {
        List<Definicion_de_Alerta__c> defs = [
            SELECT Id, Name, Descripcion__c, Query__c, Tipo_de_Alerta__c
            FROM Definicion_de_Alerta__c
            WHERE Activa__c = TRUE
        ];
        List<Account> accs;
        List<Alerta__c> newAlerts = new List<Alerta__c>();
        for (Definicion_de_Alerta__c def : defs) {
            accs = Database.query('SELECT Id FROM Account WHERE ' + def.Query__c + ' AND Id = \'' + client.Id + '\'');
            if (accs.size() > 0) {
                Alerta__c alert = new Alerta__c();
                alert.Titulo__c = def.Name;
                alert.Contenido__c = def.Descripcion__c;
                alert.Tipo_de_Alerta__c = def.Tipo_de_Alerta__c;
                alert.Cuenta__c = client.Id;
                alert.Definicion_de_Alerta__c = def.Id;
                alert.Eliminable__c = false;
                newAlerts.add(alert);
            }
        }
        insert newAlerts;
    }

    private void showAlerts() {
        alerts = [
            SELECT Id, Titulo__c, Contenido__c, Tipo_de_Alerta__c, Eliminable__c, Oportunidad__c, Cuenta__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id AND Titulo__c != 'Es un cliente de Venta Directa.'
        ];
    }
}