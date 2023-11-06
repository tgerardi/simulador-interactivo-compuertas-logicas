/**
 * @description       :
 * @author            : Agustin Ignacio Martinez Bisagno
 * @group             : Xappia
 * @jirasAffected     : INT-370
 * @last modified on  : 04-10-2023
 * @last modified by  : Victor M. Degano
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   Unknown      Unknown       Unknown
 * 1.0   19-09-2023   Victor Degano Se bloquea las polizas de Qualis (Productor 606)
 **/
public with sharing class GestionarPolizaController {
    private PolicyResender policyResender { get; set; } // Jira 1603
    public PolicyRequestCustomObject actualPW { get; set; }

    public String nombreTC { get; set; }
    public String apellidoTC { get; set; }
    public String mesTC { get; set; }
    public String anioTC { get; set; }
    public String codeTC { get; set; }

    public List<SelectOption> monthsTC { get; set; }
    public List<SelectOption> yearsTC { get; set; }

    public Account client;
    public Case caseForTheCall { get; set; }
    public Task telephoneCall { get; set; }

    public boolean hasCaseId = false;
    public Boolean isSaving { get; set; }
    private Boolean isCallCenterAgentUser { get; set; } // jira 1479
    public boolean clientWithEducationProduct { get; set; }
    public boolean clientProductsUpdated { get; set; }
    public boolean bajaIndividualSapienzaFieldsCompleted { get; set; }
    public Boolean isAClaimUser { get; set; }
    private Boolean isSinisterUser { get; set; }
    public Boolean isOperadorExternoUser { get; set; }
    public boolean tryingToSaveACancelationRequestWithoutPolicy = false;
    public boolean isBaja { get; set; }
    public boolean isCambioMedioPago { get; set; }
    public boolean isCambioDomicilio { get; set; }
    public boolean isCambioPlan { get; set; }
    public boolean isReenvioPoliza { get; set; }
    public boolean isRechazaTransformacion { get; set; }
    public boolean isRetencion { get; set; }
    public boolean isCambioBien { get; set; }
    public boolean isDeclararSiniestro { get; set; }
    public boolean isCambioDeBeneficiarios { get; set; }
    // public boolean hasAMegaservicioRequest { get; set; } // Deprecado EV184

    public boolean isPayingWithCreditCard { get; set; }

    public boolean cancellationReasonSelectedMatches { get; set; }
    public boolean cancellationResultSelectedMatches { get; set; }
    // public boolean showMegaservicioButton { get; set; } // Deprecado EV1484
    public Boolean showCiberSeguridadServicioButton { get; set; }
    public boolean isAnErrorWithTheReasonForTheCall { get; set; }
    public boolean isAnErrorWithTheResultForTheCall { get; set; }
    public boolean isBonificable;

    public String recordTypeBaja;
    public String recordTypeCambioMedioPago;
    public String recordTypeCambioPlan;
    public String recordTypeReenvioPoliza;
    public String recordTypeRechazaTransformacion;
    public String recordTypeRetencion;
    public String recordTypeCambioDomicilio;
    public String recordTypeCambioBien;
    public String recordTypeDeclararSiniestro;
    public String recordTypeCambioDeBeneficiarios;
    // public String recordTypeMegaservicio; // Deprecado EV1484
    public String combinatoria { get; set; }
    public String retType { get; set; }
    public String requestToStart { get; set; }
    public String module_changed { get; set; }
    public String accId;
    public String callType;
    public String opptId;
    public String selectPolizas = '';
    public String actualUserProfile = '';
    public String resultsForReasonOtroAndCallTypeIn;

    private List<Case> casesToAnalyze { get; set; } // jira 1479
    public List<Producto__c> products;
    public List<Poliza__c> policies;
    public List<Gestion__c> retentionRequestToCheckDuplicates { get; set; }
    public List<Gestion__c> requestToCheckDuplicates { get; set; }
    public List<Gestion__c> cambioPlanRequestToCheckDuplicates { get; set; }

    public List<String> policiesAlreadySelectedForRetention { get; set; }
    public List<String> availableReasonValues { get; set; }
    public List<String> availableResultValues { get; set; }
    public List<String> sucursalChannels { get; set; }

    public List<PolicyRequestCustomObject> policyRequestCustomList { get; set; }
    public List<policyRequestCustomObject> preSavedChangeOfPlanRequests { get; set; }
    public List<policyRequestCustomObject> preSavedRetentionOfPlanRequests { get; set; }
    public List<policyRequestCustomObject> preSavedCancellationRequests { get; set; }

    public List<Baja_Prima_Unica__c> bajaPrimaUnicaCustomSetting { get; set; }
    public List<Baja_Individual_Sapienza__mdt> sapienzaMdt { get; set; }
    public List<Combinacion_Modulo_Servicios__c> combinacionesModuloServicio { get; set; }
    public List<Combinatoria> combinatorias { get; set; }
    public List<Cambio_Medio_de_Pago__c> mediosDePagoPorProducto { get; set; }
    public List<Origen_de_Pago__c> origenesDePago { get; set; }

    public Map<String, String> deprecatedProductsForReintegro { get; set; }
    // public Map<String, String> resultsByChannel { get; set; }
    // public Map<String, String> resultsByChannel2 { get; set; }

    public Map<String, List<Poliza__c>> clientPoliciesMap { get; set; }
    public Map<String, List<Poliza__c>> ramoAndProductoIdClientPolicies { get; set; }

    public Map<String, List<Cambio_Medio_de_Pago__c>> allPaymentMethods { get; set; }
    public Map<Id, RecordType> allRecordTypes { get; set; }

    //----Polizas
    public List<Poliza__c> polizasBaja;
    public String dinamicWhereBaja =
        ' AND Estado__c =\'' +
        String.escapeSingleQuotes('VIGENTE') +
        '\'' +
        //+ ' AND (NOT(Ramo_idBhseg__c = \'17\' AND Producto_IdBHSeg__c IN (\'501\')))'
        ' AND ((NOT(Obligatoria__c = true)) OR Producto_IdBHSeg__c =\'' +
        String.escapeSingleQuotes('176') +
        '\'' +
        ' OR Producto_IdBHSeg__c =\'' +
        String.escapeSingleQuotes('178') +
        '\')'+
        ' AND (NOT(Ramo_idBhseg__c = \'19\' AND Producto_IdBHSeg__c = \'272\' AND Productor_IdBHSeg__c =\'606\'))';

    public List<Poliza__c> polizasCambioMedioPago;
    public String dinamicWhereCambioMedioPago =
        ' AND Estado__c =\'' +
        String.escapeSingleQuotes('VIGENTE') +
        '\'' +
        ' AND ((NOT(Obligatoria__c = true)) OR Producto_IdBHSeg__c =\'' +
        String.escapeSingleQuotes('176') +
        '\'' +
        ' OR Producto_IdBHSeg__c =\'' +
        String.escapeSingleQuotes('178') +
        '\')' +
        ' AND (NOT(Ramo_idBhseg__c = \'17\' AND Producto_IdBHSeg__c IN (\'501\')))' +
        ' AND (NOT(Ramo_idBhseg__c = \'19\' AND Producto_IdBHSeg__c = \'272\' AND Productor_IdBHSeg__c =\'606\'))';

    public List<Poliza__c> polizasCambioPlan;
    public String dinamicWhereCambioPlan =
        ' AND Estado__c =\'' +
        String.escapeSingleQuotes('VIGENTE') +
        '\'' +
        ' AND ((NOT(Obligatoria__c = true)) OR Producto_IdBHSeg__c =\'' +
        String.escapeSingleQuotes('176') +
        '\'' +
        ' OR Producto_IdBHSeg__c =\'' +
        String.escapeSingleQuotes('178') +
        '\')' +
        ' AND (NOT(Ramo_idBhseg__c = \'2\' AND Producto_IdBHSeg__c IN (\'201\',\'202\',\'203\',\'205\',\'210\',\'211\',\'212\',\'213\',\'214\',\'215\')))' +
        ' AND (NOT(Ramo_idBhseg__c = \'9\' AND Producto_IdBHSeg__c IN (\'201\',\'202\',\'211\',\'212\',\'213\',\'221\',\'222\',\'223\',\'224\',\'225\',\'253\',\'280\',\'301\')))' +
        ' AND (NOT(Ramo_idBhseg__c = \'17\' AND Producto_IdBHSeg__c IN (\'201\',\'202\',\'203\',\'501\')))' +
        ' AND (NOT(Ramo_idBhseg__c = \'18\' AND Producto_IdBHSeg__c IN (\'201\',\'202\',\'203\',\'204\',\'205\',\'206\',\'211\',\'217\',\'218\')))' +
        ' AND (NOT(Ramo_idBhseg__c = \'20\' AND Producto_IdBHSeg__c IN (\'004\',\'005\',\'006\')))' +
        ' AND (Ramo_idBhseg__c != \'19\'' +
        ' OR (Ramo_idBhseg__c = \'19\' AND Producto_IdBHSeg__c = \'190\'))'+
        ' AND (NOT(Ramo_idBhseg__c = \'19\' AND Producto_IdBHSeg__c = \'272\' AND Productor_IdBHSeg__c =\'606\'))';

    public List<Poliza__c> polizasReenvio;
    public String dinamicWhereReenvio =
        ' AND Estado__c =\'' +
        String.escapeSingleQuotes('VIGENTE') +
        '\'' +
        ' AND (NOT(Ramo_idBhseg__c = \'17\' AND Producto_IdBHSeg__c IN (\'501\')))'+
        ' AND (NOT(Ramo_idBhseg__c = \'19\' AND Producto_IdBHSeg__c = \'272\' AND Productor_IdBHSeg__c =\'606\'))';

    public List<Poliza__c> polizasRechazaTransformacion;
    public String dinamicWhereRechazaTransformacion =
        ' AND Estado__c =\'' +
        String.escapeSingleQuotes('VIGENTE') +
        '\'' +
        ' AND ((NOT(Obligatoria__c = true)) OR Producto_IdBHSeg__c =\'' +
        String.escapeSingleQuotes('176') +
        '\'' +
        ' OR Producto_IdBHSeg__c =\'' +
        String.escapeSingleQuotes('178') +
        '\')' +
        ' AND (NOT(Ramo_idBhseg__c = \'17\' AND Producto_IdBHSeg__c IN (\'501\')))'+
        ' AND (NOT(Ramo_idBhseg__c = \'19\' AND Producto_IdBHSeg__c = \'272\' AND Productor_IdBHSeg__c =\'606\'))';

    public List<Poliza__c> polizasRetencion;
    public String dinamicWhereRetencion =
        ' AND Estado__c =\'' +
        String.escapeSingleQuotes('VIGENTE') +
        '\'' +
        ' AND ((NOT(Obligatoria__c = true)) OR Producto_IdBHSeg__c =\'' +
        String.escapeSingleQuotes('176') +
        '\'' +
        ' OR Producto_IdBHSeg__c =\'' +
        String.escapeSingleQuotes('178') +
        '\')' +
        ' AND (NOT(Ramo_idBhseg__c = \'2\' AND Producto_IdBHSeg__c IN (\'201\',\'202\',\'203\',\'205\',\'210\',\'211\',\'212\',\'213\',\'214\',\'215\')))' +
        ' AND (NOT(Ramo_idBhseg__c = \'9\' AND Producto_IdBHSeg__c IN (\'201\',\'202\',\'211\',\'212\',\'213\',\'221\',\'222\',\'223\',\'224\',\'225\',\'253\',\'280\',\'301\')))' +
        ' AND (NOT(Ramo_idBhseg__c = \'17\' AND Producto_IdBHSeg__c IN (\'201\',\'202\',\'203\',\'501\')))' +
        ' AND (NOT(Ramo_idBhseg__c = \'18\' AND Producto_IdBHSeg__c IN (\'201\',\'202\',\'203\',\'204\',\'205\',\'206\',\'211\',\'217\',\'218\')))' +
        ' AND (NOT(Ramo_idBhseg__c = \'20\' AND Producto_IdBHSeg__c IN (\'004\',\'005\',\'006\')))' +
        ' AND (Ramo_idBhseg__c != \'19\'' +
        ' OR (Ramo_idBhseg__c = \'19\' AND Producto_IdBHSeg__c = \'190\'))'+
        ' AND (NOT(Ramo_idBhseg__c = \'19\' AND Producto_IdBHSeg__c = \'272\' AND Productor_IdBHSeg__c =\'606\'))';

    public List<Poliza__c> polizasCambioDomicilio;
    public String dinamicWhereCambioDomicilio =
        ' AND Estado__c =\'' +
        String.escapeSingleQuotes('VIGENTE') +
        '\'' +
        ' AND ((NOT(Obligatoria__c = true)) OR Producto_IdBHSeg__c =\'' +
        String.escapeSingleQuotes('176') +
        '\'' +
        ' OR Producto_IdBHSeg__c =\'' +
        String.escapeSingleQuotes('178') +
        '\')' +
        ' AND (NOT(Ramo_idBhseg__c = \'17\' AND Producto_IdBHSeg__c IN (\'501\')))'+
        ' AND (NOT(Ramo_idBhseg__c = \'19\' AND Producto_IdBHSeg__c = \'272\' AND Productor_IdBHSeg__c =\'606\'))';

    public List<Poliza__c> polizasCambioBien;
    public String dinamicWhereCambioBien =
        ' AND ( Producto__c like \'' +
        String.escapeSingleQuotes('SEGURO DEL HOGAR%') +
        '\'' +
        +' OR Producto__c like \'' +
        String.escapeSingleQuotes('HOGAR') +
        '\'' +
        ' OR Producto__c like \'' +
        String.escapeSingleQuotes('HOGAR PROTEGIDO%') +
        '\')' +
        ' AND Estado__c =\'' +
        String.escapeSingleQuotes('VIGENTE') +
        '\' ' +
        ' AND (NOT(Ramo_idBhseg__c = \'17\' AND Producto_IdBHSeg__c IN (\'501\')))' +
        ' AND (NOT(Ramo_idBhseg__c = \'2\' AND Producto_IdBHSeg__c IN (\'215\')))'+
        ' AND (NOT(Ramo_idBhseg__c = \'19\' AND Producto_IdBHSeg__c = \'272\' AND Productor_IdBHSeg__c =\'606\'))';

    public List<Poliza__c> polizasDeclararSiniestro;
    public String dinamicWhereDeclararSiniestro =
        ' AND Estado__c =\'' +
        String.escapeSingleQuotes('VIGENTE') +
        '\'' +
        ' AND ((NOT(Obligatoria__c = true)) OR Producto_IdBHSeg__c =\'' +
        String.escapeSingleQuotes('176') +
        '\'' +
        ' OR Producto_IdBHSeg__c =\'' +
        String.escapeSingleQuotes('178') +
        '\')' +
        ' AND (NOT(Ramo_idBhseg__c = \'17\' AND Producto_IdBHSeg__c IN (\'501\')))'+
        ' AND (NOT(Ramo_idBhseg__c = \'19\' AND Producto_IdBHSeg__c = \'272\' AND Productor_IdBHSeg__c =\'606\'))';

    public List<Poliza__c> polizasCambioDeBeneficiarios;
    public String dinamicWhereCambioDeBeneficiarios =
        'AND Estado__c =\'' +
        String.escapeSingleQuotes('VIGENTE') +
        '\'' +
        ' AND (NOT(Obligatoria__c = true)) AND (Ramo_IdBHSeg__c =\'' +
        String.escapeSingleQuotes('18') +
        '\'' +
        ' OR Ramo_IdBHSeg__c =\'' +
        String.escapeSingleQuotes('19') +
        '\'' +
        ' OR Ramo_IdBHSeg__c =\'' +
        String.escapeSingleQuotes('20') +
        '\'' +
        ' OR (Ramo_IdBHSeg__c =\'9\' AND Producto_IdBHSeg__c IN (\'401\',\'402\'))' +
        ')' +
        ' AND (NOT(Ramo_idBhseg__c = \'17\' AND Producto_IdBHSeg__c IN (\'501\')))'+
        ' AND (NOT(Ramo_idBhseg__c = \'19\' AND Producto_IdBHSeg__c = \'272\' AND Productor_IdBHSeg__c =\'606\'))'; //Se restringe para Robo contenido todas las busquedas

    //CONSTRUCTOR AND INIT
    public GestionarPolizaController() {
        try {
            this.iniciarAplicacion();
            this.loadDeprecatedProductsForReintegro();
            this.loadSucursalChannels();
            this.loadPaymentMethods();
            this.loadRecordTypes();
            this.retrieveTodaysRetentionRequestsFromDB();
            this.retrieveAccountRequestsFromDB();
            this.retrieveCambioPlanRequestsFromDB();
            this.isSaving = false;

            if (isBonificable) {
                isBaja = true;
                isCambioDomicilio = true;
                isCambioPlan = true;
                isReenvioPoliza = true;
                isRechazaTransformacion = true;
                isRetencion = true;
                isCambioBien = true;
                isDeclararSiniestro = true;
                isCambioDeBeneficiarios = true;
                caseForTheCall.Reason = 'Modificaciones';
                caseForTheCall.Resultado__c = 'Cambio de Medio de Pago';

                System.currentPageReference().getParameters().put('requestToStart', 'CambioMedioPago');
                showRequest();
            }
        } catch (Exception e) {
            system.debug('Exc: ' + e);
            // CreateApexLog.create(
            // 	new Map<MapLogArgKey, Object> {
            // 		MapLogArgKey.EXCEPTIONINFO => e,
            // 		MapLogArgKey.ASYNC_APEX_LOG => true
            // 	});
            throw e;
        }
    }

    public boolean getAgenteDigital() {
        return 'HS Agente Call Center + Back Office Social'.equalsIgnoreCase(userChecker.getCurrentUser().profile.name) ||
            'Administrador del sistema'.equalsIgnoreCase(userChecker.getCurrentUser().profile.name) ||
            'System Administrator'.equalsIgnoreCase(userChecker.getCurrentUser().profile.name);
    }

    /*CNLS 49*/
    public boolean getCallOrigin() {
        return 'Canal digital'.equalsIgnoreCase(caseForTheCall.Origin);
    }

    public void loadDeprecatedProductsForReintegro() {
        this.deprecatedProductsForReintegro = new Map<String, String>();

        for (Productos_Sin_Planes__mdt record : [SELECT Deprecado__c, Reemplazo__c FROM Productos_Sin_Planes__mdt]) {
            this.deprecatedProductsForReintegro.put(record.Deprecado__c, record.Reemplazo__c);
        }
    }

    public void loadSucursalChannels() {
        this.sucursalChannels = new List<String>();
        String canalesMdt = [SELECT canales__c FROM Canales_Sucursal__mdt LIMIT 1].canales__c;

        if (String.isNotBlank(canalesMdt)) {
            if (canalesMdt.contains(',')) {
                this.sucursalChannels = canalesMdt.split(',');
            }
        }
    }

    //Carga las gestiones del tipo cambio de plan para la cuenta cargada. Utiliza una Query
    private void retrieveCambioPlanRequestsFromDB() {
        this.cambioPlanRequestToCheckDuplicates = [
            SELECT
                id,
                Premio_Plan_Nuevo__c,
                Premio_Plan_Original__c,
                Poliza__c,
                Plan_Original__c,
                Nuevo_Plan__c,
                CreatedById,
                Tipo_Retencion__c,
                recordTypeId
            FROM Gestion__c
            WHERE cuenta__c = :accId AND CreatedById = :system.UserInfo.getUserId() AND RecordTypeId = :recordTypeCambioPlan
        ];
    }

    //Carga las gestiones abiertas hechas para la cuenta cargada. Utiliza una Query
    private void retrieveAccountRequestsFromDB() {
        this.requestToCheckDuplicates = [
            SELECT id, cerrada__c, recordTypeId, cuenta__c, poliza__c, RecordType.Name
            FROM Gestion__c
            WHERE cuenta__c = :accId AND cerrada__c = FALSE
        ];
    }

    //Carga las gestiones de retencion del dia de hoy hechas por el usuario actual para la cuenta cargada.
    private void retrieveTodaysRetentionRequestsFromDB() {
        this.retentionRequestToCheckDuplicates = [
            SELECT
                id,
                Premio_Plan_Nuevo__c,
                Premio_Plan_Original__c,
                Poliza__c,
                Plan_Original__c,
                Nuevo_Plan__c,
                CreatedById,
                Tipo_Retencion__c,
                recordTypeId,
                CreatedDate
            FROM Gestion__c
            WHERE cuenta__c = :accId AND CreatedById = :system.UserInfo.getUserId() AND RecordTypeId = :recordTypeRetencion
        ];
    }

    //Carga los tipos de registros correspondientes a esta pantalla. Utiliza una Query
    private void loadRecordTypes() {
        List<String> availableRecordTypeNames = [SELECT Registros_Disponibles__c FROM Tipo_de_Registro_Gestion_Caso__mdt][0]
            .Registros_Disponibles__c.split(', ');

        this.allRecordTypes = new Map<Id, RecordType>(
            [SELECT Id, Name FROM RecordType WHERE Name IN :availableRecordTypeNames]
        );
    }

    //Carga todas los metodos de pagos en listas en un mapa de clave 'Producto|Ramo'. Utiliza una Query
    private void loadPaymentMethods() {
        this.allPaymentMethods = new Map<String, List<Cambio_Medio_de_Pago__c>>();
        String productoRamoKey;

        List<Cambio_Medio_de_Pago__c> cambioMedioPagoValue;
        for (Cambio_Medio_de_Pago__c aCambioMedioPago : [
            SELECT Codigo_Medio_de_Pago__c, Medio_origen__c, Producto__c, Ramo__c
            FROM Cambio_Medio_de_Pago__c
        ]) {
            productoRamoKey = aCambioMedioPago.Producto__c + '|' + aCambioMedioPago.Ramo__c;

            //Si la clave armada en productoRamoKey esta en el mapa se trae la lista para agregar el nuevo objeto,
            //sino crea una lista con ese objeto.
            if (this.allPaymentMethods.containsKey(productoRamoKey)) {
                cambioMedioPagoValue = this.allPaymentMethods.get(productoRamoKey);
                cambioMedioPagoValue.add(aCambioMedioPago);
            } else {
                cambioMedioPagoValue = new List<Cambio_Medio_de_Pago__c>{ aCambioMedioPago };
            }
            this.allPaymentMethods.put(productoRamoKey, cambioMedioPagoValue);
        }
    }

    public void iniciarAplicacion() {
        this.policyResender = new PolicyResender(); // Jira 1603
        this.casesToAnalyze = new List<Case>(); // Jira 1479
        this.isCallCenterAgentUser = UserChecker.isCallCenterAgentUser(); // jira 1479

        this.clientWithEducationProduct = false;
        this.policiesAlreadySelectedForRetention = new List<String>();
        this.clientProductsUpdated = false;
        // this.resultsByChannel = fillResultsByChannelMap();
        // this.resultsByChannel2 = fillResultsByChannelMap2();

        this.bajaPrimaUnicaCustomSetting = [
            SELECT id, Motivo__c, Ramo__c, Producto__c
            FROM Baja_Prima_Unica__c
            WHERE Name = 'Baja Prima Unica'
        ];

        this.sapienzaMdt = [SELECT Ramo__c, Producto__c, Motivo_Baja__c FROM Baja_Individual_Sapienza__mdt];

        this.combinacionesModuloServicio = [
            SELECT Codigo__c, Descripcion__c
            FROM Combinacion_Modulo_Servicios__c
            ORDER BY Codigo__c ASC
        ];

        this.combinatoria = '';
        this.retType = '';

        this.bajaIndividualSapienzaFieldsCompleted = false;

        // this.showMegaservicioButton = false; // Deprecado EV1484
        this.showCiberSeguridadServicioButton = false;

        this.cancellationReasonSelectedMatches = false;
        this.cancellationResultSelectedMatches = false;

        // this.hasAMegaservicioRequest = false; // Deprecado EV1484

        availableReasonValues = new List<String>();
        availableResultValues = new List<String>();

        accId = Apexpages.currentPage().getParameters().get('accId');
        if (String.isNotBlank(accId)) {
            this.client = [SELECT Id, PersonContactId, PersonEmail, Numero_de_documento__c FROM Account WHERE Id = :accId];
        }

        if (Apexpages.currentPage().getParameters().get('isBonificable') != null) {
            String bonificable = Apexpages.currentPage().getParameters().get('isBonificable');
            if (bonificable == 'true') {
                isBonificable = true;
            } else {
                isBonificable = false;
            }
        } else {
            isBonificable = false;
        }

        callType = Apexpages.currentPage().getParameters().get('callType');
        if (callType == null) {
            callType = 'IN';
        }

        opptId = Apexpages.currentPage().getParameters().get('OpptId');
        if (accId == null) {
            List<User> currentUser = [
                SELECT Id, Ultimo_cliente_consultado__c
                FROM User
                WHERE Id = :System.UserInfo.getUserId()
            ];

            if (currentUser.size() == 1) {
                List<String> parametrsInUser;
                accId = '';
                if (String.isNotBlank(currentUser[0].Ultimo_cliente_consultado__c)) {
                    parametrsInUser = currentUser[0].Ultimo_cliente_consultado__c.split(';');
                    accId = parametrsInUser[0];
                    if (String.isNotBlank(parametrsInUser[1])) {
                        callType = 'OUT';
                    }
                }
            }
        } else {
            ramoAndProductoIdClientPolicies = generateMapWithRamoAndProductIdLikeKey(accId);
            this.clientPoliciesMap = createClientPoliciesMap(accId);
        }

        //checkPaymentMethod Required Data
        products = [
            SELECT Medios_de_Pago_Aceptados__c, Ramo_IdBHSeg__c, Plan_IdBHSeg__c, Producto_IdBHSeg__c
            FROM Producto__c
        ];

        mediosDePagoPorProducto = [
            SELECT name, Medio_origen__c, Codigo_Medio_de_Pago__c, Producto__c, Ramo__c
            FROM Cambio_Medio_de_Pago__c
        ];

        origenesDePago = [SELECT id, Medio_de_pago__c, Codigo__c, Descripcion__c FROM Origen_de_Pago__c];

        selectPolizas =
            ' SELECT Id, Name, Producto__c, Ramo__c, Tipo_Endoso_IdBHSeg__c, Poliza__c, Medio_De_Pago__c, Origen_De_pago__c, Cuenta_Pago__c, Cuenta__c, ' +
            'Certificado__c, Endoso__c, Desde__c, Hasta__c, Estado__c, Plan_idbhseg__c, Ramo_IdBHSeg__c, Canal_1__c, Canal_1_IdBHSeg__c, Canal_2__c, Producto_IdBHSeg__c, ' +
            'Emision__c, Poliza_Anterior__c FROM Poliza__c ' + //Emision agregado por jira 1478
            'WHERE Cuenta__c =\'' +
            String.escapeSingleQuotes(accId) +
            '\'';

        policyRequestCustomList = new List<PolicyRequestCustomObject>();
        preSavedChangeOfPlanRequests = new List<PolicyRequestCustomObject>();
        preSavedRetentionOfPlanRequests = new List<PolicyRequestCustomObject>();
        preSavedCancellationRequests = new List<PolicyRequestCustomObject>();

        isBaja = false;
        isCambioMedioPago = false;
        isCambioPlan = false;
        isReenvioPoliza = false;
        isRechazaTransformacion = false;
        isRetencion = false;
        isCambioDomicilio = false;
        isCambioBien = false;
        isDeclararSiniestro = false;
        isCambioDeBeneficiarios = false;

        isAnErrorWithTheReasonForTheCall = false;
        isAnErrorWithTheResultForTheCall = false;

        this.isSinisterUser = UserChecker.isSinisterAreaUser(); // Jira 1637
        this.isOperadorExternoUser = UserChecker.isOperadorExternoUser(); // Jira 371
        this.isAClaimUser = false;
        Id profileId = userinfo.getProfileId();
        Profile userProfile = [SELECT Name FROM Profile WHERE Id = :profileId];
        String profileName = userProfile.Name;
        if (
            profileName == 'HS Agente Call Center + Back Office' ||
            profileName == 'HS Supervisor Call Center' ||
            profileName == 'Administrador del sistema' ||
            profileName == 'System Administrator' ||
            profileName == 'HS Agente Siniestros'
        ) {
            isAClaimUser = true;
        }

        /*  Si el caseId es null quiere decir que es un caso nuevo. Sino se trae el caso con los
         datos necesarios para llenar los campos.*/
        Id caseId = Apexpages.currentPage().getParameters().get('caseId');
        if (caseId == null) {
            caseForTheCall = new Case();
            caseForTheCall.AccountId = accId;
        } else {
            hasCaseId = true;
            caseForTheCall = [
                SELECT
                    Id,
                    Status,
                    Reason,
                    Resultado__c,
                    Derivado_a__c,
                    Caso_Asociado__c,
                    AccountId,
                    Subject,
                    Origin,
                    Sub_Origen__c,
                    Description
                FROM Case
                WHERE Id = :caseId
            ];
        }
        telephoneCall = new Task();

        fillRecordTypeIds();

        String originParameter = Apexpages.currentPage().getParameters().get('Origin');
        if (String.isNotBlank(originParameter)) {
            this.caseForTheCall.Origin = originParameter;
        }
    }

    // RETENCION-CAMBIO DE PLAN HP PARDO
    public GestionarPolizaController getSelf() {
        return this;
    }

    // public Map<String, String> fillResultsByChannelMap() {
    //     Map<String, String> response = new Map<String, String>();

    //     for (Resultados_Baja_Por_Canal__c record : [SELECT Canal_1__c, Tipo_baja__c FROM Resultados_Baja_Por_Canal__c]) {
    //         if (response.get(record.canal_1__c) == null) {
    //             response.put(record.canal_1__c, record.tipo_baja__c);
    //         }
    //     }

    //     return response;
    // }

    // public Map<String, String> fillResultsByChannelMap2() {
    //     Map<String, String> response = new Map<String, String>();

    //     for (Resultados_Baja_Por_Canal__c record : [
    //         SELECT Canal_1__c, Tipo_baja__c, canal_2__c
    //         FROM Resultados_Baja_Por_Canal__c
    //     ]) {
    //         if (response.get(record.canal_2__c) == null) {
    //             response.put(record.canal_2__c, record.tipo_baja__c);
    //         }
    //     }

    //     return response;
    // }

    public Map<String, List<Poliza__c>> createClientPoliciesMap(String accId) {
        Map<String, List<Poliza__c>> response = new Map<String, List<Poliza__c>>();
        List<Poliza__c> aux;

        /* Se aplica el filtrado de la lista de polizas traidas en el "Showrequest" para limpiar las polizas antes de aplicar el filtro original*/
        for (
            Poliza__c clientPolicy : PolicyHelper.filterCorrelativePolicies(
                [
                    SELECT
                        Id,
                        Name,
                        Producto__c,
                        Ramo__c,
                        Poliza__c,
                        Certificado__c,
                        ramo_idbhseg__c,
                        producto_idbhseg__c,
                        plan_idbhseg__c,
                        Endoso__c,
                        Desde__c,
                        Poliza_Anterior__c,
                        Emision__c, // Jira 1478
                        Hasta__c,
                        Estado__c,
                        Canal_1__c,
                        Canal_1_IdBHSeg__c,
                        Canal_2__c,
                        Certificado_Id_BHSeg__c,
                        Cuenta__c,
                        Medio_de_Pago__c,
                        Origen_de_Pago__c,
                        Cuenta_Pago__c,
                        Premio__c,
                        Productor__c, // Jira 1522
                        Incluye_Camara__c, // Jira 1170
                        Tipo_Endoso_IdBHSeg__c
                    FROM Poliza__c
                    WHERE Cuenta__c = :accId
                ]
            )
        ) {
            if (response.get(clientPolicy.id) == null) {
                aux = new List<Poliza__c>();
                aux.add(clientPolicy);
                response.put(clientPolicy.Id, aux);
            } else {
                aux = response.get(clientPolicy.id);
                aux.add(clientPolicy);
            }

            if (
                clientPolicy.Ramo_IdBHSeg__c == '19' &&
                (clientPolicy.Producto_IdBHSeg__c == '175' ||
                clientPolicy.Producto_IdBHSeg__c == '106')
            ) {
                if (clientPolicy.Estado__c == 'VIGENTE') {
                    this.clientWithEducationProduct = true;
                }
            }
        }
        this.filterCorrelativePolicies(response, accId);

        return response;
    }

    /* @description Filtra las polizas anteriores VIGENTES del mapa, de una poliza perteneciente al mapa*/
    private void filterCorrelativePolicies(Map<String, List<Poliza__c>> policiesMapToFilter, String clientId) {
        List<List<Poliza__c>> policiesToFilter = policiesMapToFilter.values();

        Map<String, List<String>> migratedCodesByTradeProduct = this.getCorrelativeMigrationCodes();

        for (List<Poliza__c> eachPoliza : policiesToFilter) {
            String idOfPolicyToRemove = '';

            idOfPolicyToRemove = this.getPolicyToRemove(eachPoliza[0], policiesToFilter, migratedCodesByTradeProduct);
            System.debug(idOfPolicyToRemove);
            if (String.isNotBlank(idOfPolicyToRemove)) {
                policiesMapToFilter.remove(idOfPolicyToRemove);
            }
        }
    }

    @TestVisible
    private Map<String, List<String>> getCorrelativeMigrationCodes() {
        Map<String, List<String>> result = new Map<String, List<String>>();

        for (Correspondencia_de_Migracion__mdt eachCorrelative : [
            SELECT Label, Producto__c, Productos_Correspondidos__c, Ramo__c
            FROM Correspondencia_de_Migracion__mdt
        ]) {
            result.put(
                eachCorrelative.Ramo__c +
                '-' +
                eachCorrelative.Producto__c,
                eachCorrelative.Productos_Correspondidos__c.split(',')
            );
        }

        return result;
    }

    /*@Description Dada una poliza y una lista de polizas. Retorna el id de una poliza a borrar con el siguiente criterio:
	  - Si 'policyToCheck' esta vigente y tiene poliza anterior, pero la fecha hasta de la poliza anterior aun es mayor al dia de hoy. Retorna el id de 'policyToCheck'
	  - Si 'policyToCheck' esta vigente y tiene poliza anterior, pero la fecha hasta de la poliza anterior aun es menor al dia de hoy. Retorna el id de la poliza anterior
	  - En caso de que no se encuentre una poliza cuyo numero sea igual a la poliza anterior de 'policyToCheck' y se cumpla con alguno de los puntos anteriores, se devuelve emptys tring*/
    @TestVisible
    private String getPolicyToRemove(
        Poliza__c policyToCheck,
        List<List<Poliza__c>> policies,
        Map<String, List<String>> migratedCodesByTradeProduct
    ) {
        // Jira 1478

        for (List<Poliza__c> eachPolicy : policies) {
            //Se asume que policyToCheck es la poliza vieja
            if (this.areCorrelativePolicies(policyToCheck, eachPolicy[0], migratedCodesByTradeProduct)) {
                if (policyToCheck.Hasta__c < eachPolicy[0].Desde__c && policyToCheck.Hasta__c < Date.today()) {
                    return policyToCheck.Id;
                } else {
                    return eachPolicy[0].id;
                }
            }
        }

        return '';
    }

    private Boolean areCorrelativePolicies(
        Poliza__c policyToCheck,
        Poliza__c policyToCompare,
        Map<String, List<String>> migratedCodesByTradeProduct
    ) {
        String mapCode = policyToCompare.ramo_idbhseg__c + '-' + policyToCompare.producto_idbhseg__c;

        return policyToCheck.Poliza__c == policyToCompare.Poliza_Anterior__c &&
            policyToCheck.ramo_idbhseg__c == policyToCompare.ramo_idbhseg__c &&
            ((policyToCheck.producto_idbhseg__c == policyToCompare.producto_idbhseg__c &&
            policyToCheck.plan_idbhseg__c == policyToCompare.plan_idbhseg__c) ||
            (migratedCodesByTradeProduct.containsKey(mapCode) &&
            migratedCodesByTradeProduct.get(mapCode).contains(policyToCheck.producto_idbhseg__c)));
    }

    public Map<String, List<Poliza__c>> generateMapWithRamoAndProductIdLikeKey(String accId) {
        Map<String, List<Poliza__c>> response = new Map<String, List<Poliza__c>>();

        String key = '';
        List<Poliza__c> aux;
        for (Poliza__c clientPolicy : [
            SELECT id, Hasta__c, Ramo_idBhseg__c, Producto_idBhseg__c
            FROM Poliza__c
            WHERE
                Cuenta__c = :accId
                AND (Ramo_idBhseg__c = '18'
                OR Ramo_idbhseg__c = '3')
                AND (Producto_idBhseg__c = '182'
                OR Producto_idBhseg__c = '179')
        ]) {
            key = clientPolicy.Ramo_IdBHSeg__c + ';' + clientPolicy.Producto_IdBHSeg__c;

            if (response.get(key) == null) {
                aux = new List<Poliza__c>();
                aux.add(clientPolicy);
                response.put(key, aux);
            } else {
                aux = response.get(key);
                aux.add(clientPolicy);
            }
        }

        return response;
    }

    public void fillRecordTypeIds() {
        for (RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE IsActive = TRUE]) {
            if (rt.DeveloperName == 'Baja') {
                recordTypeBaja = rt.Id;
                continue;
            } else if (rt.DeveloperName == 'Cambio_Medio_Pago') {
                recordTypeCambioMedioPago = rt.id;
                continue;
            } else if (rt.DeveloperName == 'Cambio_Plan') {
                recordTypeCambioPlan = rt.Id;
                continue;
            } else if (rt.DeveloperName == 'Retencion') {
                recordTypeRetencion = rt.Id;
                continue;
            } else if (rt.DeveloperName == 'Rechaza_Transformacion') {
                recordTypeRechazaTransformacion = rt.Id;
                continue;
            } else if (rt.DeveloperName == 'Cambio_de_Domicilio') {
                recordTypeCambioDomicilio = rt.Id;
                continue;
            } else if (rt.DeveloperName == 'Cambio_de_Domicilio_Bien_Asegurado') {
                recordTypeCambioBien = rt.Id;
                continue;
            } else if (rt.DeveloperName == 'Declaracion_Siniestro') {
                recordTypeDeclararSiniestro = rt.Id;
                continue;
            } else if (rt.DeveloperName == 'Cambio_Beneficiarios') {
                recordTypeCambioDeBeneficiarios = rt.Id;
                continue;
            }
            // Deprecado EV1484
            // if (rt.DeveloperName == 'Megaservicio') {
            //     this.recordTypeMegaservicio = rt.Id;
            //     continue;
            // }
        }
    }

    public void validateShowBajaSapienzaPaymentMethods() {
        PolicyRequestCustomObject bajaRequest = getPolicyRequestCustomObject(recordTypeBaja);
        if (bajaRequest.gestion.Resultado__c != '--Ninguno--') {
            if (bajaRequest.gestion.Fecha_Registro_Fax__c != null) {
                bajaIndividualSapienzaFieldsCompleted = true;
            }
        }
    }

    // Carga las picklist de año y mes de vencimiento para CMDP - tarjeta de credito
    private void initCreditCardMonthsAndYears() {
        String aux;

        this.monthsTC = new List<SelectOption>();
        for (Integer i = 1; i < 13; i++) {
            aux = String.valueOf(i);
            this.monthsTC.add(new SelectOption(aux, aux));
        }

        this.yearsTC = new List<SelectOption>();
        Integer currentYear = Date.today().year();
        Integer limitYear = currentYear + 10;
        while (currentYear < limitYear) {
            aux = String.valueOf(currentYear);
            yearsTC.add(new SelectOption(aux, aux));
            currentYear++;
        }
    }

    public void showRequest() {
        requestToStart = ApexPages.currentPage().getParameters().get('requestToStart');

        String recordType = '';
        String whereClause = '';
        String requestType = '';
        boolean isMultiselect = false;
        boolean createFormController = false;

        if (requestToStart == 'baja') {
            if (isBaja == false) {
                if (!clientProductsUpdated) {
                    boolean updateClientProductsResult = updateClientProducts(accId);
                    this.clientProductsUpdated = updateClientProductsResult;
                    if (!updateClientProductsResult) {
                        return;
                    }
                }

                recordType = recordTypeBaja;
                whereClause = dinamicWhereBaja;

                String polIdToAdd = checkIfTheClientHaveProductsThatMatchRequeriments(accId, false);
                boolean hasAddedAPolicyBecauseOfJira738 = false;
                List<String> polIdsToAdd = new List<String>();
                if (String.isNotBlank(polIdToAdd)) {
                    hasAddedAPolicyBecauseOfJira738 = true;
                    polIdsToAdd.add(polIdToAdd);
                    whereClause =
                        ' AND ( id =\'' +
                        polIdToAdd +
                        '\' OR (Estado__c =\'' +
                        String.escapeSingleQuotes('VIGENTE') +
                        '\'' +
                        ' AND ((NOT(Obligatoria__c = true)) OR Producto_IdBHSeg__c =\'' +
                        String.escapeSingleQuotes('176') +
                        '\'' +
                        ' OR Producto_IdBHSeg__c =\'' +
                        String.escapeSingleQuotes('178') +
                        '\')))';
                }

                polIdToAdd = checkIfTheClientHaveProductsThatMatchRequeriments(accId, true);
                if (String.isNotBlank(polIdToAdd) && hasAddedAPolicyBecauseOfJira738) {
                    polIdsToAdd.add(polIdToAdd);
                    whereClause =
                        ' AND ( (id =\'' +
                        polIdsToAdd[0] +
                        '\' OR id =\'' +
                        polIdsToAdd[1] +
                        '\') OR (Estado__c =\'' +
                        String.escapeSingleQuotes('VIGENTE') +
                        '\'' +
                        ' AND ((NOT(Obligatoria__c = true)) OR Producto_IdBHSeg__c =\'' +
                        String.escapeSingleQuotes('176') +
                        '\'' +
                        ' OR Producto_IdBHSeg__c =\'' +
                        String.escapeSingleQuotes('178') +
                        '\')))';
                } else if (String.isNotBlank(polIdToAdd) && !hasAddedAPolicyBecauseOfJira738) {
                    whereClause =
                        ' AND ( id =\'' +
                        polIdToAdd +
                        '\' OR (Estado__c =\'' +
                        String.escapeSingleQuotes('VIGENTE') +
                        '\'' +
                        ' AND ((NOT(Obligatoria__c = true)) OR Producto_IdBHSeg__c =\'' +
                        String.escapeSingleQuotes('176') +
                        '\'' +
                        ' OR Producto_IdBHSeg__c =\'' +
                        String.escapeSingleQuotes('178') +
                        '\')))';
                }

                requestType = 'BAJA';
                isMultiselect = false;
                isBaja = true;
            }
        }
        if (requestToStart == 'CambioMedioPago') {
            if (isCambioMedioPago == false) {
                if (!clientProductsUpdated) {
                    boolean updateClientProductsResult = updateClientProducts(accId);
                    this.clientProductsUpdated = updateClientProductsResult;
                    if (!updateClientProductsResult) {
                        return;
                    }
                }

                recordType = recordTypeCambioMedioPago;
                whereClause = dinamicWhereCambioMedioPago;
                requestType = 'CAMBIO MEDIO DE PAGO';
                isMultiselect = true;
                isCambioMedioPago = true;
            }
            this.initCreditCardMonthsAndYears();
        }
        if (requestToStart == 'CambioPlan') {
            if (isCambioPlan == false) {
                recordType = recordTypeCambioPlan;
                whereClause = dinamicWhereCambioPlan;
                requestType = 'CAMBIO DE PLAN';
                isCambioPlan = true;
            }
        }
        if (requestToStart == 'Retencion') {
            if (isRetencion == false) {
                if (!clientProductsUpdated && !Test.isRunningTest()) {
                    boolean updateClientProductsResult = updateClientProducts(accId);
                    this.clientProductsUpdated = updateClientProductsResult;
                    if (!updateClientProductsResult) {
                        return;
                    }
                }

                recordType = recordTypeRetencion;
                whereClause = dinamicWhereRetencion;
                requestType = 'RETENCION';
                isRetencion = true;
                Apexpages.currentPage().getParameters().put('isRet', 'true');
            }
        }
        if (requestToStart == 'ReenvioPoliza') {
            if (isReenvioPoliza == false) {
                List<Poliza__c> requiredClientPolicies = new List<Poliza__c>();
                List<Poliza__c> nonRequiredClientPolicies = new List<Poliza__c>();

                for (Poliza__c clientPolicy : [
                    SELECT id, Hasta__c, Estado__c, Optativa__c, Ramo_IdBHSeg__c, Producto_IdBHSeg__c
                    FROM Poliza__c
                    WHERE Cuenta__c = :accId AND Desde__c <= :System.today()
                ]) {
                    if (!clientPolicy.Optativa__c) {
                        requiredClientPolicies.add(clientPolicy);
                    } else if (clientPolicy.Estado__c == 'VIGENTE') {
                        nonRequiredClientPolicies.add(clientPolicy);
                    }
                }

                List<Id> requiredPolicyIds = new List<Id>();
                if (!requiredClientPolicies.isEmpty()) {
                    requiredPolicyIds = returnLastExpiredOrNotRequiredPolicyId(requiredClientPolicies);
                }

                List<Id> nonRequiredPolicyIds = new List<Id>();
                if (!nonRequiredClientPolicies.isEmpty()) {
                    nonRequiredPolicyIds = returnLastExpiredOrNotRequiredPolicyId(nonRequiredClientPolicies);
                }

                if (!requiredPolicyIds.isEmpty() && !nonRequiredPolicyIds.isEmpty()) {
                    List<Id> idsToMatch = new List<Id>();
                    idsToMatch.addAll(requiredPolicyIds);
                    idsToMatch.addAll(nonRequiredPolicyIds);
                    whereClause = ' AND (id IN: requiredPolicyIds OR ID IN: nonRequiredPolicyIds)';
                } else if (!requiredPolicyIds.isEmpty()) {
                    whereClause = ' AND id IN: requiredPolicyIds';
                } else if (!nonRequiredPolicyIds.isEmpty()) {
                    whereClause = ' AND id IN: nonRequiredPolicyIds';
                } else {
                    whereClause = dinamicWhereReenvio;
                }

                requestType = 'REENVIO DE POLIZA';
                isMultiselect = true;
                isReenvioPoliza = true;
            }
        }
        if (requestToStart == 'RechazaTransformacion') {
            if (isRechazaTransformacion == false) {
                recordType = recordTypeRechazaTransformacion;
                whereClause = dinamicWhereRechazaTransformacion;
                requestType = 'RECHAZA TRANSFORMACION';
                isMultiselect = true;
                isRechazaTransformacion = true;
            }
        }
        if (requestToStart == 'CambioDomicilio') {
            if (isCambioDomicilio == false) {
                recordType = recordTypeCambioDomicilio;
                whereClause = dinamicWhereCambioDomicilio;
                requestType = 'CAMBIO DE DOMICILIO';
                isMultiselect = true;
                IsCambioDomicilio = true;
            }
        }
        if (requestToStart == 'CambioBien') {
            if (isCambioBien == false) {
                Gestion__c gestionCambioBien = new Gestion__c(RecordTypeId = recordTypeCambioBien);
                polizasCambioBien = new List<Poliza__c>();

                //jira 1478 (Se agrega el filtrado de polizas)
                List<Poliza__c> policiesAux = Database.query(selectPolizas + dinamicWhereCambioBien);
                policiesAux = PolicyHelper.filterCorrelativePolicies(policiesAux);

                List<String> policiesIdsForInsGood = new List<String>();
                List<Bien_Asegurado__c> listOfInsGoods = new List<Bien_Asegurado__c>();

                for (Poliza__c policy : policiesAux) {
                    listOfInsGoods.addAll(
                        ClientRetriever.callAndProcessWSGetCertificadoBien(
                            policy.Id,
                            String.valueOf(Policy.Ramo_IdBHSeg__c),
                            String.valueOf(policy.Poliza__c),
                            String.valueOf(policy.Certificado__c),
                            String.valueOf(policy.Endoso__c)
                        )
                    );
                    policiesIdsForInsGood.add(policy.Id);
                }

                List<Bien_Asegurado__c> insGoodsInSF = [
                    SELECT Id
                    FROM Bien_Asegurado__c
                    WHERE Poliza__c IN :policiesIdsForInsGood
                ];

                delete insGoodsInSF;
                insert listOfInsGoods;

                List<Bien_Asegurado__c> bienes = [
                    SELECT Id, Poliza__r.Id
                    FROM Bien_Asegurado__c
                    WHERE Poliza__r.Cuenta__c = :accId
                ];

                if (policiesAux.size() > 0) {
                    for (Poliza__c policy : policiesAux) {
                        for (Bien_Asegurado__c bien : bienes) {
                            if (bien.Poliza__r.Id == policy.Id) {
                                polizasCambioBien.add(policy);
                            }
                        }
                    }
                }

                PolicyRequestCustomObject polizasGestion = new PolicyRequestCustomObject(
                    generatePolicyRequestCustomObject(polizasCambioBien),
                    gestionCambioBien,
                    'CAMBIO DE DOMICILIO DEL BIEN ASEGURADO',
                    true,
                    combinacionesModuloServicio,
                    sapienzaMdt,
                    bajaPrimaUnicaCustomSetting,
                    clientPoliciesMap,
                    // resultsByChannel,
                    // resultsByChannel2,
                    this.sucursalChannels
                );
                policyRequestCustomList.add(polizasGestion);
                IsCambioBien = true;
            }
        }
        if (requestToStart == 'DeclararSiniestro') {
            if (isDeclararSiniestro == false) {
                recordType = recordTypeDeclararSiniestro;
                whereClause = dinamicWhereDeclararSiniestro;
                requestType = 'DECLARAR SINIESTRO';
                isMultiselect = false;
                isDeclararSiniestro = true;
                createFormController = true;

                caseForTheCall.Reason = 'Siniestros';
                caseForTheCall.Resultado__c = 'Declaración';
                telephoneCall.Motivo_de_llamado_BO__c = 'Denuncia'; // Jira 1456
            }
        }
        if (requestToStart == 'CambioBeneficiarios') {
            if (isDeclararSiniestro == false) {
                recordType = recordTypeCambioDeBeneficiarios;
                whereClause = dinamicWhereCambioDeBeneficiarios;
                requestType = 'CAMBIO DE BENEFICIARIOS';
                isMultiselect = false;
                isCambioDeBeneficiarios = true;
                System.debug(selectPolizas +
                whereClause +
                ' ORDER BY Hasta__c DESC');
                //Get the beneficiaries of the policies and update them.
                //jira 1478 (Se agrega el filtrado de polizas)
                List<Poliza__c> policiesAuxToBeneficiaries = Database.query(
                    selectPolizas +
                    whereClause +
                    ' ORDER BY Hasta__c DESC'
                );
                policiesAuxToBeneficiaries = PolicyHelper.filterCorrelativePolicies(policiesAuxToBeneficiaries);

                //For every policy, call the service to get the beneficiaries:
                List<Beneficiario__c> newBeneficiaries = new List<Beneficiario__c>();
                List<String> policiesIds = new List<String>();
                for (Poliza__c policy : policiesAuxToBeneficiaries) {
                    policiesIds.add(policy.Id);

                    String codeOfPolicy =
                        accId +
                        ':' +
                        policy.Id +
                        ':' +
                        Policy.Ramo_IdBHSeg__c +
                        ':' +
                        policy.Poliza__c +
                        ':' +
                        policy.Certificado__c +
                        ':' +
                        policy.Endoso__c;

                    newBeneficiaries.addAll(ClientRetriever.getPolicyBeneficiaryDataFromRectorToSF(codeOfPolicy));
                }

                //Delete the oldies and insert the new ones.
                List<Beneficiario__c> beneficiariesInSF = [SELECT Id FROM Beneficiario__c WHERE Poliza__c = :policiesIds];
                delete beneficiariesInSF;
                insert newBeneficiaries;
            }
        }

        //This is what we do when we have decided what type of request is.
        //Generate the wrapper object that is dysplayed in the screen.
        if (requestToStart != 'CambioBien') {
            Gestion__c requestToShow;

            if (String.isNotBlank(recordType)) {
                requestToShow = new Gestion__c(RecordTypeId = recordType);
            } else {
                requestToShow = new Gestion__c();
            }
            List<Poliza__c> policies = new List<Poliza__c>();
            //jira 1478 (Se agrega el filtrado de polizas)
            policies = Database.query(selectPolizas + whereClause + ' ORDER BY Hasta__c DESC');
            System.debug('antes de filtrar ' + policies.size());
            policies = PolicyHelper.filterCorrelativePolicies(policies);
            System.debug('luego de filtrar ' + policies.size());
            //Si El Tipo de operacion a ejecutar  es Reenvio de Poliza, lista todos las polizas.
            //Caso contrario se queda con las polizas vigentes desde el siguiente a hoy
            if (requestType == 'REENVIO DE POLIZA') {
                polizasReenvio = policies;
            } else {
                Integer j = 0;
                while (j < policies.size()) {
                    if (policies.get(j).Desde__c >= System.today().addDays(1)) {
                        policies.remove(j);
                    } else {
                        j++;
                    }
                }
            }

            if (requestType == 'CAMBIO MEDIO DE PAGO') {
                requestToShow.Estado_MKT__c = 'Para Enviar'; //CNLS 19
                policies = checkIfAllPoliciesRetrievedShouldBeShowed(policies);
            }

            if (requestType == 'DECLARAR SINIESTRO') {
                policies = new List<Poliza__c>();
            }

            if (requestType == 'RETENCION') {
                policies = checkIfSomeProductShouldBeReplaced(policies);
            }

            PolicyRequestCustomObject polizasGestion = new PolicyRequestCustomObject(
                generatePolicyRequestCustomObject(policies),
                requestToShow,
                requestType,
                isMultiselect,
                combinacionesModuloServicio,
                sapienzaMdt,
                bajaPrimaUnicaCustomSetting,
                clientPoliciesMap,
                // resultsByChannel,
                // resultsByChannel2,
                this.sucursalChannels
            );

            if ('RETENCION'.equalsIgnoreCase(requestType)) {
                // Jira 1674
                polizasGestion.retentionTemplateRequest = true;
            }

            polizasGestion.gestionarPolizaController = this; // jira 1479

            //In the claim request generate the controller aux of the form.
            if (createFormController) {
                FormRunnerController form = new FormRunnerController();
                form.accIdFromGestionarPoliza = accId;
                form.formName = 'Simplex_V1';
                form.init();
                form.isFromGestionarPoliza = true;
                polizasGestion.FormRunnerController = form;
                if (this.clientWithEducationProduct) {
                    form.clientWithEducationProduct = true;
                }
            }

            policyRequestCustomList.add(polizasGestion);
        }

        if (requestToStart == 'DeclararSiniestro') {
            List<Account> clients = [
                SELECT
                    id,
                    FirstName,
                    LastName,
                    Tipo_de_Documento__c,
                    Numero_de_Documento__c,
                    Phone,
                    PersonEmail,
                    ShippingAddress
                FROM Account
                WHERE Id = :accId
            ];

            List<Domicilio__c> address = [
                SELECT Id, Calle__c, Ciudad__c, Provincia__c
                FROM Domicilio__c
                WHERE Cuenta__c = :accId
            ];

            String clientAddress = '';
            if (address.size() > 0) {
                clientAddress =
                    'Calle ' +
                    address[0].calle__c +
                    ', ' +
                    address[0].Ciudad__c +
                    ', ' +
                    address[0].Provincia__c +
                    '.';
            }

            if (clients.size() > 0) {
                getPolicyRequestCustomObject(recordTypeDeclararSiniestro).gestion.Nombre_notificante__C = clients[0]
                    .FirstName;
                getPolicyRequestCustomObject(recordTypeDeclararSiniestro)
                    .gestion.Tipo_de_Documento_Notificante__c = clients[0].Tipo_de_Documento__c;
                getPolicyRequestCustomObject(recordTypeDeclararSiniestro)
                    .gestion.Numero_de_Documento_Notificante__c = clients[0].Numero_de_Documento__c;
                getPolicyRequestCustomObject(recordTypeDeclararSiniestro).gestion.Telefono_Notificante__c = clients[0]
                    .phone;
                getPolicyRequestCustomObject(recordTypeDeclararSiniestro).gestion.Email_notificante__c = String.valueOf(
                    clients[0].PersonEmail
                );
                getPolicyRequestCustomObject(recordTypeDeclararSiniestro).gestion.Domicilio_Notificante__c = clientAddress;
            }
        }
    }

    public List<Poliza__c> checkIfSomeProductShouldBeReplaced(List<Poliza__c> policies) {
        List<Poliza__c> response = new List<Poliza__c>();
        List<String> policiesToReplace = new List<String>();

        for (Poliza__c policy : policies) {
            String policyRamo = policy.Ramo_IdBHSeg__c;
            boolean hasFound = false;
            for (String record : this.deprecatedProductsForReintegro.keySet()) {
                List<String> aux = record.split('-');
                String ramoDeprecado = aux[0];
                String productoDeprecado = aux[1];
                if (policyRamo == ramoDeprecado && policy.Producto_IdBHSeg__c == productoDeprecado) {
                    hasFound = true;
                    policiesToReplace.add(deprecatedProductsForReintegro.get(record));
                }
            }

            if (!hasFound) {
                response.add(policy);
            }
        }

        if (!policiesToReplace.isEmpty()) {
            if (policiesAlreadySelectedForRetention.isEmpty()) {
                response.addAll(getReplacePolicies(policiesToReplace));
            } else {
                response.addAll(
                    getReplacePolicies(
                        removeAlreadySelectedPolicies(policiesAlreadySelectedForRetention),
                        policiesToReplace
                    )
                );
            }

            response = preventReturningDuplicatedPolicies(response);

            return response;
        }

        return policies;
    }

    public List<Poliza__c> preventReturningDuplicatedPolicies(List<Poliza__c> scope) {
        List<Poliza__c> response = new List<Poliza__c>();

        for (Poliza__c scopeItem : scope) {
            boolean hasFound = false;
            for (Poliza__c responseItem : response) {
                if (scopeItem.Poliza__c == responseItem.Poliza__c) {
                    hasFound = true;
                }
            }

            if (!hasFound) {
                response.add(scopeItem);
            }
        }
        return response;
    }

    public Map<String, List<Poliza__c>> removeAlreadySelectedPolicies(List<String> alreadySelectedPolicyIds) {
        Map<String, List<Poliza__c>> response = new Map<String, List<Poliza__c>>();

        for (String key : this.clientPoliciesMap.keySet()) {
            boolean hasFound = false;
            for (String polId : alreadySelectedPolicyIds) {
                if (polId == key) {
                    hasFound = true;
                }
            }

            if (!hasFound) {
                response.put(key, this.clientPoliciesMap.get(key));
            }
        }

        return response;
    }

    public List<Poliza__c> getReplacePolicies(Map<String, List<Poliza__c>> clientPolicies, List<String> polsToQuery) {
        List<Poliza__c> response = new List<Poliza__c>();

        for (List<Poliza__c> clientPol : clientPolicies.values()) {
            for (String polToQuery : polsToQuery) {
                List<String> aux = polToQuery.split('-');
                String policyRamo = aux[0];
                if (clientPol[0].Ramo_IdBHSeg__c == policyRamo && clientPol[0].Producto_IdBHSeg__c == aux[1]) {
                    response.add(clientPol[0]);
                }
            }
        }
        return response;
    }

    public List<Poliza__c> getReplacePolicies(List<String> polsToQuery) {
        List<Poliza__c> response = new List<Poliza__c>();

        for (List<Poliza__c> clientPol : this.clientPoliciesMap.values()) {
            for (String polToQuery : polsToQuery) {
                List<String> aux = polToQuery.split('-');
                String policyRamo = aux[0];
                if (clientPol[0].Ramo_IdBHSeg__c == policyRamo && clientPol[0].Producto_IdBHSeg__c == aux[1]) {
                    response.add(clientPol[0]);
                }
            }
        }
        return response;
    }

    public List<PolizaWrapper> generatePolicyRequestCustomObject(List<Poliza__c> polices) {
        List<PolizaWrapper> policyRequestCustomListAux = new List<PolizaWrapper>();
        if (polices != null) {
            for (Poliza__c poliza : polices) {
                PolizaWrapper polizaWrapper = new PolizaWrapper(poliza);
                policyRequestCustomListAux.add(polizaWrapper);
            }
        }
        return policyRequestCustomListAux;
    }

    //filter result
    public String getresultsForReasonOtroAndCallTypeIn() {
        resultsForReasonOtroAndCallTypeIn = [
            SELECT Resultados__c
            FROM Resultados_Por_Motivo__c
            WHERE Name = 'Otros_Llamada_Entrante'
        ]
        .Resultados__c;

        return resultsForReasonOtroAndCallTypeIn;
    }

    public String getCallType() {
        return callType;
    }

    public List<Id> returnLastExpiredOrNotRequiredPolicyId(List<Poliza__c> clientPolicies) {
        List<String> idsToReturn = new List<String>();
        Id lastPolId;
        Date lastDate;

        //we save every different ramo in a list
        List<String> ramosProductos = new List<String>();
        ramosProductos.add(clientPolicies[0].Ramo_idbhseg__c + ',' + clientPolicies[0].Producto_IdBHSeg__c);
        for (Poliza__c clientPolicy : clientPolicies) {
            boolean theRamoProductoIsAlreadyInTheList = false;
            for (String ramoProducto : ramosProductos) {
                List<String> ramoYProducto = ramoProducto.split(',');
                String ramo = ramoYProducto[0];
                String producto = ramoYProducto[1];
                if (clientPolicy.Ramo_idbhseg__c == ramo && clientPolicy.Producto_IdBHSeg__c == producto) {
                    theRamoProductoIsAlreadyInTheList = true;
                    break;
                }
            }
            if (!theRamoProductoIsAlreadyInTheList) {
                ramosProductos.add(clientPolicy.Ramo_idbhseg__c + ',' + clientPolicy.Producto_IdBHSeg__c);
            }
        }

        //now we will add the lastest policy of every ramo- producto
        for (String ramoProducto : ramosProductos) {
            boolean firstLap = true;
            for (Poliza__c clientPolicy : clientPolicies) {
                List<String> ramoYProducto = ramoProducto.split(',');
                String ramo = ramoYProducto[0];
                String producto = ramoYProducto[1];
                if (clientPolicy.Ramo_idbhseg__c == ramo && clientPolicy.Producto_IdBHSeg__c == producto) {
                    if (firstLap) {
                        //We supose that the first is the last
                        lastPolId = clientPolicy.id;
                        lastDate = clientPolicy.hasta__c;
                        firstLap = false;
                    }
                    if (clientPolicy.hasta__c > lastDate) {
                        lastPolId = clientPolicy.id;
                        lastDate = clientPolicy.hasta__c;
                    }
                }
            }
            if (String.isNotBlank(lastPolId)) {
                idsToReturn.add(lastPolId);
            }
        }
        return idsToReturn;
    }

    public String checkIfTheClientHaveProductsThatMatchRequeriments(String accId, boolean shouldQueryJira925Products) {
        List<Poliza__c> clientPoliciesThatMatchRamoAndProductRequeriment = new List<Poliza__c>();

        if (shouldQueryJira925Products) {
            if (!ramoAndProductoIdClientPolicies.isEmpty()) {
                List<Poliza__c> auxList1 = new List<Poliza__c>();
                List<Poliza__c> auxList2 = new List<Poliza__c>();

                if (ramoAndProductoIdClientPolicies.get('18;179') != null) {
                    auxList1 = ramoAndProductoIdClientPolicies.get('18;179');
                }

                if (ramoAndProductoIdClientPolicies.get('3;179') != null) {
                    auxList2 = ramoAndProductoIdClientPolicies.get('3;179');
                }

                if (!auxList1.isEmpty()) {
                    clientPoliciesThatMatchRamoAndProductRequeriment.addAll(auxList1);
                }

                if (!auxList2.isEmpty()) {
                    clientPoliciesThatMatchRamoAndProductRequeriment.addAll(auxList2);
                }
            }

            String lastPolId = '';
            if (clientPoliciesThatMatchRamoAndProductRequeriment.size() == 1) {
                return clientPoliciesThatMatchRamoAndProductRequeriment[0].id;
            } else if (clientPoliciesThatMatchRamoAndProductRequeriment.size() > 1) {
                //We supose that the first is the last
                lastPolId = clientPoliciesThatMatchRamoAndProductRequeriment[0].id;
                Date lastDate = clientPoliciesThatMatchRamoAndProductRequeriment[0].hasta__c;

                for (Poliza__c clientPolicy : clientPoliciesThatMatchRamoAndProductRequeriment) {
                    if (clientPolicy.hasta__c > lastDate) {
                        lastPolId = clientPolicy.id;
                        lastDate = clientPolicy.hasta__c;
                    }
                }
            }

            if (String.isnotBlank(lastPolId)) {
                return lastPolId;
            }
        } else {
            if (!ramoAndProductoIdClientPolicies.isEmpty()) {
                List<Poliza__c> auxList3 = new List<Poliza__c>();
                List<Poliza__c> auxList4 = new List<Poliza__c>();

                if (ramoAndProductoIdClientPolicies.get('18;182') != null) {
                    auxList3 = ramoAndProductoIdClientPolicies.get('18;182');
                }

                if (ramoAndProductoIdClientPolicies.get('3;182') != null) {
                    auxList4 = ramoAndProductoIdClientPolicies.get('3;182');
                }

                if (!auxList3.isEmpty()) {
                    clientPoliciesThatMatchRamoAndProductRequeriment.addAll(auxList3);
                }

                if (!auxList4.isEmpty()) {
                    clientPoliciesThatMatchRamoAndProductRequeriment.addAll(auxList4);
                }
            }
            String lastPolId = '';
            if (clientPoliciesThatMatchRamoAndProductRequeriment.size() == 1) {
                return clientPoliciesThatMatchRamoAndProductRequeriment[0].id;
            } else if (clientPoliciesThatMatchRamoAndProductRequeriment.size() > 1) {
                //We supose that the first is the last
                lastPolId = clientPoliciesThatMatchRamoAndProductRequeriment[0].id;
                Date lastDate = clientPoliciesThatMatchRamoAndProductRequeriment[0].hasta__c;

                for (Poliza__c clientPolicy : clientPoliciesThatMatchRamoAndProductRequeriment) {
                    if (clientPolicy.hasta__c > lastDate) {
                        lastPolId = clientPolicy.id;
                        lastDate = clientPolicy.hasta__c;
                    }
                }
            }

            if (String.isnotBlank(lastPolId)) {
                return lastPolId;
            }
        }

        return '';
    }

    public List<Poliza__c> checkIfAllPoliciesRetrievedShouldBeShowed(List<Poliza__c> allPolicies) {
        List<Poliza__c> availablePolicies = new List<Poliza__c>();

        List<Cambio_Medio_de_Pago__c> customSetting = [SELECT Ramo__c, Producto__c FROM Cambio_Medio_de_Pago__c];

        if (!customSetting.isEmpty() && !allPolicies.isEmpty()) {
            for (Poliza__c policyRetrieved : allPolicies) {
                for (Cambio_Medio_de_Pago__c csRecord : customSetting) {
                    if (
                        policyRetrieved.Ramo_IdBHSeg__c == csRecord.Ramo__c &&
                        policyRetrieved.Producto_IdBHSeg__c == csRecord.Producto__c
                    ) {
                        //if either the ramo and the product of the policy match some cambio de medio de pago row, its becouse this product have some payment method available defined then should be showed
                        availablePolicies.add(policyRetrieved);
                        break;
                    }
                }
            }
        }

        return availablePolicies;
    }

    public void cancelRequest() {
        String requestToCancel = ApexPages.currentPage().getParameters().get('gestionAAnular');
        if (requestToCancel == 'CambioMedioPago') {
            isCambioMedioPago = false;
            deleteFromRequestList(recordTypeCambioMedioPago);
        }

        if (requestToCancel == 'baja') {
            isBaja = false;

            //Delete the pre saved requests and restor the where of the query to the previous stateaccId.
            deleteFromRequestList(recordTypeBaja);
            for (policyRequestCustomObject policyRequest : preSavedCancellationRequests) {
                dinamicWhereBaja = dinamicWhereBaja.replace(
                    ' AND Id != \'' +
                    String.escapeSingleQuotes(policyRequest.selectedPolizaId) +
                    '\'',
                    ' '
                );
            }
            preSavedCancellationRequests = new List<policyRequestCustomObject>();
        }

        if (requestToCancel == 'CambioPlan') {
            isCambioPlan = false;
            deleteFromRequestList(recordTypeCambioPlan);
        }

        if (requestToCancel == 'ReenvioPoliza') {
            isReenvioPoliza = false;
            deleteFromRequestList(recordTypeReenvioPoliza);
        }

        if (requestToCancel == 'RechazaTransformacion') {
            isRechazaTransformacion = false;
            deleteFromRequestList(recordTypeRechazaTransformacion);
        }

        if (requestToCancel == 'Retencion') {
            //Delete the pre saved retention requests.
            List<String> policysIds = new List<String>();
            for (PolicyRequestCustomObject policy : preSavedRetentionOfPlanRequests) {
                policysIds.add(policy.SelectedPolizaId);
            }

            for (String policyId : policysIds) {
                System.currentPageReference().getParameters().put('presevedChangeToDelete', policyId);
                this.deletePreSavedRetention();
            }

            //Delete the retention request.
            isRetencion = false;
            deleteFromRequestList(recordTypeRetencion);
        }

        if (requestToCancel == 'CambioDomicilio') {
            isCambioDomicilio = false;
            deleteFromRequestList(recordTypeCambioDomicilio);
        }

        if (requestToCancel == 'CambioBien') {
            isCambioBien = false;
            deleteFromRequestList(recordTypeCambioBien);
        }

        if (requestToCancel == 'DeclararSiniestro') {
            isDeclararSiniestro = false;
            deleteFromRequestList(recordTypeDeclararSiniestro);
        }

        if (requestToCancel == 'CambioBeneficiarios') {
            isCambioDeBeneficiarios = false;
            deleteFromRequestList(recordTypeCambioDeBeneficiarios);
        }
    }

    // Extracted from PlanChangeController.
    public void cambioDePolizaEnGestionCambioDePlan() {
        if (isCambioPlan) {
            for (PolicyRequestCustomObject policyRequestCustomObject : policyRequestCustomList) {
                if (policyRequestCustomObject.gestion.RecordTypeId == recordTypeCambioPlan) {
                    String polId = policyRequestCustomObject.selectedPolizaId;
                    if (polId != null && polId != '') {
                        // TODO: REFACTORIZAR, YA HAY UN CONSTRUCTOR QUE RECIBE TODO LOS PARAMETROS
                        PlanChangeController planChangeController = new PlanChangeController(null);
                        PlanChangeController.isFromGestionarPoliza = true;
                        PlanChangeController.polIdFromGestionarPoliza = polId;
                        PlanChangeController.startPlanChangeController();
                        policyRequestCustomObject.planChangeController = planChangeController;

                        if (policyRequestCustomObject.planChangeController.isAHogarProtegido) {
                            if (policyRequestCustomObject.planChangeController.calloutError) {
                                ApexPages.currentPage().getParameters().put('gestionAAnular', 'CambioPlan');
                                cancelRequest();
                                return;
                            }

                            combinatorias = new List<Combinatoria>();

                            if (policyRequestCustomObject.planChangeController.getCombinatoria() != null) {
                                combinatorias = policyRequestCustomObject.planChangeController.getCombinatoria();
                            }

                            if (combinatorias.size() == 1) {
                                Combinatoria thisCombinatoria = combinatorias[0];
                                combinatoria = thisCombinatoria.combinatoria;

                                this.setMontosCoberturasFromCS(policyRequestCustomObject);

                                defineServiceOption(policyRequestCustomObject, thisCombinatoria);
                            }
                        }
                    }
                }
            }
        }
    }

    /**
     * Setea los montos de la coberturas en el producto hogar protegido contratado y a contratar desde las
     * Custom Setting Suma_Cobertura__c y Cotizacion__c (Jira 1573)
     */
    public void setMontosCoberturasFromCS(PolicyRequestCustomObject prco) {
        prco.combinatoria = this.combinatoria;
        List<String> combinatoriaAux = this.combinatoria.split('');
        this.setIncendioValuesFromCS(prco, combinatoriaAux[0]);
        this.setContenidoValuesFromCS(prco, combinatoriaAux[1]);
        this.setServiciosValuesFromCS(prco, combinatoriaAux[2]);

        // premios
        Cotizacion__c cotizacion = prco.planChangeController.cotizacionesMap.get(this.combinatoria);
        if (cotizacion != null) {
            String camara = cotizacion.camara__c;
            String premio_mensual = cotizacion.premio__c;
            if (String.isNotBlank(camara)) {
                if (camara.toUpperCase() == 'S') {
                    prco.premios.incluye_camara = true;
                } else if (camara.toLowerCase() == 'N') {
                    prco.premios.incluye_camara = false;
                }
            }
            if (String.isNotBlank(premio_mensual)) {
                prco.premios.premio = Integer.valueOf(premio_mensual);
                prco.premios.premio_diario = prco.premios.premio / 31;
            }
        }

        //A Contratar Values
        prco.incendio_aContratar = prco.incendio.clone();
        prco.contenido_aContratar = prco.contenido.clone();
        prco.servicios_aContratar = prco.servicios.clone();
        prco.premios_aContratar = prco.premios.clone();
        prco.combinatoria_aContratar = prco.combinatoria;

        if (combinatoriaAux.size() == 3) {
            prco.incendio.opcion = combinatoriaAux[0];
            prco.contenido.opcion = combinatoriaAux[1];
            prco.servicios.opcion = combinatoriaAux[2];

            prco.incendio_aContratar.opcion = combinatoriaAux[0];
            prco.contenido_aContratar.opcion = combinatoriaAux[1];
            prco.servicios_aContratar.opcion = combinatoriaAux[2];
        }
    }

    /**
     * Metodo copiado de ProductSellController
     */
    public void setIncendioValuesFromCS(PolicyRequestCustomObject prco, String segmento) {
        Incendio incendio = prco.incendio;
        List<Suma_Cobertura__c> coberturas = prco.planChangeController.sumaCoberturasMap.get('1' + segmento);
        for (Suma_Cobertura__c cobertura : coberturas) {
            if (String.isNotBlank(cobertura.segmento__c)) {
                incendio.opcion = cobertura.segmento__c;
            }
            if (cobertura.cobertura__c == '031') {
                incendio.incendio_de_edificio = Integer.valueOf(cobertura.suma__c);
            }
            if (cobertura.cobertura__c == '032') {
                incendio.incendio_del_contenido = Integer.valueOf(cobertura.suma__c);
            }
            if (cobertura.cobertura__c == '035') {
                incendio.rc_por_incendio_o_explosion = Integer.valueOf(cobertura.suma__c);
            }
            if (cobertura.cobertura__c == '036') {
                incendio.alojamiento_por_incendio_o_explosion = Integer.valueOf(cobertura.suma__c);
            }
            if (cobertura.cobertura__c == '037') {
                incendio.gastos_de_limpieza_por_incendio = Integer.valueOf(cobertura.suma__c);
            }
            if (cobertura.cobertura__c == '040') {
                incendio.responsabilidad_civil_hechos_privados = Integer.valueOf(cobertura.suma__c);
            }
            if (cobertura.cobertura__c == '060') {
                incendio.danios_por_granizo_al_edificio = Integer.valueOf(cobertura.suma__c);
            }
        }
        //addDotsToFormattedFields(incendio);
        prco.incendio_aContratar = prco.incendio.clone();
    }

    public void setContenidoValuesFromCS(PolicyRequestCustomObject prco, String segmento) {
        Contenido contenido = prco.contenido;
        List<Suma_Cobertura__c> coberturas = prco.planChangeController.sumaCoberturasMap.get('2' + segmento);
        for (Suma_Cobertura__c cobertura : coberturas) {
            if (String.isNotBlank(cobertura.segmento__c)) {
                contenido.opcion = cobertura.segmento__c;
            }
            if (cobertura.cobertura__c == '029') {
                contenido.robo_o_hurto_del_contenido_general = Integer.valueOf(cobertura.suma__c);
            }
            if (cobertura.cobertura__c == '033') {
                contenido.electrodomesticos_o_equipos_electronicos = Integer.valueOf(cobertura.suma__c);
            }
            if (cobertura.cobertura__c == '038') {
                contenido.danios_por_robo_o_intento_de_robo = Integer.valueOf(cobertura.suma__c);
            }
            if (cobertura.cobertura__c == '040') {
                contenido.responsabilidad_civil_hechos_privados = Integer.valueOf(Decimal.valueOf(cobertura.suma__c));
            }
            if (cobertura.cobertura__c == '058') {
                contenido.danios_por_agua_al_contenido = Integer.valueOf(cobertura.suma__c);
            }
            if (cobertura.cobertura__c == '034') {
                contenido.rotura_de_cristales = Integer.valueOf(cobertura.suma__c);
            }
            if (cobertura.cobertura__c == '032') {
                contenido.incendio_del_contenido = Integer.valueOf(Decimal.valueOf(cobertura.suma__c));
            }
            if (cobertura.cobertura__c == '055') {
                contenido.responsabilidad_civil_tenencia_de_animales = Integer.valueOf(cobertura.suma__c);
            }
            if (contenido.danios_por_robo_o_intento_de_robo == null) {
                contenido.danios_por_robo_o_intento_de_robo = 0;
            }
        }
        //addDotsToFormattedFields(contenido);
        prco.contenido_aContratar = prco.contenido.clone();
    }

    /**
     * Setea los montos de los servicios del hogar protegido contratado y a contratar
     */
    public void setServiciosValuesFromCS(PolicyRequestCustomObject prco, String segmento) {
        Servicios servicios = prco.servicios;
        List<Suma_Cobertura__c> coberturas = prco.planChangeController.sumaCoberturasMap.get('3' + segmento);
        for (Suma_Cobertura__c cobertura : coberturas) {
            if (cobertura.cobertura__c == '033') {
                servicios.electrodomesticos_o_equipos_electronicos = Integer.valueOf(cobertura.suma__c);
            }
            if (cobertura.cobertura__c == '034') {
                servicios.rotura_de_cristales = Integer.valueOf(cobertura.suma__c);
            }
            if (cobertura.cobertura__c == '053') {
                servicios.robo_o_hurto_en_vacaciones = Integer.valueOf(cobertura.suma__c);
            }
            if (cobertura.cobertura__c == '054') {
                servicios.objetos_especificos = Integer.valueOf(cobertura.suma__c);
            }
            if (cobertura.cobertura__c == '055') {
                servicios.responsabilidad_civil_tenencia_de_animales = Integer.valueOf(cobertura.suma__c);
            }
            if (cobertura.cobertura__c == '058') {
                servicios.danios_por_agua_al_contenido = Integer.valueOf(cobertura.suma__c);
            }
            if (cobertura.cobertura__c == '038') {
                // CNLS Retencion Pardo
                servicios.danios_por_robo_o_intento_de_robo = Integer.valueOf(cobertura.suma__c);
            }
        }
        //addDotsToFormattedFields(servicios);
        prco.servicios_aContratar = prco.servicios.clone();
    }

    public void cambioDePolizaEnGestionRetencion() {
        System.debug('cambioDePolizaEnGestionRetencion()');
        String polId;
        if (isRetencion) {
            for (PolicyRequestCustomObject policyRequestCustomObject : policyRequestCustomList) {
                if (policyRequestCustomObject.gestion.RecordTypeId == recordTypeRetencion) {
                    polId = policyRequestCustomObject.selectedPolizaId;
                    if (String.isNotBlank(polId)) {
                        Apexpages.currentPage().getParameters().put('isRet', 'true');
                        // TODO: REFACTORIZAR, YA HAY UN CONSTRUCTOR QUE RECIBE TODO LOS PARAMETROS
                        PlanChangeController planChangeController = new PlanChangeController(null);
                        PlanChangeController.isFromGestionarPoliza = true;
                        planChangeController.clientIdFromGestionarPoliza = accId;
                        PlanChangeController.retParamFromGestionarPoliza = 'true';
                        PlanChangeController.polIdFromGestionarPoliza = polId;
                        policyRequestCustomObject.planChangeController = planChangeController;
                        policyRequestCustomObject.PlanChangeController.startPlanChangeController();

                        if (policyRequestCustomObject.planChangeController.isAHogarProtegido) {
                            if (policyRequestCustomObject.planChangeController.calloutError) {
                                ApexPages.currentPage().getParameters().put('gestionAAnular', 'Retencion');
                                cancelRequest();
                                return;
                            }

                            List<Combinatoria> combinatorias = new List<Combinatoria>();

                            if (policyRequestCustomObject.planChangeController.getCombinatoria() != null) {
                                combinatorias = policyRequestCustomObject.planChangeController.getCombinatoria();
                            }

                            if (combinatorias.size() == 1) {
                                Combinatoria thisCombinatoria = combinatorias[0];
                                combinatoria = thisCombinatoria.combinatoria;

                                this.setMontosCoberturasFromCS(policyRequestCustomObject);

                                defineServiceOption(policyRequestCustomObject, thisCombinatoria);

                                policyRequestCustomObject.PlanChangeController.checkIfTheClientCanRequestAService_forHogarProtegido(
                                    policyRequestCustomObject.combinatoria,
                                    policyRequestCustomObject.combinatoria_aContratar
                                );
                            }
                        }

                        PolicyRequestCustomObject requestToCopyInTheRetentionList = policyRequestCustomObject.clone();
                        requestToCopyInTheRetentionList.retentionTemplateRequest = false;
                        this.preSavedRetentionOfPlanRequests.add(requestToCopyInTheRetentionList);
                        this.dinamicWhereRetencion +=
                            ' AND Id != \'' +
                            String.escapeSingleQuotes(policyRequestCustomObject.selectedPolizaId) +
                            '\'';
                    }
                }
            }

            //Remove the policy from the list.
            deleteFromRequestList(recordTypeRetencion);
            isRetencion = false;
            System.currentPageReference().getParameters().put('requestToStart', 'Retencion');
            //TODO usar el polId para agregarlo a una lista y luego evaluar en el showrequest que si esa poliza esta en la lista que se va a volver a devolver
            //no la incluya
            policiesAlreadySelectedForRetention.add(polId);
            this.showRequest();
        }
    }

    public void defineServiceOption(PolicyRequestCustomObject policyRequestCustomObject, Combinatoria combinatoria) {
        if (combinatoria.combinatoria.length() == 3) {
            String serviceOption = combinatoria.combinatoria.substring(2, 3);

            if (String.isNotBlank(serviceOption)) {
                if (policyRequestCustomObject != null) {
                    policyRequestCustomObject.servicios.opcion = serviceOption;
                    policyRequestCustomObject.servicios_aContratar.opcion = serviceOption;
                }
            }
        }

        if (String.isNotBlank(policyRequestCustomObject.servicios.opcion)) {
            defineAsistenciaDomiciliaria(policyRequestCustomObject, policyRequestCustomObject.servicios.opcion, true);
            defineAsistenciaDomiciliaria(policyRequestCustomObject, policyRequestCustomObject.servicios.opcion, false);
        }
    }

    /** DEPRECATED?
     * Se ejecuta cuando se selecciona una poliza de hogar protegido.
     * Setea los montos traidos desde Rector al hogar protegido Contratado y A Contratar (copia los del contratado)
     * @param combinatoria tiene los montos de las coberturas traidos desde Rector por web service
     */
    public void assignCombinatoriaValues(PolicyRequestCustomObject policyRequestCustomObject, Combinatoria combinatoria) {
        //COMBINATORIA
        policyRequestCustomObject.combinatoria = combinatoria.combinatoria;

        // The field Poliza__c.Plan_IdBHSeg__c is not required, so the version could be empty.
        // By default it works in 001
        if (
            String.isBlank(policyRequestCustomObject.planChangeController.hogarProtegidoVersion) ||
            policyRequestCustomObject.planChangeController.hogarProtegidoVersion == '001'
        ) {
            //INCENDIO
            policyRequestCustomObject.incendio.incendio_de_edificio = Integer.valueOf(combinatoria.montoCobertura01);
            policyRequestCustomObject.incendio.danios_por_granizo_al_edificio = Integer.valueOf(
                combinatoria.montoCobertura02
            );
            policyRequestCustomObject.incendio.incendio_del_contenido = Integer.valueOf(combinatoria.montoCobertura03);
            policyRequestCustomObject.incendio.rc_por_incendio_o_explosion = Integer.valueOf(combinatoria.montoCobertura04);
            policyRequestCustomObject.incendio.alojamiento_por_incendio_o_explosion = Integer.valueOf(
                combinatoria.montoCobertura05
            );
            policyRequestCustomObject.incendio.gastos_de_limpieza_por_incendio = Integer.valueOf(
                combinatoria.montoCobertura06
            );

            //CONTENIDO
            policyRequestCustomObject.contenido.robo_o_hurto_del_contenido_general = Integer.valueOf(
                combinatoria.montoCobertura07
            );
            policyRequestCustomObject.contenido.danios_por_robo_o_intento_de_robo = Integer.valueOf(
                combinatoria.montoCobertura08
            );
            policyRequestCustomObject.contenido.electrodomesticos_o_equipos_electronicos = Integer.valueOf(
                combinatoria.montoCobertura09
            );

            try {
                policyRequestCustomObject.contenido.responsabilidad_civil_hechos_privados = Integer.valueOf(
                    combinatoria.montoCobertura10
                );
            } catch (Exception e) {
                CreateApexLog.create(new Map<MapLogArgKey, Object>{ MapLogArgKey.EXCEPTIONINFO => e });

                List<String> aux = combinatoria.montoCobertura10.split('\\.');
                integer intAux;
                if (aux.size() == 2) {
                    intAux = Integer.valueOf(aux[0]);

                    policyRequestCustomObject.contenido.responsabilidad_civil_hechos_privados = intAux;
                }
            }

            policyRequestCustomObject.contenido.danios_por_agua_al_contenido = Integer.valueOf(
                combinatoria.montoCobertura11
            );

            //SERVICIOS
            policyRequestCustomObject.servicios.rotura_de_cristales = Integer.valueOf(combinatoria.montoCobertura12);
            policyRequestCustomObject.servicios.robo_o_hurto_en_vacaciones = Integer.valueOf(combinatoria.montoCobertura13);
            policyRequestCustomObject.servicios.objetos_especificos = Integer.valueOf(combinatoria.montoCobertura14);
            policyRequestCustomObject.servicios.responsabilidad_civil_tenencia_de_animales = Integer.valueOf(
                combinatoria.montoCobertura15
            );
        } else if (policyRequestCustomObject.planChangeController.hogarProtegidoVersion == '002') {
            //INCENDIO
            policyRequestCustomObject.incendio.incendio_de_edificio = Integer.valueOf(combinatoria.montoCobertura01);
            policyRequestCustomObject.incendio.danios_por_granizo_al_edificio = Integer.valueOf(
                combinatoria.montoCobertura02
            );
            policyRequestCustomObject.incendio.rc_por_incendio_o_explosion = Integer.valueOf(combinatoria.montoCobertura03);
            policyRequestCustomObject.incendio.alojamiento_por_incendio_o_explosion = Integer.valueOf(
                combinatoria.montoCobertura04
            );
            policyRequestCustomObject.incendio.gastos_de_limpieza_por_incendio = Integer.valueOf(
                combinatoria.montoCobertura05
            );
            policyRequestCustomObject.incendio.responsabilidad_civil_hechos_privados = Integer.valueOf(
                combinatoria.montoCobertura06
            );

            //CONTENIDO
            policyRequestCustomObject.contenido.robo_o_hurto_del_contenido_general = Integer.valueOf(
                combinatoria.montoCobertura07
            );
            policyRequestCustomObject.contenido.rotura_de_cristales = Integer.valueOf(combinatoria.montoCobertura08);
            policyRequestCustomObject.contenido.incendio_del_contenido = Integer.valueOf(combinatoria.montoCobertura09);

            try {
                policyRequestCustomObject.contenido.responsabilidad_civil_tenencia_de_animales = Integer.valueOf(
                    combinatoria.montoCobertura10
                );
            } catch (Exception e) {
                CreateApexLog.create(new Map<MapLogArgKey, Object>{ MapLogArgKey.EXCEPTIONINFO => e });

                List<String> aux = combinatoria.montoCobertura10.split('\\.');
                integer intAux;
                if (aux.size() == 2) {
                    intAux = Integer.valueOf(aux[0]);

                    policyRequestCustomObject.contenido.responsabilidad_civil_hechos_privados = intAux;
                }
            }

            policyRequestCustomObject.contenido.danios_por_robo_o_intento_de_robo = Integer.valueOf(
                combinatoria.montoCobertura11
            );

            //SERVICIOS
            policyRequestCustomObject.servicios.electrodomesticos_o_equipos_electronicos = Integer.valueOf(
                combinatoria.montoCobertura12
            );
            policyRequestCustomObject.servicios.danios_por_agua_al_contenido = Integer.valueOf(
                combinatoria.montoCobertura13
            );
            policyRequestCustomObject.servicios.robo_o_hurto_en_vacaciones = Integer.valueOf(combinatoria.montoCobertura14);
            policyRequestCustomObject.servicios.objetos_especificos = Integer.valueOf(combinatoria.montoCobertura15);
        }

        //PREMIO
        if (combinatoria.premio.contains('.')) {
            policyRequestCustomObject.premios.premio = Integer.valueOf(Double.valueOf(combinatoria.premio));
        } else {
            policyRequestCustomObject.premios.premio = Integer.valueOf(combinatoria.premio);
        }
        policyRequestCustomObject.premios.premio_diario = policyRequestCustomObject.premios.premio / 31;

        //A Contratar Values
        policyRequestCustomObject.incendio_aContratar = policyRequestCustomObject.incendio.clone();
        policyRequestCustomObject.contenido_aContratar = policyRequestCustomObject.contenido.clone();
        policyRequestCustomObject.servicios_aContratar = policyRequestCustomObject.servicios.clone();
        policyRequestCustomObject.premios_aContratar = policyRequestCustomObject.premios.clone();
        policyRequestCustomObject.combinatoria_aContratar = policyRequestCustomObject.combinatoria;

        List<String> combinatoriaAux = policyRequestCustomObject.combinatoria.split('');
        if (combinatoriaAux.size() == 3) {
            policyRequestCustomObject.incendio.opcion = combinatoriaAux[0];
            policyRequestCustomObject.contenido.opcion = combinatoriaAux[1];
            policyRequestCustomObject.servicios.opcion = combinatoriaAux[2];

            policyRequestCustomObject.incendio_aContratar.opcion = combinatoriaAux[0];
            policyRequestCustomObject.contenido_aContratar.opcion = combinatoriaAux[1];
            policyRequestCustomObject.servicios_aContratar.opcion = combinatoriaAux[2];
        }
    }

    public void cambioDePolizaEnGestionCambioDeBeneficiario() {
        if (isCambioDeBeneficiarios) {
            for (PolicyRequestCustomObject policyRequestCustomObject : policyRequestCustomList) {
                if (policyRequestCustomObject.gestion.RecordTypeId == recordTypeCambioDeBeneficiarios) {
                    String polId = policyRequestCustomObject.selectedPolizaId;
                    if (polId != null && polId != '') {
                        BeneficiaryChangeController controller = new BeneficiaryChangeController(null);
                        controller.isFromGestionarPolizaController = true;
                        controller.polIdFromGestionarPoliza = polId;
                        policyRequestCustomObject.beneficiaryController = controller;
                        policyRequestCustomObject.beneficiaryController.init(null);
                    }
                }
            }
        }
    }

    public void showPlanChangeOfPlan() {
        try {
            if (isCambioPlan) {
                for (PolicyRequestCustomObject policyRequestCustomObject : policyRequestCustomList) {
                    if (policyRequestCustomObject.gestion.RecordTypeId == recordTypeCambioPlan) {
                        String polId = policyRequestCustomObject.selectedPolizaId;
                        // TODO: REFACTORIZAR, YA HAY UN CONSTRUCTOR QUE RECIBE TODO LOS PARAMETROS
                        PlanChangeController planChangeController = new PlanChangeController(null);
                        planChangeController = policyRequestCustomObject.planChangeController;
                        PlanChangeController.polIdFromGestionarPoliza = polId;
                        planChangeController.isFromGestionarPoliza = true;
                        PlanChangeController.startPlanChangeController();
                        planChangeController.proposedPlanIdParamFromGestionarPoliza = Apexpages.currentPage()
                            .getParameters()
                            .get('planId');

                        planChangeController.showPlan();
                    }
                }
            }
        } catch (Exception e) {
            CreateApexLog.create(new Map<MapLogArgKey, Object>{ MapLogArgKey.EXCEPTIONINFO => e });

            String error = e.getMessage();

            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, error);
            ApexPages.addMessage(msg);
        }
    }

    public void showPlanRetention() {
        System.debug('showPlanRetention()');
        try {
            if (isRetencion) {
                String selectedPolicyOfTheRetention = Apexpages.currentPage().getParameters().get('selectedPolicyId');
                for (PolicyRequestCustomObject policyRequestCustomObject : preSavedRetentionOfPlanRequests) {
                    if (selectedPolicyOfTheRetention == policyRequestCustomObject.selectedPolizaId) {
                        String polId = policyRequestCustomObject.selectedPolizaId;
                        Apexpages.currentPage().getParameters().put('isRet', 'true');
                        // TODO: REFACTORIZAR, YA HAY UN CONSTRUCTOR QUE RECIBE TODO LOS PARAMETROS
                        PlanChangeController planChangeController = new PlanChangeController(null);
                        planChangeController = policyRequestCustomObject.planChangeController;
                        PlanChangeController.clientIdFromGestionarPoliza = accId;
                        PlanChangeController.polIdFromGestionarPoliza = polId;
                        planChangeController.isFromGestionarPoliza = true;
                        PlanChangeController.retParamFromGestionarPoliza = 'true';

                        //policyRequestCustomObject.planChangeController = new PlanChangeController(true, selectedPolicyOfTheRetention,'true', accId, true);

                        policyRequestCustomObject.PlanChangeController.startPlanChangeController();
                        policyRequestCustomObject.planChangeController.proposedPlanIdParamFromGestionarPoliza = Apexpages.currentPage()
                            .getParameters()
                            .get('planRetId');

                        //In this method we have to calculate if the request of 'Megaservicio' is posible to create.
                        policyRequestCustomObject.planChangeController.showPlan();
                    }
                }
            }
        } catch (Exception e) {
            CreateApexLog.create(new Map<MapLogArgKey, Object>{ MapLogArgKey.EXCEPTIONINFO => e });

            String error = e.getMessage();

            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, error);
            ApexPages.addMessage(msg);
        }

        //control megaservicio button display
        // controlMegaServicioButtonDisplay(preSavedRetentionOfPlanRequests); // Deprecado EV1484
    }

    public void createANewChangeOfPlanRequest() {
        if (isCambioPlan) {
            boolean hasError = false;
            for (PolicyRequestCustomObject policyRequestCustomObject : policyRequestCustomList) {
                if (policyRequestCustomObject.gestion.RecordTypeId == recordTypeCambioPlan) {
                    if (
                        policyRequestCustomObject.selectedPolizaId == null &&
                        policyRequestCustomObject.gestion.RecordTypeId == recordTypeCambioPlan
                    ) {
                        String error = 'Debe seleccionar una poliza para el tipo Cambio de Plan.';
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, error);
                        ApexPages.addMessage(msg);
                        hasError = true;
                    }
                    if (
                        policyRequestCustomObject.planChangeController.proposedPlanDesc == '' ||
                        policyRequestCustomObject.planChangeController.proposedPlanDesc == null ||
                        policyRequestCustomObject.planChangeController.proposedPlanDesc == 'null'
                    ) {
                        ApexPages.addMessage(
                            new ApexPages.Message(ApexPages.Severity.ERROR, 'Debe seleccionar el nuevo plan')
                        );
                        hasError = true;
                    }

                    if (policyRequestCustomObject.gestion.RecordTypeId == recordTypeCambioPlan && !HasError) {
                        policyRequestCustomObject.createALabelPreSavedPlan();
                        preSavedChangeOfPlanRequests.add(policyRequestCustomObject);
                        dinamicWhereCambioPlan +=
                            ' AND Id != \'' +
                            String.escapeSingleQuotes(policyRequestCustomObject.selectedPolizaId) +
                            '\'';
                    }
                }
            }
            if (!hasError) {
                deleteFromRequestList(recordTypeCambioPlan);
                isCambioPlan = false;
                System.currentPageReference().getParameters().put('requestToStart', 'CambioPlan');
                this.showRequest();
            }
        }
    }

    public PageReference selectAllPolicies() {
        return null;
    }

    public List<Origen_de_Pago__c> getPaymentCodesValues(String selected) {
        return [SELECT Codigo__c, Medio_de_Pago__c FROM Origen_de_pago__c WHERE Descripcion__c = :selected];
    }

    public String getAvailablePaymentMethods(String producto, String ramo) {
        //we take from cs the codes
        List<Cambio_Medio_de_Pago__c> codes = this.allPaymentMethods.get(producto + '|' + ramo);

        String responseString = '';
        if (codes.size() > 0) {
            //now build a map origenes de pago
            Map<String, String> origenesDePagoMap = new Map<String, String>();
            String key = '';
            for (Origen_de_Pago__c op : origenesDePago) {
                key = op.Medio_de_Pago__c + '-' + op.Codigo__c;
                if (String.isNotBlank(key)) {
                    origenesDePagoMap.put(key, op.Descripcion__c);
                }
            }
            //now retrieve the descriptions and return it
            for (Cambio_Medio_de_Pago__c code : codes) {
                responseString += origenesDePagoMap.get(code.Codigo_Medio_de_Pago__c + '-' + code.Medio_Origen__c) + ' - ';
            }
        }

        if (String.isNotBlank(responseString)) {
            return responseString;
        }

        return '';
    }

    public String checkPaymentMode(PolicyRequestCustomObject cambioMedioDePagoRequest) {
        List<PolizaWrapper> clentPolicies = cambioMedioDePagoRequest.polizasWrapperList;

        Gestion__c req = cambioMedioDePagoRequest.gestion;

        String payTypeSelected = req.Origen_de_Pago__c;

        List<String> policiesIds = new List<String>();
        for (PolizaWrapper pw : clentPolicies) {
            if (pw.selected) {
                policiesIds.add(pw.id);
            }
        }

        policies = [
            SELECT Plan_IdBHSeg__c, Producto_IdBHSeg__c, Ramo_IdBHSeg__c, Producto__c
            FROM Poliza__c
            WHERE id IN :policiesIds
        ];

        //first we take both medio de pago and origin code values
        List<Origen_de_Pago__c> op = getPaymentCodesValues(payTypeSelected);

        String selectedMethodCode, selectedOriginCode, returnString = '';

        if (op.size() == 1) {
            selectedMethodCode = op[0].Medio_de_Pago__c;
            selectedOriginCode = op[0].Codigo__c;

            Map<String, String> theMap = new Map<String, String>();
            String key = '';

            for (Cambio_Medio_de_Pago__c cmp : mediosDePagoPorProducto) {
                key = cmp.Codigo_Medio_de_Pago__c + '-' + cmp.Medio_Origen__c + '-' + cmp.Producto__c + '-' + cmp.Ramo__c;
                theMap.put(key, cmp.Name);
            }

            for (Poliza__c policy : policies) {
                //for each selected policy we look if the payment method is in the map
                String result = theMap.get(
                    selectedMethodCode +
                    '-' +
                    selectedOriginCode +
                    '-' +
                    policy.Producto_IdBHSeg__c +
                    '-' +
                    policy.Ramo_IdBHSeg__c
                );

                if (String.isBlank(result)) {
                    //if we will return an error , we should take the available payment methods to add to the error
                    String availablePaymentMethods = getAvailablePaymentMethods(
                        policy.Producto_IdBHSeg__c,
                        policy.Ramo_IdBHSeg__c
                    );

                    returnString +=
                        'El medio de pago ' +
                        payTypeSelected +
                        ' no esta disponible para la poliza: ' +
                        policy.Producto__c +
                        '. ' +
                        'Los medios de pago aceptados para esta poliza son: ' +
                        availablePaymentMethods +
                        '.' +
                        '<br />';
                }
            }
        }

        if (String.isNotBlank(returnString)) {
            return returnString;
        }

        return '';
    }
    // Deprecado EV1484
    // public void checkIfAllProductsInRetentionRequestCanGenerateAMegaservicioRequest(
    //     List<Gestion__c> presavedRetentions,
    //     List<PolicyRequestCustomObject> wrappers
    // ) {
    //     //if the megaservicio button shouldnt be showed is becouse the megaservicio shouldnt be inserted

    //     System.debug('checkIfAllProductsInRetentionRequestCanGenerateAMegaservicioRequest');

    //     boolean thereIsAHogarProtegidoMegaservicio = false;
    //     for (PolicyRequestCustomObject wrapper : wrappers) {
    //         if (wrapper.planChangeController.isAHogarProtegido && wrapper.planChangeController.ServiceRequest != null) {
    //             thereIsAHogarProtegidoMegaservicio = true;
    //             break;
    //         }
    //     }

    //     if (!showMegaservicioButton && !thereIsAHogarProtegidoMegaservicio) {
    //         Integer i = 0;
    //         Integer position = 0;

    //         for (Gestion__c presavedRetention : presavedRetentions) {
    //             if (presavedRetention.RecordTypeId == recordTypeMegaservicio) {
    //                 position = i;
    //             }
    //             i++;
    //         }
    //         if (presavedRetentions[position].recordtypeId == recordTypeMegaservicio) {
    //             presavedRetentions.remove(position);
    //         }
    //     }
    // }
    //TODO: Refactorizar, tiene mas sentido que esto devuelva un booleano y que luego se arme el mensaje que retornar directamente un string vacio
    public String checkCancellationDate() {
        //if there's no policy selected: exit
        if (String.isBlank(this.getPolicyRequestCustomObject(recordTypeBaja).selectedPolizaId)) {
            return '';
        }

        Gestion__c req = this.getPolicyRequestCustomObject(recordTypeBaja).gestion;

        if (req.Fecha_Registro_Fax__c < System.today()) {
            return 'La fecha de baja no puede ser anterior al día de la fecha,' + ' por favor corriga la misma.';
        }

        return '';
    }

    //TODO: Este metodo deberia chequear contra todas las listas, no solo contra la de custom list.
    public String controlFutureMethodCalls() {
        List<PolizaWrapper> selectedPolicies = new List<PolizaWrapper>();

        for (PolicyRequestCustomObject policyRequestCustomObject : this.policyRequestCustomList) {
            if (policyRequestCustomObject.polizasWrapperList != null) {
                for (PolizaWrapper policy : policyRequestCustomObject.polizasWrapperList) {
                    if (policy.selected) {
                        selectedPolicies.add(policy);
                    }
                }
            }
        }
        if (selectedPolicies.size() > 50) {
            return Label.Limite_de_Gestiones;
        }

        return '';
    }

    public String validatePaymentData(PolicyRequestCustomObject pw) {
        String origenDePagoGestion = pw.gestion.Origen_de_Pago__c;
        String cuentaDePagoGestion = pw.gestion.Cuenta_de_Pago__c;

        for (PolizaWrapper pwPolicy : pw.polizasWrapperList) {
            if (pwPolicy.selected) {
                if (String.isBlank(origenDePagoGestion) || String.isBlank(cuentaDePagoGestion)) {
                    return 'Debe completar todos los campos requeridos.';
                }
            }
        }

        return '';
    }

    public String checkPaymentData(PolicyRequestCustomObject pw) {
        String medioDePagoGestion = pw.gestion.Medio_de_Pago__c;
        String origenDePagoGestion = pw.gestion.Origen_de_Pago__c;
        String cuentaDePagoGestion = pw.gestion.Cuenta_de_Pago__c;

        for (PolizaWrapper pwPolicy : pw.polizasWrapperList) {
            if (pwPolicy.selected) {
                if (
                    pwPolicy.medioDePago == medioDePagoGestion &&
                    pwPolicy.origenDePago == origenDePagoGestion &&
                    pwPolicy.cuentaDePago == cuentaDePagoGestion
                ) {
                    return 'Los datos de medio de pago nuevos deben diferir a los antiguos.';
                }
            }
        }

        return '';
    }
    // // TODO: to deprecate
    // public boolean checkIfCancellationRequestsShouldBeSetAsSinNota(
    //     List<PolicyRequestCustomObject> presaved,
    //     PolicyRequestCustomObject actual
    // ) {
    //     if (
    //         actual != null &&
    //         String.isNotBlank(actual.gestion.resultado__c) &&
    //         actual.gestion.resultado__c.contains('Sin')
    //     ) {
    //         return true;
    //     }

    //     for (PolicyRequestCustomObject pol : presaved) {
    //         if (pol.gestion.resultado__c.contains('Sin')) {
    //             return true;
    //         }
    //     }

    //     return false;
    // }

    public boolean checkIfWeAreSavingJustAClaimRequestWithFalseResult() {
        for (PolicyRequestCustomObject PolicyRequestCustomObject : policyRequestCustomList) {
            if (PolicyRequestCustomObject.gestion.RecordTypeId == recordTypeDeclararSiniestro) {
                if (!PolicyRequestCustomObject.FormRunnerController.formResult) {
                    return true;
                }
            }
        }

        return false;
    }

    // Refactoreo por jira 1637
    private void createApexMessage(ApexPages.Severity severityOfMessage, String apexMessage) {
        ApexPages.addMessage(new ApexPages.Message(severityOfMessage, apexMessage, ''));
    }

    // Refactoreo por jira 1637
    private Boolean validateMotivoLlamadaForSinisterUsers() {
        if (this.isSinisterUser && !GestionarPolizaValidator.validateMotivoDeLlamadaCompleted(this.telephoneCall)) {
            // Jira 1456
            this.createApexMessage(ApexPages.Severity.ERROR, 'Debe Seleccionar un Motivo de Llamada.');
            return false;
        }
        return true;
    }

    private void changeAllCancellationsToClientConflictiveIfOneHasMarkedAsConflictive(){
        PolicyRequestCustomObject actualCancellationRequest = this.getPolicyRequestCustomObject(this.recordTypeBaja);
        Boolean hasSetToConflictiveClient = this.checkIfCancellationRequestsShouldBeSetAsConflictiveClient(
            this.preSavedCancellationRequests,
            actualCancellationRequest
        );

        if (hasSetToConflictiveClient) {
            final String CONFLICTIVE_CLIENT = 'Venta No Retenida / Cliente conflictivo';
            for (PolicyRequestCustomObject policy : this.preSavedCancellationRequests) {
                if (!CONFLICTIVE_CLIENT.equalsIgnoreCase(policy.gestion.Resultado__c)) {
                    policy.gestion.Resultado__c = CONFLICTIVE_CLIENT;
                }
            }

            if (
                actualCancellationRequest != null &&
                String.isNotBlank(actualCancellationRequest.gestion.Resultado__c) &&
                !CONFLICTIVE_CLIENT.equalsIgnoreCase(actualCancellationRequest.gestion.Resultado__c)
            ) {
                actualCancellationRequest.gestion.Resultado__c = CONFLICTIVE_CLIENT;
            }
        }

    }

    public boolean checkIfCancellationRequestsShouldBeSetAsConflictiveClient(
        List<PolicyRequestCustomObject> presaved,
        PolicyRequestCustomObject actual
    ) {
        final String CONFLICTIVE_CLIENT = 'Venta No Retenida / Cliente conflictivo';
        if (
            CONFLICTIVE_CLIENT.equalsIgnoreCase(actual?.gestion.resultado__c)
        ) {
            return true;
        }

        for (PolicyRequestCustomObject pol : presaved) {
            if (CONFLICTIVE_CLIENT.equalsIgnoreCase(pol.gestion.resultado__c)) {
                return true;
            }
        }

        return false;
    }


    // // Refactoreo por jira 1637
    // private void changeAllCancellationsToSinNotaIfHasAtLeastOneSinNota() {
    //     PolicyRequestCustomObject actualCancellationRequest = this.getPolicyRequestCustomObject(this.recordTypeBaja);
    //     Boolean hasSetToSinNota = this.checkIfCancellationRequestsShouldBeSetAsSinNota(
    //         this.preSavedCancellationRequests,
    //         actualCancellationRequest
    //     );
    //     if (hasSetToSinNota) {
    //         for (PolicyRequestCustomObject policy : this.preSavedCancellationRequests) {
    //             if (policy.gestion.Resultado__c != 'Venta No Retenida / Cliente conflictivo') {
    //                 policy.gestion.Resultado__c = 'Venta No Retenida / No Interesado / Sin Nota';
    //             }
    //         }

    //         if (
    //             actualCancellationRequest != null &&
    //             String.isNotBlank(actualCancellationRequest.gestion.Resultado__c) &&
    //             actualCancellationRequest.gestion.Resultado__c != 'Venta No Retenida / Cliente conflictivo'
    //         ) {
    //             actualCancellationRequest.gestion.Resultado__c = 'Venta No Retenida / No Interesado / Sin Nota';
    //         }
    //     }
    // }

    //Refactoreo Jira 1637
    private void checkIfCorrespondReintegroForCancellationsRequest() {
        PolicyRequestCustomObject actualCancellationRequest = this.getPolicyRequestCustomObject(this.recordTypeBaja);

        //depends the cancellation reason, set the reintegro bool value
        if (actualCancellationRequest != null) {
            this.checkIfCorrespondReintegro(actualCancellationRequest);
        }

        for (PolicyRequestCustomObject aCancellationRequest : this.preSavedCancellationRequests) {
            this.checkIfCorrespondReintegro(aCancellationRequest);
        }
    }

    //Refactoreo Jira 1637
    private void checkIfCorrespondReintegro(PolicyRequestCustomObject aCancellationRequest) {
        if (
            'CLIENTE NO DIO EL CONSENTIMIENTO'.equalsIgnoreCase(aCancellationRequest.gestion.Motivo_Baja__c) ||
            'A PEDIDO DEL ASEGURADO CON REINTEGRO'.equalsIgnoreCase(aCancellationRequest.gestion.Motivo_Baja__c)
        ) {
            aCancellationRequest.gestion.Reintegro__c = true;
        } else if (
            'A PEDIDO DEL ASEGURADO'.equalsIgnoreCase(aCancellationRequest.gestion.Motivo_Baja__c) ||
            'DISCONFORME CON EL SERVICIO'.equalsIgnoreCase(aCancellationRequest.gestion.Motivo_Baja__c)
        ) {
            aCancellationRequest.gestion.Reintegro__c = false;
        }
    }

    //Refactoreo Jira 1637
    private void deleteReenvioDePolizaRequest() {
        //Delete the resend policy request because we dont need to insert it.
        if (this.isReenvioPoliza) {
            this.deleteFromRequestList(this.recordTypeReenvioPoliza);
            this.isReenvioPoliza = false;
        }
    }
    // Deprecado EV1484
    //Refactoreo Jira 1637
    // Verifica que tenga codigo postal el mega servicio
    // private Boolean validateMegaServicioZipCode() {
    //     Set<String> postalCodes = new Set<String>();

    //     for (policyRequestCustomObject presavedRetention : this.preSavedRetentionOfPlanRequests) {
    //         if (
    //             presavedRetention.planChangeController.canRequestAService &&
    //             presavedRetention.planChangeController.ServiceRequest != null
    //         ) {
    //             /**
    //              * si tiene letras devuelve true
    //              */

    //             if (this.checkPostalCode(presavedRetention.planChangeController.ServiceRequest)) {
    //                 this.createApexMessage(ApexPages.Severity.ERROR, 'El Codigo Postal debe contener solo números.');
    //                 return false;
    //             } else {
    //                 postalCodes.add(presavedRetention.planChangeController.ServiceRequest.Codigo_Postal__c);
    //             }
    //         }
    //     }

    //     if (
    //         !postalCodes.isEmpty() && [SELECT Localidad__c FROM Codigo_Postal__c WHERE Codigo__c IN :postalCodes].isEmpty()
    //     ) {
    //         this.createApexMessage(
    //             ApexPages.Severity.ERROR,
    //             'No se encontró ninguna localidad con ese código postal. Revise el número ingresado o consulte a su administrador.'
    //         );
    //         return false;
    //     }

    //     return true;
    // }

    /**
	 * private Boolean validateMegaServicioZipCode(){
		for (policyRequestCustomObject presavedRetention : this.preSavedRetentionOfPlanRequests) {

			if (presavedRetention.planChangeController.canRequestAService 
                && presavedRetention.planChangeController.ServiceRequest != null
                && this.checkPostalCode(presavedRetention.planChangeController.ServiceRequest)) {
               
                this.createApexMessage(
                                ApexPages.Severity.ERROR,
                                'El Codigo Postal Para la Gestion de Megaservicio debe contener solo Numeros.');
                return false;
			}
		}
        return true;
    }
	 */

    //Refactoreo Jira 1637
    // Valida la seleccion de baja de prima unica y la procesa
    private Boolean validateAndProcessBajaPrimaUnica() {
        PolicyRequestCustomObject aBajaPrimaUnica = this.getPolicyRequestCustomObject(this.recordTypeBaja);

        if (aBajaPrimaUnica != null && 'Baja Prima Unica'.equalsIgnoreCase(aBajaPrimaUnica.gestion.Motivo_Baja__c)) {
            if ('--Seleccionar--'.equalsIgnoreCase(aBajaPrimaUnica.selectedResultForBajaPrimaUnica)) {
                this.createApexMessage(ApexPages.Severity.ERROR, 'Seleccione un resultado para continuar.');
                return false;
            }

            if (String.isNotBlank(aBajaPrimaUnica.selectedResultForBajaPrimaUnica)) {
                aBajaPrimaUnica.gestion.Resultado__c = aBajaPrimaUnica.selectedResultForBajaPrimaUnica;
            }
        }

        return true;
    }

    //Refactoreo Jira 1637
    // Valida la seleccion de baja individual sapienza y la procesa
    private Boolean validateAndProcessBajaSapienza() {
        PolicyRequestCustomObject aBajaSapienza = this.getPolicyRequestCustomObject(this.recordTypeBaja);
        if (aBajaSapienza != null && 'Baja Individual Sapienza'.equalsIgnoreCase(aBajaSapienza.gestion.Motivo_Baja__c)) {
            if ('--Seleccionar--'.equalsIgnoreCase(aBajaSapienza.gestion.Resultado__c)) {
                this.createApexMessage(ApexPages.Severity.ERROR, 'Seleccione un resultado para continuar.');
                return false;
            }

            if (
                '--Ninguno--'.equalsIgnoreCase(aBajaSapienza.gestion.Medio_de_Pago__c) ||
                '--Ninguno--'.equalsIgnoreCase(aBajaSapienza.gestion.Origen_de_Pago__c) ||
                String.isBlank(aBajaSapienza.gestion.Cuenta_de_Pago__c)
            ) {
                this.createApexMessage(
                    ApexPages.Severity.ERROR,
                    'Los campos de medio de pago son obligatorios para esta gestion.'
                );
                return false;
            }
        }
        return true;
    }

    //Refactoreo Jira 1637
    private Boolean validateCancellationDate() {
        PolicyRequestCustomObject bajaRequest = this.getPolicyRequestCustomObject(this.recordTypeBaja);
        if (bajaRequest != null) {
            String badDate = this.checkCancellationDate();
            if (String.isNotBlank(badDate)) {
                this.createApexMessage(ApexPages.Severity.ERROR, badDate);
                return false;
            }
        }
        return true;
    }

    //Refactoreo Jira 1637
    // Valida la informacion cargada de los medios de pago para las gestiones de cambio de medio de pago
    private Boolean validatePaymentMethodOfCambioMedioDePagoRequest() {
        PolicyRequestCustomObject cambioMedioDePagoRequest = this.getPolicyRequestCustomObject(
            this.recordTypeCambioMedioPago
        );
        //control pay type

        String errorMessage;

        if (cambioMedioDePagoRequest != null) {
            /** Checkea que los medios de pago esten disponibles. Devuelve '' si esta Ok */
            errorMessage = this.checkPaymentMode(cambioMedioDePagoRequest);
            if (errorMessage != '') {
                this.createApexMessage(ApexPages.Severity.ERROR, errorMessage);
                return false;
            }

            /** Checkea que Medio_de_Pago__c, Origen_de_Pago__c, Cuenta_de_Pago__c sean distintos.
             * Devuelve '' si esta Ok */
            errorMessage = this.checkPaymentData(cambioMedioDePagoRequest);
            if (errorMessage != '') {
                this.createApexMessage(ApexPages.Severity.ERROR, errorMessage);
                return false;
            }

            /** Checkea Origen_de_Pago__c y Cuenta_de_Pago__c no estén vacíos.
             * Devuelve '' si esta Ok */
            errorMessage = this.validatePaymentData(cambioMedioDePagoRequest);
            if (errorMessage != '') {
                this.createApexMessage(ApexPages.Severity.ERROR, errorMessage);
                return false;
            }

            /** Si es tarjeta de credito chequea contra decidir */
            Boolean isDecidir = cambioMedioDePagoRequest.gestion.Medio_de_Pago__c == 'TARJETA DE CREDITO';
            if (isDecidir) {
                errorMessage = this.verificarTarjeta(cambioMedioDePagoRequest);

                if (errorMessage != '') {
                    this.createApexMessage(ApexPages.Severity.ERROR, errorMessage);
                    return false;
                }
            }
        }
        return true;
    }

    public String verificarTarjeta(PolicyRequestCustomObject pw) {
        String nombreTC = this.nombreTC;
        String apellidoTC = this.apellidoTC;
        String mesTC = this.mesTC;
        String anioTC = this.anioTC;
        String codeTC = this.codeTC;
        String numeroDeDocumento = this.client.Numero_de_documento__c;

        if (
            String.isBlank(nombreTC) ||
            String.isBlank(apellidoTC) ||
            String.isBlank(mesTC) ||
            String.isBlank(anioTC) ||
            String.isBlank(codeTC)
        ) {
            return 'Debe ingresar todos los datos de la tarjeta';
        }

        anioTC = anioTC.substring(anioTC.length() - 2, anioTC.length());
        String odp = pw.gestion.Origen_de_Pago__c;
        String mdp = pw.gestion.Medio_de_Pago__c;
        String cdp = pw.gestion.Cuenta_de_Pago__c;

        String response = PaymentMethodController.decidirValidation(
            numeroDeDocumento,
            mdp,
            odp,
            cdp,
            nombreTC,
            apellidoTC,
            mesTC,
            anioTC,
            codeTC
        );

        Map<String, Object> responseReceived = (Map<String, Object>) JSON.deserializeUntyped(response);
        Boolean hasError = (Boolean) responseReceived.get('hasError');

        if (hasError) {
            return (String) responseReceived.get('errorMessage');
        } else {
            pw.gestion.Token_de_Pago__c = (String) responseReceived.get('encryptedPaymentMethod');
            pw.gestion.Cuenta_de_Pago_Encriptada__c = true;
            return '';
        }
    }

    //Refactoreo Jira 1637
    private Boolean validateAndProcessResultAndReasonForTheCall() {
        this.controlResultForTheCall();

        if (this.isAnErrorWithTheResultForTheCall || this.isAnErrorWithTheReasonForTheCall) {
            this.createApexMessage(
                ApexPages.Severity.ERROR,
                'Existe un error con el motivo y el resultado para este tipo de llamada, por favor revise.'
            );
            return false;
        }
        return true;
    }

    // Refactoreo Jira 1637
    // Completa la tarea con lso datos y el tipo llamada
    private void fillTelephoneTask(Task telephone) {
        telephone.Type = 'Llamada';
        telephone.Tipo_de_Comunicacion__c = 'Pedido';
        telephone.WhoId = this.client.PersonContactId;
        telephone.Status = 'Completada';
        telephone.Subject = 'Llamada';

        if (this.callType == 'OUT') {
            telephone.Tipo_de_Llamada__c = 'OUT';
        } else {
            telephone.Tipo_de_Llamada__c = 'IN';
        }
    }

    // Refactoreo Jira 1637
    // Valida los campos del caso para los siniestros y los completa de ser necesario
    private Boolean verifyFieldsAndCompleteSinisterRequest(Case caseForTheCallAux, Task telephoneCallAux) {
        Boolean validationError = false;
        //Control if all the mandatory fields in this type are filled.
        PolicyRequestCustomObject sinisterRequest = this.getPolicyRequestCustomObject(this.recordTypeDeclararSiniestro);
        if (sinisterRequest != null) {
            if (sinisterRequest.formRunnerController.formResult) {
                Gestion__c request = sinisterRequest.gestion;

                if (Test.isRunningTest()) {
                    //Datos de Prueba
                    if (request.Fecha_y_Hora_de_Ocurrencia__c == null) {
                        request.Fecha_y_Hora_de_Ocurrencia__c = system.now();
                        request.Localidad_y_Provincia_de_ocurrencia__c = [SELECT id FROM Localidad_Provincia__c LIMIT 1].Id;
                        request.Tipo_de_Siniestro__c = 'TEST';
                        request.Lugar_de_Ocurrencia__c = 'Test';
                        request.Email_Notificante__c = 'test@test.com';
                        request.Domicilio_Notificante__c = 'test';
                        request.Causa_Siniestro__c = 'test';
                        request.Codigo_de_Riesgo__c = 'test';
                    }
                }

                String errors = this.controlFieldsInClaimRequest(request);

                if (String.isNotBlank(errors)) {
                    this.createApexMessage(ApexPages.Severity.ERROR, errors);
                    validationError = true;
                }

                this.caseForTheCall.Reason = 'Siniestros';
                this.caseForTheCall.Resultado__c = 'Declaración';
                this.telephoneCall.Motivo_de_llamado_BO__c = 'Denuncia'; //Jira 1456
            } else {
                //Because the request is not going to be inserted, we change the case status to "riesgo no cubierto"
                caseForTheCallAux.Reason = 'Siniestros';
                caseForTheCallAux.Resultado__c = 'Riesgo No cubierto';
                telephoneCallAux.Motivo_de_llamado_BO__c = 'Riesgo no cubierto'; // Jira 1456
            }
        }

        return validationError;
    }

    // Refactoreo Jira 1637
    private boolean checkIfIsNecessaryTheNewPlan() {
        Boolean isNecessaryTheNewPlan = false;
        isNecessaryTheNewPlan = this.checkIfTheRetentionAndChangeOfPlanMustToHaveTheNewPlanSelected(
            this.policyRequestCustomList
        );
        if (!isNecessaryTheNewPlan) {
            isNecessaryTheNewPlan = this.checkIfTheRetentionAndChangeOfPlanMustToHaveTheNewPlanSelected(
                this.preSavedChangeOfPlanRequests
            );
        }
        if (!isNecessaryTheNewPlan) {
            isNecessaryTheNewPlan = this.checkIfTheRetentionAndChangeOfPlanMustToHaveTheNewPlanSelected(
                this.preSavedRetentionOfPlanRequests
            );
        }

        if (isNecessaryTheNewPlan) {
            this.createApexMessage(ApexPages.Severity.ERROR, Label.Seleccion_Nuevo_Plan_Retencion_Cambio_Plan);
            return true;
        }
        return false;
    }

    // Refactoreo Jira 1637
    /**
     * Valida que para las gestiones a realizar haya al menos una poliza seleccionada.
     * Para el caso de que la uncia gestion sea de siniestro, no lo valida.
     * Retorna false si esta todo OK, si hay gestiones sin poliza seleccionada retorna true
     **/
    private Boolean validateIfPolicyHasBeenSelected(Boolean atLeastOnePolicySelected) {
        if (
            (!atLeastOnePolicySelected && this.policyRequestCustomList.size() > 0) &&
            (this.policyRequestCustomList.size() == 1 &&
            this.policyRequestCustomList[0].gestion.RecordTypeId != this.recordTypeDeclararSiniestro)
        ) {
            this.createApexMessage(ApexPages.Severity.ERROR, Label.Poliza_No_Seleccionada);
            return true;
        }
        return false;
    }

    // Refactoreo por jira 1637
    private void fillAuxiliaryCaseForTheCall(Case caseForTheCallAux) {
        caseForTheCallAux.Status = this.caseForTheCall.Status;
        caseForTheCallAux.AccountId = this.client.Id;

        if (this.caseForTheCall.Origin != 'Canal Digital') {
            caseForTheCallAux.Origin = 'Teléfono';
        }

        if ('Reintegro a Validar'.equalsIgnoreCase(this.caseForTheCall.Resultado__c)) {
            // jira 1479
            caseForTheCallAux.Derivado_a__c = 'Calidad HS';
            caseForTheCallAux.Resolucion_de_Reintegro__c = 'En análisis';
        }
    }

    // Refactoreo por jira 1637
    private Boolean checkIfTheOnlyRetentionRequestIsTheTemplate() {
        // Jira 1674 Esto es para que no se pueda guardar la gestion de retencion  base (el tempalte) sin seleccionar una poliza.
        for (PolicyRequestCustomObject requestWrapper : this.policyRequestCustomList) {
            if (
                requestWrapper.gestion.recordTypeId == this.recordTypeRetencion &&
                requestWrapper.retentionTemplateRequest &&
                this.preSavedRetentionOfPlanRequests.isEmpty()
            ) {
                return true;
            }
        }
        return false;
    }

    // Refactoreo por jira 1637
    private void assignCompletedFormIfIsSinisterCase(Case aCase, Task aTelephoneTask) {
        if ('Siniestros'.equalsIgnoreCase(aCase.Reason)) {
            Id completedFormId = this.AssignCompletedFormToCase(aCase);

            if (completedFormId != null) {
                aTelephoneTask.Formulario_Realizado__c = completedFormId;
            }
        }
    }

    // Refactoreo por jira 1637
    public PageReference save() {
        this.isSaving = true;
        List<Gestion__c> requestsToSave = new List<Gestion__c>();

        try {
            // this.changeAllCancellationsToSinNotaIfHasAtLeastOneSinNota();
            this.changeAllCancellationsToClientConflictiveIfOneHasMarkedAsConflictive();
            this.checkIfCorrespondReintegroForCancellationsRequest();
            this.deleteReenvioDePolizaRequest();

            if (
                !this.validateMotivoLlamadaForSinisterUsers() ||
                // !this.validateMegaServicioZipCode() || // Deprecado EV1484
                !this.validateAndProcessBajaPrimaUnica() ||
                !this.validateAndProcessBajaSapienza() ||
                !this.validateCancellationDate() ||
                !this.validatePaymentMethodOfCambioMedioDePagoRequest() ||
                !this.validateAndProcessResultAndReasonForTheCall() ||
                this.hasDuplicatedRequests()
            ) {
                this.isSaving = false;
                return null;
            }

            String error = '';
            Boolean hasError = false;
            Boolean hasBeenAtLeastOnePolicySelected = false;
            List<Gestion__C> requestToInsert = new List<Gestion__c>();
            List<Gestion__C> requestPreSavedToInsert = new List<Gestion__c>();
            List<Gestion__C> requestPreSavedRetentionToInsert = new List<Gestion__c>();
            List<Gestion__C> requestPreSavedCancellationToInsert = new List<Gestion__c>();

            List<Gestion__C> allRequestToInsert = new List<Gestion__c>();
            //Create a Case for all generated requests
            Case caseForTheCallAux = this.caseForTheCall.clone();
            Task telephoneCallAux = this.telephoneCall.clone();

            try {
                //Validations
                hasBeenAtLeastOnePolicySelected = this.checkIfAtLeastOnePolicyIsSelected();
                hasError = this.validateIfPolicyHasBeenSelected(hasBeenAtLeastOnePolicySelected);

                this.fillAuxiliaryCaseForTheCall(caseForTheCallAux);
                this.fillTelephoneTask(telephoneCallAux);

                hasError |=
                    this.verifyFieldsAndCompleteSinisterRequest(caseForTheCallAux, telephoneCallAux) ||
                    this.checkIfTheOnlyRetentionRequestIsTheTemplate() ||
                    this.checkIfIsNecessaryTheNewPlan();

                //Genera las gestiones a guardar
                if (!this.tryingToSaveACancelationRequestWithoutPolicy) {
                    requestToInsert = this.generateRequestToInsert(
                        this.policyRequestCustomList,
                        caseForTheCallAux,
                        telephoneCallAux,
                        this.client
                    );
                    requestPreSavedToInsert = this.generateRequestToInsert(
                        this.preSavedChangeOfPlanRequests,
                        caseForTheCallAux,
                        telephoneCallAux,
                        this.client
                    );
                    requestPreSavedRetentionToInsert = this.generateRequestToInsert(
                        this.preSavedRetentionOfPlanRequests,
                        caseForTheCallAux,
                        telephoneCallAux,
                        this.client
                    );
                    requestPreSavedCancellationToInsert = this.generateRequestToInsert(
                        this.preSavedCancellationRequests,
                        caseForTheCallAux,
                        telephoneCallAux,
                        this.client
                    );
                } else if (this.preSavedCancellationRequests.size() > 0) {
                    requestPreSavedCancellationToInsert = this.generateRequestToInsert(
                        this.preSavedCancellationRequests,
                        caseForTheCallAux,
                        telephoneCallAux,
                        this.client
                    );
                }

                //TO:SEE: ¿sirve?. control future method calls (Solo chequea una lista, deberia chequear todas)
                String exceedQuantityOfFutureCalls = this.controlFutureMethodCalls();
                if (String.isNotBlank(exceedQuantityOfFutureCalls)) {
                    this.createApexMessage(ApexPages.Severity.ERROR, exceedQuantityOfFutureCalls);
                    this.isSaving = false;
                    return null;
                }

                /*Usa dos veces el assignHogarProtegidoValues por que el modulo de Cambio De Plan, para 
                  realizar un nuevo cambio de plan hay que "Finalizar" el anterior, entonces quedan los 
                  finalizados en presaved y el resto en policyRequestCustomList*/
                //for HOGAR PROTEGIDO product modifica combo retention we should check if the contratado and aContratar plan are differents to save
                Boolean hogarProtegidoError = this.assignHogarProtegidoValues(
                    requestPreSavedRetentionToInsert,
                    this.preSavedRetentionOfPlanRequests
                );
                hogarProtegidoError |= this.assignHogarProtegidoValues(requestToInsert, this.policyRequestCustomList);

                if (hogarProtegidoError) {
                    this.isSaving = false;
                    return null;
                }
            } catch (Exception e) {
                CreateApexLog.create(new Map<MapLogArgKey, Object>{ MapLogArgKey.EXCEPTIONINFO => e });

                hasError = true;
                error = e.getMessage();

                if ('Invalid id: '.equalsIgnoreCase(error)) {
                    this.createApexMessage(ApexPages.Severity.ERROR, Label.Poliza_No_Seleccionada_Exception);
                } else {
                    this.createApexMessage(ApexPages.Severity.ERROR, error);
                }
            }

            Integer numberOfRequestInserted = 0;

            if (!hasError) {
                try {
                    //Si se viene a gestionar el caso se actualiza, si es un nuevo caso se inserta
                    if (String.isBlank(this.caseForTheCall.id)) {
                        insert caseForTheCallAux;
                    } else {
                        caseForTheCallAux.Id = this.caseForTheCall.id;
                        update caseForTheCallAux;
                    }
                    this.associateResendPoliciesToCase(caseForTheCallAux);
                    this.assignCompletedFormIfIsSinisterCase(caseForTheCallAux, telephoneCallAux);

                    insert telephoneCallAux;
                    telephoneCallAux.WhatId = caseForTheCallAux.Id;
                    update telephoneCallAux;

                    //Insert the request and detect if theare is and error to show.
                    if (!requestToInsert.isEmpty() && requestToInsert[0] != null) {
                        //before insert the request, based on the reason of the cancelation, change the reintegro field value
                        this.checkIfTheReintegroFieldValueShouldBeChanged(requestToInsert);
                        this.checkIfStatusFieldShouldBeChanged(requestToInsert);

                        for (Gestion__c aRequest : requestToInsert) {
                            if (
                                aRequest.RecordTypeId == recordTypeDeclararSiniestro &&
                                aRequest.Caso__c == null &&
                                caseForTheCallAux.id != null
                            ) {
                                aRequest.Caso__c = caseForTheCallAux.id;
                            }
                        }

                        if (!this.checkIfWeAreSavingJustAClaimRequestWithFalseResult()) {
                            //Jira 1607
                            GestionarPolizaControllerHelper.assignPremioValues(requestToInsert);

                            allRequestToInsert.addAll(requestToInsert);
                        }
                    }

                    if (requestPreSavedToInsert.size() > 0 && requestPreSavedToInsert[0] != null) {
                        allRequestToInsert.addAll(requestPreSavedToInsert);
                    }
                    // Deprecado EV1484
                    // //if we will insert a megaservicio request, we check if all the products in retention request can activate megaservicio
                    // boolean willInsertAMegaservicio = false;
                    // for (PolicyRequestCustomObject pol : this.preSavedRetentionOfPlanRequests) {
                    //     if (pol.planChangeController.ServiceRequest != null) {
                    //         //if we detect that some retention request have a megaservicio to insert
                    //         willInsertAMegaservicio = true;
                    //     }
                    // }
                    // if (willInsertAMegaservicio) {
                    //     System.debug('willInsertAMegaservicio');
                    //     this.checkIfAllProductsInRetentionRequestCanGenerateAMegaservicioRequest(
                    //         requestPreSavedRetentionToInsert,
                    //         this.preSavedRetentionOfPlanRequests
                    //     );
                    // }

                    if (requestPreSavedRetentionToInsert.size() > 0 && requestPreSavedRetentionToInsert[0] != null) {
                        allRequestToInsert.addAll(requestPreSavedRetentionToInsert);
                    }

                    if (requestPreSavedCancellationToInsert.size() > 0 && requestPreSavedCancellationToInsert[0] != null) {
                        allRequestToInsert.addAll(requestPreSavedCancellationToInsert);
                    }

                    for (Gestion__c gestion : allRequestToInsert) {
                        if (isBonificable) {
                            gestion.Aplica_Bonificacion__c = true;
                        }
                    }
                    insert allRequestToInsert;
                    numberOfRequestInserted = allRequestToInsert.size();

                    if (!requestToInsert.isEmpty() && requestToInsert[0] != null) {
                        List<Beneficiario_de_Gestion__c> requestToInsertBeneficiaries = new List<Beneficiario_de_Gestion__c>();
                        for (Gestion__c requestInserted : requestToInsert) {
                            if (requestInserted.recordTypeId == this.recordTypeCambioDeBeneficiarios) {
                                PolicyRequestCustomObject aBeneficiaryChangeRequest = this.getPolicyRequestCustomObject(
                                    this.recordTypeCambioDeBeneficiarios
                                );

                                Integer beneficiarySize =
                                    aBeneficiaryChangeRequest.beneficiaryController.beneficiaries.size() - 1;
                                for (Integer i = beneficiarySize; i >= 0; --i) {
                                    Beneficiario_de_Gestion__c ben = aBeneficiaryChangeRequest
                                        .beneficiaryController
                                        .beneficiaries
                                        .get(i);
                                    ben.Gestion__c = requestInserted.Id;
                                    ben.Poliza__c = requestInserted.Poliza__c;
                                    ben.Id_de_insercion__c = '';
                                }

                                requestToInsertBeneficiaries.addAll(
                                    aBeneficiaryChangeRequest.beneficiaryController.beneficiaries
                                );
                            }
                        }
                        insert requestToInsertBeneficiaries;
                    }

                    //Jira 1643
                    PolicyRequestCustomObject bajaRequest = this.getPolicyRequestCustomObject(this.recordTypeBaja);
                    if (bajaRequest != null && bajaRequest.clientWithSoldProductWithCameraSerialNumber) {
                        GestionarPolizaControllerHelper.insertCameraChildCase(caseForTheCallAux);
                    }

                    List<Gestion__c> requestToUpdate = new List<Gestion__c>();
                    //The relationship beetwhen case and request.
                    if (requestToInsert.size() > 0 && requestToInsert[0] != null && requestToInsert[0].Id != null) {
                        requestToUpdate.addAll(updateCaseInRequests(requestToInsert, caseForTheCallAux));
                    }

                    if (requestPreSavedToInsert.size() > 0 && requestPreSavedToInsert[0] != null) {
                        requestToUpdate.addAll(updateCaseInRequests(requestPreSavedToInsert, caseForTheCallAux));
                    }
                    if (requestPreSavedRetentionToInsert.size() > 0 && requestPreSavedRetentionToInsert[0] != null) {
                        requestToUpdate.addAll(updateCaseInRequests(requestPreSavedRetentionToInsert, caseForTheCallAux));
                    }

                    if (requestPreSavedCancellationToInsert.size() > 0 && requestPreSavedCancellationToInsert[0] != null) {
                        requestToUpdate.addAll(
                            updateCaseInRequests(requestPreSavedCancellationToInsert, caseForTheCallAux)
                        );
                    }

                    update requestToUpdate;

                    if (requestToInsert.size() > 0 && requestToInsert[0] != null && requestToInsert[0].Id != null) {
                        this.createCaseForRefundToAnalyze(requestToInsert, this.policyRequestCustomList, caseForTheCallAux); //jira 1479
                    }
                    if (requestPreSavedCancellationToInsert.size() > 0 && requestPreSavedCancellationToInsert[0] != null) {
                        this.createCaseForRefundToAnalyze(
                            requestPreSavedCancellationToInsert,
                            this.preSavedCancellationRequests,
                            caseForTheCallAux
                        ); //jira 1479
                    }

                    insert this.casesToAnalyze; // Jira 1479
                } catch (DMLException e) {
                    CreateApexLog.create(new Map<MapLogArgKey, Object>{ MapLogArgKey.EXCEPTIONINFO => e });

                    error = e.getMessage();

                    String[] newError;
                    if (error.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
                        newError = error.split(',');
                    }

                    boolean resultError = false;
                    String resultadoError = '';
                    if (
                        error.contains(
                            'El resultado seleccionado no esta disponible para casos con este origen.: [Resultado__c]'
                        )
                    ) {
                        resultError = true;
                        newError = error.split(',');
                        newError = newError[1].split(':');
                        resultadoError = newError[0];
                    }

                    ApexPages.Message msg;
                    if (newError != null) {
                        if (newError.size() > 0 && !hasError && !resultError) {
                            msg = new ApexPages.Message(ApexPages.Severity.ERROR, newError[1].replace('[]', ''));
                        } else if (!hasError && !resultError) {
                            msg = new ApexPages.Message(ApexPages.Severity.ERROR, error);
                        } else if (resultError) {
                            msg = new ApexPages.Message(ApexPages.Severity.ERROR, resultadoError);
                        }
                    }

                    if (msg != null && !resultError) {
                        ApexPages.addMessage(msg);
                    }
                    hasError = true;
                }
            }

            if (hasError && hasBeenAtLeastOnePolicySelected && telephoneCallAux.Id != null && !hasCaseId) {
                telephoneCallAux.WhatId = null;
                //we move the delete logic to a without sharing class to avoid permission errors

                GestionarPolizaControllerHelper.deleteRecord(telephoneCallAux.id, 'task');
                GestionarPolizaControllerHelper.deleteRecord(caseForTheCallAux.id, 'case');

                GestionarPolizaControllerHelper.deleteCases(this.casesToAnalyze); // Jira 1479
                this.casesToAnalyze.clear(); // jira 1479
            }

            if (!hasError && (hasBeenAtLeastOnePolicySelected || policyRequestCustomList.size() == 0)) {
                caseForTheCallAux = [SELECT Id, CaseNumber FROM Case WHERE Id = :caseForTheCallAux.Id];

                List<Gestion__c> requestInserted = [
                    SELECT Id, RecordType.Name
                    FROM Gestion__c
                    WHERE Caso__c = :caseForTheCallAux.Id
                ];

                if (requestInserted.isEmpty() && caseForTheCallAux != null) {
                    PolicyRequestCustomObject requestSiniestro = this.getPolicyRequestCustomObject(
                        this.recordTypeDeclararSiniestro
                    );

                    if (requestSiniestro != null && String.isNotBlank(requestSiniestro.formRunnerController.textoCierre)) {
                        String clientId = this.client.Id;
                        String clientEmail = this.client.PersonEmail;

                        caseForTheCallAux.Texto_de_Cierre__c = requestSiniestro.formRunnerController.textoCierre;
                        caseForTheCallAux.Enviar_correo_rechazo_cobertura__c = true;

                        caseForTheCallAux.Tipificacion_Siniestro_Rechazado__c = requestSiniestro.formRunnerController.tipificacion;
                        caseForTheCallAux.Fecha_Ocurrencia_Siniestro__c = requestSiniestro.formRunnerController.fechaHoraOcurrencia;

                        if (
                            String.isBlank(clientEmail) ||
                            (String.isNotBlank(requestSiniestro.formRunnerController.clientEmail) &&
                            requestSiniestro.formRunnerController.clientEmail != clientEmail)
                        ) {
                            clientEmail = requestSiniestro.formRunnerController.clientEmail;
                        }

                        caseForTheCallAux.clientEmail__c = clientEmail;
                        update caseForTheCallAux;

                        this.InsertEmailMessageAndSendToClient(
                            caseForTheCallAux,
                            requestSiniestro.formRunnerController.textoCierre,
                            clientEmail
                        );
                    }
                }

                if (numberOfRequestInserted == null) {
                    numberOfRequestInserted = 0;
                }

                //If theare is a request of service inserted then we send a parameter to the
                //next visualforce to know if need to show a button to send a email.
                // Deprecado EV1484
                // String sendEmailParameter = '';
                // for (Gestion__c requestInsert : requestInserted) {
                //     if (requestInsert.RecordType.Name == 'Megaservicio') {
                //         sendEmailParameter = '&sendEmail=true&showLink=true';
                //         break;
                //     }
                // }

                String isGestionarCaso = '&isGestionCaso=False';
                if (String.isNotblank(Apexpages.currentPage().getParameters().get('caseId'))) {
                    isGestionarCaso = '&isGestionCaso=True';
                }

                String finalURL =
                    '/apex/Gestionar_Poliza_Exitosa?' +
                    'AcctId=' +
                    accId +
                    '&Id=' +
                    caseForTheCallAux.Id +
                    '&numbersOfRequests=' +
                    String.valueOf(requestInserted.size()) +
                    '&caseNumber=' +
                    caseForTheCallAux.CaseNumber +
                    // sendEmailParameter + // Deprecado EV1484
                    isGestionarCaso;

                return new PageReference(finalURL);
            } else {
                return null;
            }
        } catch (Exception e) {
            CreateApexLog.create(new Map<MapLogArgKey, Object>{ MapLogArgKey.EXCEPTIONINFO => e });
        }
        this.isSaving = false;
        return null;
    }

    //Metodos auxiliares.
    // Jira 1603
    /*Asocia los reenvios de polizas generados al con el caso*/
    private void associateResendPoliciesToCase(Case caseToAssoc) {
        for (Reenvio_de_Poliza__c resendedPolicy : this.policyResender.resendPolicies) {
            resendedPolicy.Caso__c = caseToAssoc.Id;
        }

        update this.policyResender.resendPolicies;
    }

    public Id AssignCompletedFormToCase(Case caseInserted) {
        List<Formulario_Realizado__c> clientLastCompletedForm = [
            SELECT Id
            FROM Formulario_Realizado__c
            WHERE Cliente__c = :caseInserted.AccountId AND CreatedDate = TODAY
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
        if (clientLastCompletedForm.size() == 1) {
            clientLastCompletedForm[0].Caso__c = caseInserted.Id;
            update clientLastCompletedForm;
            return clientLastCompletedForm[0].Id;
        }

        return null;
    }

    public void InsertEmailMessageAndSendToClient(Case theCase, String textoCierre, String clientEmail) {
        EmailMessage messageToInsert = new EmailMessage();

        messageToInsert.ParentId = theCase.id;

        messageToInsert.ToAddress = clientEmail;
        messageToInsert.Subject = 'Resolución Caso N° ' + theCase.CaseNumber;

        messageToInsert.FromAddress = 'siniestros@hipotecario.com.ar';

        messageToInsert.HtmlBody = textoCierre;

        try {
            insert messageToInsert;
        } catch (DMLException e) {
            CreateApexLog.create(new Map<MapLogArgKey, Object>{ MapLogArgKey.EXCEPTIONINFO => e });
        }
    }

    public static boolean updateClientProducts(String accId) {
        if (String.isBlank(accId)) {
            accId = ApexPages.currentPage().getParameters().get('AccId');
        }

        List<Poliza__c> clientPoliciesToUpdate = new List<Poliza__c>();

        boolean hasError = false;
        WebServiceGetCertificadoDetalle service = new WebServiceGetCertificadoDetalle();

        for (Poliza__c clientAvailablePolicy : [
            SELECT
                Baja__c,
                Canal_1__c,
                Canal_1_IdBHSeg__c,
                Canal_2__c,
                Canal_2_IdBHSeg__c,
                Canal_4__c,
                Canal_4_IdBHSeg__c,
                Certificado_Id_BHSeg__c,
                Cuenta__c,
                Cuenta_Pago__c,
                Domicilio__c,
                Endoso_Desde__c,
                Endoso_Hasta__c,
                Emision__c,
                Poliza_Anterior__c,
                Estado_IdBHSeg__c,
                Medio_de_Pago__c,
                Medio_de_Pago_IdBHSeg__c,
                Motivo_Endoso_IdBHSeg__c,
                Numero_Producto_Financiero__c,
                Origen_de_Pago__c,
                Origen_de_Pago_IdBHSeg__c,
                Producto_Financiero__c,
                Producto_Financiero_IdBHSeg__c,
                Productor__c,
                Productor_IdBHSeg__c,
                Tipo__c,
                Tipo_Endoso__c,
                Tipo_Endoso_IdBHSeg__c,
                Endoso__c,
                Certificado__c,
                Ramo_IdBHSeg__c,
                Poliza__c,
                Estado__c,
                Ultimo_endoso__c,
                Vigente__c,
                Incluye_Camara__c,
                Producto__c
            FROM Poliza__c
            WHERE Cuenta__c = :accId
        ]) {
            if (service.getProductDetail(clientAvailablePolicy)) {
                clientPoliciesToUpdate.add(service.getDetail());
            } else {
                hasError = true;
                break;
            }
        }

        if (!clientPoliciesToUpdate.isEmpty() && !hasError) {
            try {
                for (Poliza__c pol : clientPoliciesToUpdate) {
                    if (!pol.Certificado_Id_BHSeg__c.contains(accId)) {
                        pol.Certificado_Id_BHSeg__c += '|' + accId;
                    }
                }
                update clientPoliciesToUpdate;
            } catch (DmlException e) {
                CreateApexLog.create(new Map<MapLogArgKey, Object>{ MapLogArgKey.EXCEPTIONINFO => e });
            }
        } else {
            return false;
        }

        return true;
    }

    public boolean assignHogarProtegidoValues(List<Gestion__c> requests, List<PolicyRequestCustomObject> wrappers) {
        PolicyRequestCustomObject hogarProtegidoWrapper;
        for (PolicyRequestCustomObject wrapper : wrappers) {
            if (wrapper.planChangeController != null) {
                if (wrapper.planChangeController.isAHogarProtegido) {
                    hogarProtegidoWrapper = wrapper;
                    break;
                }
            }
        }

        if (hogarProtegidoWrapper != null) {
            String polId = '';
            for (PolizaWrapper wrapper : hogarProtegidoWrapper.polizasWrapperList) {
                if (wrapper.ProductoIdBHSEG == '210') {
                    polId = wrapper.Id;
                }
            }

            Poliza__c hogarProtegidoPolicy;
            if (String.isNotBlank(polId)) {
                List<Poliza__c> policies = [
                    SELECT Ramo_IdBHSeg__c, Producto_idbhseg__c, Ramo__c
                    FROM Poliza__c
                    WHERE id = :polId
                ];

                if (!policies.isEmpty()) {
                    for (Poliza__c policy : policies) {
                        if (policy.Producto_IdBHSeg__c == '210') {
                            hogarProtegidoPolicy = policy;
                            break;
                        }
                    }
                }
            }

            if (hogarProtegidoPolicy != null) {
                Gestion__c hogarProtegidoRequest;
                for (Gestion__c req : requests) {
                    if (req.Poliza__c == hogarProtegidoPolicy.id) {
                        hogarProtegidoRequest = req;
                        break;
                    }
                }

                if (hogarProtegidoRequest != null) {
                    hogarProtegidoRequest.combinatoriaOrigen__c = hogarProtegidoWrapper.combinatoria;
                    hogarProtegidoRequest.combinatoriaDestino__c = hogarProtegidoWrapper.combinatoria_aContratar;

                    if (hogarProtegidoRequest.combinatoriaOrigen__c == hogarProtegidoRequest.combinatoriaDestino__c) {
                        ApexPages.Message msg;
                        boolean shouldAddError = false;
                        if (!hogarProtegidoWrapper.planChangeController.isRet) {
                            shouldAddError = true;
                            msg = new ApexPages.Message(
                                ApexPages.Severity.ERROR,
                                'Los planes contratados deben ser distintos para guardar una gestion de Cambio de Plan'
                            );
                        } else if (hogarProtegidoWrapper.planChangeController.retType == 'retModif') {
                            shouldAddError = true;
                            msg = new ApexPages.Message(
                                ApexPages.Severity.ERROR,
                                'Los planes contratados deben ser distintos para guardar una gestion de retencion "Modifica Combo"'
                            );
                        }
                        if (shouldAddError) {
                            ApexPages.addMessage(msg);
                            return true;
                        }
                    }

                    // The field Poliza__c.Plan_IdBHSeg__c is not required, so the version could be empty.
                    // By default it works in 001
                    if (
                        String.isBlank(hogarProtegidoWrapper.planChangeController.hogarProtegidoVersion) ||
                        hogarProtegidoWrapper.planChangeController.hogarProtegidoVersion == '001'
                    ) {
                        // HOGAR PROTEGIDO VERSION 1

                        //contratado

                        //incendio
                        hogarProtegidoRequest.sumaAseg01__c = String.valueOf(
                            hogarProtegidoWrapper.incendio.incendio_de_edificio
                        );
                        hogarProtegidoRequest.sumaAseg02__c = String.valueOf(
                            hogarProtegidoWrapper.incendio.danios_por_granizo_al_edificio
                        );
                        hogarProtegidoRequest.sumaAseg03__c = String.valueOf(
                            hogarProtegidoWrapper.incendio.incendio_del_contenido
                        );
                        hogarProtegidoRequest.sumaAseg04__c = String.valueOf(
                            hogarProtegidoWrapper.incendio.rc_por_incendio_o_explosion
                        );
                        hogarProtegidoRequest.sumaAseg05__c = String.valueOf(
                            hogarProtegidoWrapper.incendio.alojamiento_por_incendio_o_explosion
                        );
                        hogarProtegidoRequest.sumaAseg06__c = String.valueOf(
                            hogarProtegidoWrapper.incendio.gastos_de_limpieza_por_incendio
                        );

                        //contenido
                        hogarProtegidoRequest.sumaAseg07__c = String.valueOf(
                            hogarProtegidoWrapper.contenido.robo_o_hurto_del_contenido_general
                        );
                        hogarProtegidoRequest.sumaAseg08__c = String.valueOf(
                            hogarProtegidoWrapper.contenido.danios_por_robo_o_intento_de_robo
                        );
                        hogarProtegidoRequest.sumaAseg09__c = String.valueOf(
                            hogarProtegidoWrapper.contenido.electrodomesticos_o_equipos_electronicos
                        );
                        hogarProtegidoRequest.sumaAseg10__c = String.valueOf(
                            hogarProtegidoWrapper.contenido.responsabilidad_civil_hechos_privados
                        );
                        hogarProtegidoRequest.sumaAseg11__c = String.valueOf(
                            hogarProtegidoWrapper.contenido.danios_por_agua_al_contenido
                        );

                        //servicios
                        hogarProtegidoRequest.sumaAseg12__c = String.valueOf(
                            hogarProtegidoWrapper.servicios.rotura_de_cristales
                        );
                        hogarProtegidoRequest.sumaAseg13__c = String.valueOf(
                            hogarProtegidoWrapper.servicios.robo_o_hurto_en_vacaciones
                        );
                        hogarProtegidoRequest.sumaAseg14__c = String.valueOf(
                            hogarProtegidoWrapper.servicios.objetos_especificos
                        );
                        hogarProtegidoRequest.sumaAseg15__c = String.valueOf(
                            hogarProtegidoWrapper.servicios.responsabilidad_civil_tenencia_de_animales
                        );

                        //a contratar

                        //incendio
                        hogarProtegidoRequest.sumaAseg01Dest__c = String.valueOf(
                            hogarProtegidoWrapper.incendio_aContratar.incendio_de_edificio
                        );
                        hogarProtegidoRequest.sumaAseg02Dest__c = String.valueOf(
                            hogarProtegidoWrapper.incendio_aContratar.danios_por_granizo_al_edificio
                        );
                        hogarProtegidoRequest.sumaAseg03Dest__c = String.valueOf(
                            hogarProtegidoWrapper.incendio_aContratar.incendio_del_contenido
                        );
                        hogarProtegidoRequest.sumaAseg04Dest__c = String.valueOf(
                            hogarProtegidoWrapper.incendio_aContratar.rc_por_incendio_o_explosion
                        );
                        hogarProtegidoRequest.sumaAseg05Dest__c = String.valueOf(
                            hogarProtegidoWrapper.incendio_aContratar.alojamiento_por_incendio_o_explosion
                        );
                        hogarProtegidoRequest.sumaAseg06Dest__c = String.valueOf(
                            hogarProtegidoWrapper.incendio_aContratar.gastos_de_limpieza_por_incendio
                        );

                        //contenido
                        hogarProtegidoRequest.sumaAseg07Dest__c = String.valueOf(
                            hogarProtegidoWrapper.contenido_aContratar.robo_o_hurto_del_contenido_general
                        );
                        hogarProtegidoRequest.sumaAseg08Dest__c = String.valueOf(
                            hogarProtegidoWrapper.contenido_aContratar.danios_por_robo_o_intento_de_robo
                        );
                        hogarProtegidoRequest.sumaAseg09Dest__c = String.valueOf(
                            hogarProtegidoWrapper.contenido_aContratar.electrodomesticos_o_equipos_electronicos
                        );
                        hogarProtegidoRequest.sumaAseg10Dest__c = String.valueOf(
                            hogarProtegidoWrapper.contenido_aContratar.responsabilidad_civil_hechos_privados
                        );
                        hogarProtegidoRequest.sumaAseg11Dest__c = String.valueOf(
                            hogarProtegidoWrapper.contenido_aContratar.danios_por_agua_al_contenido
                        );

                        //servicios
                        hogarProtegidoRequest.sumaAseg12Dest__c = String.valueOf(
                            hogarProtegidoWrapper.servicios_aContratar.rotura_de_cristales
                        );
                        hogarProtegidoRequest.sumaAseg13Dest__c = String.valueOf(
                            hogarProtegidoWrapper.servicios_aContratar.robo_o_hurto_en_vacaciones
                        );
                        hogarProtegidoRequest.sumaAseg14Dest__c = String.valueOf(
                            hogarProtegidoWrapper.servicios_aContratar.objetos_especificos
                        );
                        hogarProtegidoRequest.sumaAseg15Dest__c = String.valueOf(
                            hogarProtegidoWrapper.servicios_aContratar.responsabilidad_civil_tenencia_de_animales
                        );

                        hogarProtegidoRequest.proposedPlanDescription__c = '001';
                        hogarProtegidoRequest.currentPlanDescription__c = '001';
                        hogarProtegidoRequest.Premio_Plan_Original__c = Decimal.valueOf(
                            hogarProtegidoWrapper.premios.premio
                        );
                        hogarProtegidoRequest.Premio_Plan_Nuevo__c = Decimal.valueOf(
                            hogarProtegidoWrapper.premios_aContratar.premio
                        );
                    } else if (hogarProtegidoWrapper.planChangeController.hogarProtegidoVersion == '002') {
                        if (hogarProtegidoWrapper.planChangeController.retType == 'retMant') {
                            hogarProtegidoRequest.combinatoriaOrigen__c = hogarProtegidoRequest.combinatoriaDestino__c = hogarProtegidoWrapper.combinatoria;
                            hogarProtegidoRequest.sumaAseg01Dest__c = hogarProtegidoRequest.sumaAseg01__c = String.valueOf(
                                hogarProtegidoWrapper.incendio.incendio_de_edificio
                            );
                            hogarProtegidoRequest.sumaAseg02Dest__c = hogarProtegidoRequest.sumaAseg02__c = String.valueOf(
                                hogarProtegidoWrapper.incendio.danios_por_granizo_al_edificio
                            );
                            hogarProtegidoRequest.sumaAseg03Dest__c = hogarProtegidoRequest.sumaAseg03__c = String.valueOf(
                                hogarProtegidoWrapper.incendio.rc_por_incendio_o_explosion
                            );
                            hogarProtegidoRequest.sumaAseg04Dest__c = hogarProtegidoRequest.sumaAseg04__c = String.valueOf(
                                hogarProtegidoWrapper.incendio.alojamiento_por_incendio_o_explosion
                            );
                            hogarProtegidoRequest.sumaAseg05Dest__c = hogarProtegidoRequest.sumaAseg05__c = String.valueOf(
                                hogarProtegidoWrapper.incendio.gastos_de_limpieza_por_incendio
                            );
                            hogarProtegidoRequest.sumaAseg06Dest__c = hogarProtegidoRequest.sumaAseg06__c = String.valueOf(
                                hogarProtegidoWrapper.incendio.responsabilidad_civil_hechos_privados
                            );
                            hogarProtegidoRequest.sumaAseg07Dest__c = hogarProtegidoRequest.sumaAseg07__c = String.valueOf(
                                hogarProtegidoWrapper.contenido.robo_o_hurto_del_contenido_general
                            );
                            hogarProtegidoRequest.sumaAseg08Dest__c = hogarProtegidoRequest.sumaAseg08__c = String.valueOf(
                                hogarProtegidoWrapper.contenido.rotura_de_cristales
                            );
                            hogarProtegidoRequest.sumaAseg09Dest__c = hogarProtegidoRequest.sumaAseg09__c = String.valueOf(
                                hogarProtegidoWrapper.contenido.incendio_del_contenido
                            );
                            hogarProtegidoRequest.sumaAseg10Dest__c = hogarProtegidoRequest.sumaAseg10__c = String.valueOf(
                                hogarProtegidoWrapper.contenido.responsabilidad_civil_tenencia_de_animales
                            );
                            hogarProtegidoRequest.sumaAseg11Dest__c = hogarProtegidoRequest.sumaAseg11__c = String.valueOf(
                                hogarProtegidoWrapper.contenido.danios_por_robo_o_intento_de_robo
                            );
                            hogarProtegidoRequest.sumaAseg12Dest__c = hogarProtegidoRequest.sumaAseg12__c = String.valueOf(
                                hogarProtegidoWrapper.servicios.electrodomesticos_o_equipos_electronicos
                            );
                            hogarProtegidoRequest.sumaAseg13Dest__c = hogarProtegidoRequest.sumaAseg13__c = String.valueOf(
                                hogarProtegidoWrapper.servicios.danios_por_agua_al_contenido
                            );
                            hogarProtegidoRequest.sumaAseg14Dest__c = hogarProtegidoRequest.sumaAseg14__c = String.valueOf(
                                hogarProtegidoWrapper.servicios.robo_o_hurto_en_vacaciones
                            );
                            hogarProtegidoRequest.sumaAseg15Dest__c = hogarProtegidoRequest.sumaAseg15__c = String.valueOf(
                                hogarProtegidoWrapper.servicios.objetos_especificos
                            );
                            hogarProtegidoRequest.proposedPlanDescription__c = hogarProtegidoRequest.currentPlanDescription__c = '002';
                            hogarProtegidoRequest.Premio_Plan_Nuevo__c = hogarProtegidoRequest.Premio_Plan_Original__c = Decimal.valueOf(
                                hogarProtegidoWrapper.premios.premio
                            );
                        } else {
                            // HOGAR PROTEGIDO VERSION 2 (JIRA 1573)
                            //contratado
                            //incendio
                            hogarProtegidoRequest.sumaAseg01__c = String.valueOf(
                                hogarProtegidoWrapper.incendio.incendio_de_edificio
                            );
                            hogarProtegidoRequest.sumaAseg02__c = String.valueOf(
                                hogarProtegidoWrapper.incendio.danios_por_granizo_al_edificio
                            );
                            hogarProtegidoRequest.sumaAseg03__c = String.valueOf(
                                hogarProtegidoWrapper.incendio.rc_por_incendio_o_explosion
                            );
                            hogarProtegidoRequest.sumaAseg04__c = String.valueOf(
                                hogarProtegidoWrapper.incendio.alojamiento_por_incendio_o_explosion
                            );
                            hogarProtegidoRequest.sumaAseg05__c = String.valueOf(
                                hogarProtegidoWrapper.incendio.gastos_de_limpieza_por_incendio
                            );
                            hogarProtegidoRequest.sumaAseg06__c = String.valueOf(
                                hogarProtegidoWrapper.incendio.responsabilidad_civil_hechos_privados
                            );
                            //contenido
                            hogarProtegidoRequest.sumaAseg07__c = String.valueOf(
                                hogarProtegidoWrapper.contenido.robo_o_hurto_del_contenido_general
                            );
                            hogarProtegidoRequest.sumaAseg08__c = String.valueOf(
                                hogarProtegidoWrapper.contenido.rotura_de_cristales
                            );
                            hogarProtegidoRequest.sumaAseg09__c = String.valueOf(
                                hogarProtegidoWrapper.contenido.incendio_del_contenido
                            );

                            if (hogarProtegidoWrapper.planChangeController.getIsHogarProtegidoPardo()) {
                                hogarProtegidoRequest.sumaAseg10__c = '0';
                                hogarProtegidoRequest.sumaAseg11__c = String.valueOf(
                                    hogarProtegidoWrapper.Servicios.danios_por_robo_o_intento_de_robo
                                );
                            } else {
                                hogarProtegidoRequest.sumaAseg10__c = String.valueOf(
                                    hogarProtegidoWrapper.contenido.responsabilidad_civil_tenencia_de_animales
                                );
                                hogarProtegidoRequest.sumaAseg11__c = String.valueOf(
                                    hogarProtegidoWrapper.contenido.danios_por_robo_o_intento_de_robo
                                );
                            }

                            //servicios
                            hogarProtegidoRequest.sumaAseg13__c = String.valueOf(
                                hogarProtegidoWrapper.servicios.danios_por_agua_al_contenido
                            );
                            hogarProtegidoRequest.sumaAseg14__c = String.valueOf(
                                hogarProtegidoWrapper.servicios.robo_o_hurto_en_vacaciones
                            );
                            if (hogarProtegidoWrapper.planChangeController.getIsHogarProtegidoPardo()) {
                                hogarProtegidoRequest.sumaAseg12__c = '0';
                                hogarProtegidoRequest.sumaAseg15__c = '0';
                            } else {
                                hogarProtegidoRequest.sumaAseg12__c = String.valueOf(
                                    hogarProtegidoWrapper.servicios.electrodomesticos_o_equipos_electronicos
                                );
                                hogarProtegidoRequest.sumaAseg15__c = String.valueOf(
                                    hogarProtegidoWrapper.servicios.objetos_especificos
                                );
                            }

                            //a contratar

                            //incendio
                            hogarProtegidoRequest.sumaAseg01Dest__c = String.valueOf(
                                hogarProtegidoWrapper.incendio_aContratar.incendio_de_edificio
                            );
                            hogarProtegidoRequest.sumaAseg02Dest__c = String.valueOf(
                                hogarProtegidoWrapper.incendio_aContratar.danios_por_granizo_al_edificio
                            );
                            hogarProtegidoRequest.sumaAseg03Dest__c = String.valueOf(
                                hogarProtegidoWrapper.incendio_aContratar.rc_por_incendio_o_explosion
                            );
                            hogarProtegidoRequest.sumaAseg04Dest__c = String.valueOf(
                                hogarProtegidoWrapper.incendio_aContratar.alojamiento_por_incendio_o_explosion
                            );
                            hogarProtegidoRequest.sumaAseg05Dest__c = String.valueOf(
                                hogarProtegidoWrapper.incendio_aContratar.gastos_de_limpieza_por_incendio
                            );
                            hogarProtegidoRequest.sumaAseg06Dest__c = String.valueOf(
                                hogarProtegidoWrapper.incendio_aContratar.responsabilidad_civil_hechos_privados
                            );

                            //contenido
                            hogarProtegidoRequest.sumaAseg07Dest__c = String.valueOf(
                                hogarProtegidoWrapper.contenido_aContratar.robo_o_hurto_del_contenido_general
                            );
                            hogarProtegidoRequest.sumaAseg08Dest__c = String.valueOf(
                                hogarProtegidoWrapper.contenido_aContratar.rotura_de_cristales
                            );
                            hogarProtegidoRequest.sumaAseg09Dest__c = String.valueOf(
                                hogarProtegidoWrapper.contenido_aContratar.incendio_del_contenido
                            );

                            if (hogarProtegidoWrapper.planChangeController.getIsHogarProtegidoPardo()) {
                                hogarProtegidoRequest.sumaAseg10Dest__c = '0';
                                hogarProtegidoRequest.sumaAseg11Dest__c = String.valueOf(
                                    hogarProtegidoWrapper.Servicios_aContratar.danios_por_robo_o_intento_de_robo
                                );
                            } else {
                                hogarProtegidoRequest.sumaAseg10Dest__c = String.valueOf(
                                    hogarProtegidoWrapper.contenido_aContratar.responsabilidad_civil_tenencia_de_animales
                                );
                                hogarProtegidoRequest.sumaAseg11Dest__c = String.valueOf(
                                    hogarProtegidoWrapper.contenido_aContratar.danios_por_robo_o_intento_de_robo
                                );
                            }
                            //servicios
                            hogarProtegidoRequest.sumaAseg13Dest__c = String.valueOf(
                                hogarProtegidoWrapper.servicios_aContratar.danios_por_agua_al_contenido
                            );
                            hogarProtegidoRequest.sumaAseg14Dest__c = String.valueOf(
                                hogarProtegidoWrapper.servicios_aContratar.robo_o_hurto_en_vacaciones
                            );

                            if (hogarProtegidoWrapper.planChangeController.getIsHogarProtegidoPardo()) {
                                hogarProtegidoRequest.sumaAseg12Dest__c = '0';
                                hogarProtegidoRequest.sumaAseg15Dest__c = '0';
                            } else {
                                hogarProtegidoRequest.sumaAseg12Dest__c = String.valueOf(
                                    hogarProtegidoWrapper.servicios_aContratar.electrodomesticos_o_equipos_electronicos
                                );
                                hogarProtegidoRequest.sumaAseg15Dest__c = String.valueOf(
                                    hogarProtegidoWrapper.servicios_aContratar.objetos_especificos
                                );
                            }

                            hogarProtegidoRequest.proposedPlanDescription__c = '002';
                            hogarProtegidoRequest.currentPlanDescription__c = '002';
                            hogarProtegidoRequest.Premio_Plan_Original__c = Decimal.valueOf(
                                hogarProtegidoWrapper.premios.premio
                            );
                            hogarProtegidoRequest.Premio_Plan_Nuevo__c = Decimal.valueOf(
                                hogarProtegidoWrapper.premios_aContratar.premio
                            );
                        }
                    }
                }
            }
        }
        return false;
    }

    public void checkIfStatusFieldShouldBeChanged(List<Gestion__c> requests) {
        Map<Gestion__c, String> requestAndValues = new Map<Gestion__c, String>();
        List<string> polIds = new List<String>();
        for (Gestion__c request : requests) {
            if (request.RecordTypeId == recordTypeBaja) {
                //we should query ramo and product value for the policy of this request
                polIds.add(request.Poliza__c);
            }
        }
        if (!polIds.isEmpty()) {
            List<Poliza__c> requestPolicies = [
                SELECT id, Ramo_idbhseg__c, producto_idbhseg__c
                FROM Poliza__c
                WHERE id IN :polIds
            ];

            for (Poliza__c requestPolicy : requestPolicies) {
                for (Gestion__c request : requests) {
                    if (requestPolicy.id == request.poliza__c) {
                        requestAndValues.put(
                            request,
                            requestPolicy.Ramo_idbhseg__c +
                            ',' +
                            requestPolicy.producto_idbhseg__c
                        );
                    }
                }
            }
        }

        if (!requestAndValues.isEmpty()) {
            for (Gestion__c req : requestAndValues.keySet()) {
                String values = requestAndValues.get(req);
                List<String> listValues = values.split(',');
                String ramo = listValues[0];
                String producto = listValues[1];
                if ((ramo == '18' || ramo == '3') && producto == '179') {
                    req.Estado__c = 'FINALIZADO';
                }
            }
        }
    }

    public void checkIfTheReintegroFieldValueShouldBeChanged(List<Gestion__c> requests) {
        //if some of the requests that will be inserted is a baja request, change their reintegro field value based on the reason value
        for (Gestion__c request : requests) {
            if (request.RecordTypeId == recordTypeBaja) {
                if (
                    request.Motivo_Baja__c == 'A PEDIDO DEL ASEGURADO' ||
                    request.Motivo_Baja__c == 'DISCONFORME CON EL SERVICIO'
                ) {
                    request.Reintegro__c = false;
                } else if (
                    request.Motivo_Baja__c == 'CLIENTE NO DIO EL CONSENTIMIENTO' ||
                    request.Motivo_Baja__c == 'A PEDIDO DEL ASEGURADO CON REINTEGRO'
                ) {
                    if (
                        request.resultado__c == 'Venta No Retenida / Cliente Conflictivo' ||
                        request.resultado__c == 'Venta No Retenida / No Interesado' /* ||
                         request.resultado__c == 'Venta No Retenida / No Interesado / Con Nota'*/
                    ) {
                        request.Reintegro__c = true;
                    }
                }
            }
        }
    }

    public PageReference cleanActualCancelationRequest() {
        PolicyRequestCustomObject cancelationRequest = getPolicyRequestCustomObject(recordTypeBaja);

        if (String.isNotBlank(cancelationRequest.selectedPolizaId)) {
            cancelationRequest.selectedPolizaId = null;
            cancelationRequest.gestion.Fecha_Registro_Fax__c = null;
            cancelationRequest.gestion.Reintegro__c = null;
            cancelationRequest.gestion.Motivo_Baja__c = null;
            cancelationRequest.gestion.Resultado__c = null;
            cancelationRequest.gestion.Descripcion__c = null;
            cancelationRequest.gestion.numero_fax__c = null;
            cancelationRequest.gestion.Observaciones__c = null;
        }
        return null;
    }

    public PageReference cancelAndReturnToClient() {
        return null;
    }

    public boolean checkIfTheareIsDuplicatedRequestInTheDatabase() {
        List<Gestion__c> newRequests = new List<Gestion__c>();

        if (getPolicyRequestCustomObject(recordTypeBaja) != null) {
            newRequests.add(getPolicyRequestCustomObject(recordTypeBaja).Gestion);
            getPolicyRequestCustomObject(recordTypeBaja).Gestion.RecordTypeId = recordTypeBaja;
        }

        if (getPolicyRequestCustomObject(recordTypeCambioMedioPago) != null) {
            newRequests.add(getPolicyRequestCustomObject(recordTypeCambioMedioPago).Gestion);
        }

        if (getPolicyRequestCustomObject(recordTypeCambioDeBeneficiarios) != null) {
            newRequests.add(getPolicyRequestCustomObject(recordTypeCambioDeBeneficiarios).Gestion);
        }

        // STRING = IDACCOUNT-IDPOLIZA-RECORDTYPE
        Map<String, Gestion__c> openGestionesByTypeByAccount = new Map<String, Gestion__c>();

        boolean theareIsDuplicatedRequests = false;

        for (Gestion__c newRequest : newRequests) {
            String recordTypeName = this.allRecordTypes.get(newRequest.recordTypeId).name;
            String UniqueMapID = newRequest.cuenta__c + '-' + newRequest.poliza__c + '-' + recordTypeName;

            //reset the error list.
            getPolicyRequestCustomObject(newRequest.recordTypeId).errorsInTheRequests = new List<String>();

            if (newRequest.cuenta__c == null && newRequest.Poliza__c == null) {
                for (PolizaWrapper pol : getPolicyRequestCustomObject(newRequest.RecordTypeId).polizasWrapperList) {
                    boolean isACancellationRequest =
                        getPolicyRequestCustomObject(newRequest.RecordTypeId).tipo == 'Baja' &&
                        (getPolicyRequestCustomObject(newRequest.RecordTypeId).selectedPolizaId != null ||
                        getPolicyRequestCustomObject(newRequest.RecordTypeId).selectedPolizaId != '');

                    String cancellationPolicyId = '';

                    if (isACancellationRequest) {
                        cancellationPolicyId = getPolicyRequestCustomObject(newRequest.RecordTypeId).selectedPolizaId;
                    }

                    //Check only with the policy with the selected policyes.
                    if (pol.selected || (isACancellationRequest && pol.Id == cancellationPolicyId)) {
                        UniqueMapID = UniqueMapID = accId + pol.Id + recordTypeName;

                        if (isACancellationRequest && pol.Id == cancellationPolicyId) {
                            UniqueMapID = UniqueMapID =
                                accId +
                                getPolicyRequestCustomObject(newRequest.RecordTypeId).selectedPolizaId +
                                recordTypeName;
                        }

                        for (Gestion__c requestInDB : this.requestToCheckDuplicates) {
                            String uniqueMapIdForTheInsertedRequest =
                                String.valueOf(requestInDB.Cuenta__c) +
                                String.valueOf(requestInDB.Poliza__c) +
                                String.valueOf(requestInDB.RecordType.Name);

                            if (
                                recordTypeName == 'Baja' ||
                                recordTypeName == 'Cambio Plan' ||
                                recordTypeName == 'Cambio Medio Pago' ||
                                recordTypeName == 'Cambio Beneficiarios'
                            ) {
                                Gestion__c gestionAbierta = openGestionesByTypeByAccount.get(uniqueMapID);

                                if (UniqueMapID == uniqueMapIdForTheInsertedRequest) {
                                    //ya existe una gestion de igual tipo abierta --> ERROR!
                                    String errorString =
                                        'Ya existe una gestion de este tipo: ' +
                                        this.allRecordTypes.get(newRequest.recordTypeId).name +
                                        ' creada para este usuario y poliza sin cerrar';

                                    theareIsDuplicatedRequests = true;
                                    //Add error to the request that correspond.
                                    getPolicyRequestCustomObject(newRequest.recordTypeId)
                                        .errorsInTheRequests.add(errorString);
                                } else {
                                    openGestionesByTypeByAccount.put(UniqueMapID, newRequest);
                                }
                            }
                        }
                    }
                }
            }
        }

        return theareIsDuplicatedRequests;
    }

    public boolean hasDuplicatedRequests() {
        boolean errorsFound = false;
        String policyId = '';

        if (checkIfTheareIsDuplicatedRequestInTheDatabase()) {
            errorsFound = true;
        }

        if (getPolicyRequestCustomObject(recordTypeRetencion) != null) {
            policyId = getPolicyRequestCustomObject(recordTypeRetencion).selectedPolizaId;

            getPolicyRequestCustomObject(recordTypeRetencion).errorsInTheRequests = new List<String>();
            if (String.isNotBlank(policyId)) {
                if (
                    checkIfTheareIsDuplicatedRetentionRequestInTheDatabase(
                        getPolicyRequestCustomObject(recordTypeRetencion).planChangeController,
                        policyId
                    )
                ) {
                    errorsFound = true;
                }
            }
        }

        for (PolicyRequestCustomObject preSavedRequestCustomObject : preSavedRetentionOfPlanRequests) {
            preSavedRequestCustomObject.errorsInTheRequests = new List<String>();
            if (
                checkIfTheareIsDuplicatedRetentionRequestInTheDatabase(
                    preSavedRequestCustomObject.planChangeController,
                    preSavedRequestCustomObject.selectedPolizaId
                )
            )
                errorsFound = true;
        }

        if (getPolicyRequestCustomObject(recordTypeCambioPlan) != null) {
            getPolicyRequestCustomObject(recordTypeCambioPlan).errorsInTheRequests = new List<String>();
            policyId = getPolicyRequestCustomObject(recordTypeCambioPlan).selectedPolizaId;
            if (policyId != '') {
                if (
                    checkIfTheareIsDuplicatedPlanChangeRequestInTheDatabase(
                        getPolicyRequestCustomObject(recordTypeCambioPlan).planChangeController,
                        policyId
                    )
                )
                    errorsFound = true;
            }
        }

        for (PolicyRequestCustomObject preSavedRequestCustomObject : preSavedChangeOfPlanRequests) {
            preSavedRequestCustomObject.errorsInTheRequests = new List<String>();

            if (
                checkIfTheareIsDuplicatedPlanChangeRequestInTheDatabase(
                    preSavedRequestCustomObject.planChangeController,
                    preSavedRequestCustomObject.selectedPolizaId
                )
            )
                errorsFound = true;
        }

        return errorsFound;
    }

    public boolean checkIfTheareIsDuplicatedRetentionRequestInTheDatabase(PlanChangeController pc, String policyId) {
        boolean theareIsDuplicatedRequests = false;

        for (Gestion__c requestInDB : this.retentionRequestToCheckDuplicates) {
            boolean foundAnotherRequestInsertedToday = false;

            //we must to check if there's another retention request inserted today
            foundAnotherRequestInsertedToday = checkIfThereIsAnotherRetentionRequestInsertedToday(requestInDB);

            if (
                requestInDB.Tipo_Retencion__c == 'Venta retenida/modifica combo' &&
                requestInDB.Poliza__c == policyId &&
                pc.proposedPlanPrem == requestInDB.Premio_Plan_Nuevo__c &&
                pc.currentPlanPrem == requestInDB.Premio_Plan_Original__c &&
                pc.proposedPlanId == requestInDB.Nuevo_Plan__c &&
                pc.currentPlanId == requestInDB.Plan_Original__c &&
                pc.retType == 'retModif' &&
                foundAnotherRequestInsertedToday
            ) {
                //ya existe una gestion de igual tipo abierta --> ERROR!
                String errorString =
                    'Ya existe una gestion de este tipo: ' +
                    this.allRecordTypes.get(requestInDB.recordTypeId).name +
                    ' creada para este usuario y poliza sin cerrar';

                theareIsDuplicatedRequests = true;
                //Add error to the request that correspond.
                getPolicyRequestCustomObject(recordTypeRetencion).errorsInTheRequests.add(errorString);
            }

            if (
                requestInDB.Tipo_Retencion__c == 'Venta retenida/mantiene combo' &&
                requestInDB.Poliza__c == policyId &&
                pc.currentPlanPrem == requestInDB.Premio_Plan_Nuevo__c &&
                pc.currentPlanPrem == requestInDB.Premio_Plan_Original__c &&
                pc.currentPlanId == requestInDB.Nuevo_Plan__c &&
                pc.currentPlanId == requestInDB.Plan_Original__c &&
                pc.retType == 'retMant' &&
                foundAnotherRequestInsertedToday
            ) {
                //ya existe una gestion de igual tipo abierta --> ERROR!
                String errorString =
                    'Ya existe una gestion de este tipo: ' +
                    this.allRecordTypes.get(requestInDB.recordTypeId).name +
                    ' creada para este usuario y poliza sin cerrar';

                theareIsDuplicatedRequests = true;
                //Add error to the request that correspond.
                getPolicyRequestCustomObject(recordTypeRetencion).errorsInTheRequests.add(errorString);
            }
        }

        return theareIsDuplicatedRequests;
    }

    public boolean checkIfThereIsAnotherRetentionRequestInsertedToday(Gestion__c request) {
        //this method recieve a retention request inserted in the db and we have to assume that the user is trying to save a new request right now, that is system.now()

        //we take both year values
        Integer yearOfTheInsertedRequest = request.CreatedDate.year();
        Integer actualYear = system.now().yearGMT();

        if (yearOfTheInsertedRequest == actualYear) {
            //so we take both month values
            Integer monthOfTheInsertedRequest = request.CreatedDate.month();
            Integer actualMonth = system.now().monthGMT();

            if (monthOfTheInsertedRequest == actualMonth) {
                //if both request were from the same month, we have to check the day
                Integer dayOfTheInsertedRequest = request.CreatedDate.day();
                Integer actualDay = system.now().dayGMT();

                //finnaly, if both were made the same day, return true to add error
                if (dayOfTheInsertedRequest == actualDay)
                    return true;
            }
        }
        return false;
    }

    public boolean checkIfTheareIsDuplicatedPlanChangeRequestInTheDatabase(PlanChangeController pc, String policyId) {
        boolean theareIsDuplicatedRequests = false;

        for (Gestion__c requestInDB : this.cambioPlanRequestToCheckDuplicates) {
            if (
                requestInDB.Poliza__c == policyId &&
                pc.proposedPlanPrem == requestInDB.Premio_Plan_Nuevo__c &&
                pc.currentPlanPrem == requestInDB.Premio_Plan_Original__c &&
                pc.proposedPlanId == requestInDB.Nuevo_Plan__c &&
                pc.currentPlanId == requestInDB.Plan_Original__c &&
                pc.retType == 'retModif'
            ) {
                //ya existe una gestion de igual tipo abierta --> ERROR!
                String errorString =
                    'Ya existe una gestion de este tipo: ' +
                    this.allRecordTypes.get(requestInDB.recordTypeId).name +
                    ' creada para este usuario y poliza sin cerrar';

                theareIsDuplicatedRequests = true;
                //Add error to the request that correspond.
                getPolicyRequestCustomObject(recordTypeCambioPlan).errorsInTheRequests.add(errorString);
            }
        }

        return theareIsDuplicatedRequests;
    }
    // Deprecado EV1484
    // public void checkIfThereIsAMegaServicioRequest() {
    //     System.debug('checkIfThereIsAMegaServicioRequest');
    //     this.isSaving = true;
    //     //we check if we should show the confirmation dialog only if the button is showed
    //     if (showMegaservicioButton) {
    //         //we iterate over all presaved retention request and, if some request can request a megaservicio, set true the bool
    //         for (PolicyRequestCustomObject presavedRetention : preSavedRetentionOfPlanRequests) {
    //             //if there's the possibility to generate the megaservicio but the button were not be pressed, should show the confirm message
    //             if (
    //                 presavedRetention.planChangeController.canRequestAService &&
    //                 !presavedRetention.planChangeController.RequestAService
    //             ) {
    //                 hasAMegaservicioRequest = true;
    //                 break;
    //             }
    //         }
    //     }
    // }
    // Deprecado EV1484
    // public void controlMegaServicioButtonDisplayHelper() {
    //     controlMegaServicioButtonDisplay(preSavedRetentionOfPlanRequests);
    // }
    // Deprecado EV1484
    // public void controlMegaServicioButtonDisplay(List<PolicyRequestCustomObject> preSavedRetentionOfPlanRequests) {
    //     System.debug('controlMegaServicioButtonDisplay');
    //     if (showMegaservicioButton) {
    //         //if the button is showed is because all retention request can generate megaservicio request or some of these dont have the megaservicio allowed
    //         //so we refresh the boolean values for all presaves, this way we prevent the button dissappear
    //         for (PolicyRequestCustomObject presavedRetention : preSavedRetentionOfPlanRequests) {
    //             presavedRetention.planChangeController.canRequestAService = presavedRetention.planChangeController.checkIfTheClientCanRequestAService();
    //         }
    //     }

    //     boolean someRetentionCantGenerateTheMegaservicio = false;
    //     boolean someRetentionCanGenerateTheMegaservicio = false;
    //     showMegaservicioButton = false;

    //     //now we iterate over all retention request and set booleans based on if requests can or not generate a megaservicio request
    //     for (PolicyRequestCustomObject presavedRetention : preSavedRetentionOfPlanRequests) {
    //         if (!presavedRetention.planChangeController.canRequestAService) {
    //             someRetentionCantGenerateTheMegaservicio = true;
    //         } else {
    //             someRetentionCanGenerateTheMegaservicio = true;
    //         }
    //     }

    //     if (someRetentionCanGenerateTheMegaservicio && !someRetentionCantGenerateTheMegaservicio) {
    //         showMegaservicioButton = true;
    //         showCiberSeguridadServicioButton = true;
    //     }

    //     if (someRetentionCanGenerateTheMegaservicio && someRetentionCantGenerateTheMegaservicio) {
    //         showMegaservicioButton = checkIfTheMegaservicioButtonShouldBeShowed(preSavedRetentionOfPlanRequests, '11');
    //         showCiberSeguridadServicioButton = checkIfTheMegaservicioButtonShouldBeShowed(
    //             preSavedRetentionOfPlanRequests,
    //             '99'
    //         );
    //     }

    //     if (showMegaservicioButton) {
    //         //if the button should be showed, we put in false all boolean and put in true just the first for only appear the button at the first request
    //         for (PolicyRequestCustomObject presavedRetention : preSavedRetentionOfPlanRequests) {
    //             presavedRetention.planChangeController.canRequestAService = false;
    //         }

    //         if (preSavedRetentionOfPlanRequests.size() > 0) {
    //             preSavedRetentionOfPlanRequests[0].planChangeController.canRequestAService = true;
    //         }
    //     }
    // }
    // Deprecado EV1484
    // public boolean checkIfTheMegaservicioButtonShouldBeShowed(
    //     List<PolicyRequestCustomObject> preSavedRetentionsOfPlanRequests,
    //     String servicio
    // ) {
    //     System.debug('checkIfTheMegaservicioButtonShouldBeShowed: ' + servicio);

    //     List<PolicyRequestCustomObject> retentionsThatCantGenerateMegaservicio = new List<PolicyRequestCustomObject>();

    //     for (PolicyRequestCustomObject preSavedRetentionOfPlanRequests : preSavedRetentionsOfPlanRequests) {
    //         if (!preSavedRetentionOfPlanRequests.planChangeController.canRequestAService) {
    //             retentionsThatCantGenerateMegaservicio.add(preSavedRetentionOfPlanRequests);
    //         }
    //     }

    //     boolean allRetentionsThatCantGenerateMegaservicioAreProductsThatDontHaveTheService = false;

    //     System.debug('retentionsThatCantGenerateMegaservicio: ' + retentionsThatCantGenerateMegaservicio);

    //     if (retentionsThatCantGenerateMegaservicio.size() > 0) {
    //         for (PolicyRequestCustomObject retentionThatCantGenerateMegaservicio : retentionsThatCantGenerateMegaservicio) {
    //             if (
    //                 0 ==
    //                 [
    //                     SELECT COUNT()
    //                     FROM Servicios_Por_Producto__c
    //                     WHERE
    //                         Producto__c = :retentionThatCantGenerateMegaservicio.planChangeController.policy.Producto_IdBHSeg__c
    //                         AND Ramo__c = :retentionThatCantGenerateMegaservicio.planChangeController.policy.Ramo_IdBHSeg__c
    //                         // AND Servicio__c = '11']) {
    //                         AND Servicio__c = :servicio
    //                 ]
    //             ) {
    //                 allRetentionsThatCantGenerateMegaservicioAreProductsThatDontHaveTheService = true;
    //             } else {
    //                 allRetentionsThatCantGenerateMegaservicioAreProductsThatDontHaveTheService = false;
    //             }
    //         }
    //     }

    //     System.debug(
    //         'allRetentionsThatCantGenerateMegaservicioAreProductsThatDontHaveTheService: ' +
    //         allRetentionsThatCantGenerateMegaservicioAreProductsThatDontHaveTheService
    //     );

    //     if (allRetentionsThatCantGenerateMegaservicioAreProductsThatDontHaveTheService) {
    //         return true;
    //     }

    //     return false;
    // }

    public String controlFieldsInClaimRequest(Gestion__c req) {
        String errors = '';
        if (req.Fecha_y_Hora_de_Ocurrencia__c == null)
            errors += ' Fecha y hora de ocurrencia';
        if (req.Localidad_y_Provincia_de_ocurrencia__c == null)
            errors += '\r\n Localidad y provincia de ocurrencia';
        if (req.Tipo_de_Siniestro__c == null)
            errors += '\r\n Tipo de siniestro';
        if (req.Lugar_de_Ocurrencia__c == null)
            errors += '\r\n Lugar de ocurrencia';
        if (req.Descripcion__c == null)
            errors += '\r\n Descripcion';
        if (req.Email_Notificante__c == null)
            errors += '\r\n Email del notificante';
        if (req.Domicilio_Notificante__c == null)
            errors += '\r\n Domicilio del notificante';
        if (req.Detalle__c == null)
            errors += '\r\n Detalle';

        if (req.Causa_Siniestro__c == null)
            errors += '\r\n Causa Siniestro';
        if (req.Codigo_de_Riesgo__c == null)
            errors += '\r\n Codigo de Riesgo';

        if (errors != '')
            errors =
                'El tipo de gestion Declaracion de siniestro ' +
                'requiere de los siguientes campos que son obligatorios:' +
                errors;

        return errors;
    }

    /** Este metodo valida que las gestiones de cambio de plan o retencion, donde se modifica el plan, tengan seleccionados un plan distinto al original.
     * Solo trabaja sobre gestiones que NO SEAN de Hogar Protegido
     * **/
    public boolean checkIfTheRetentionAndChangeOfPlanMustToHaveTheNewPlanSelected(
        List<PolicyRequestCustomObject> policyRequestCustomListAux
    ) {
        //Check if the new plan in the change of plan request is not empty.
        for (PolicyRequestCustomObject policyRequestCustomObject : policyRequestCustomListAux) {
            if (
                policyRequestCustomObject.gestion.recordTypeId == recordTypeCambioPlan ||
                (policyRequestCustomObject.gestion.recordTypeId == recordTypeRetencion &&
                !policyRequestCustomObject.retentionTemplateRequest &&
                !policyRequestCustomObject.planChangeController.isAHogarProtegido)
            ) {
                //jira 1674 se cambia el == '' por string isblank (El proposedPLanDesc es para los planes que no son hogar protegido)
                if (
                    /*String.isBlank(policyRequestCustomObject.planChangeController.proposedPlanDesc)*/ policyRequestCustomObject.planChangeController.proposedPlanDesc ==
                    '' &&
                    ((policyRequestCustomObject.planChangeController.isRet &&
                    policyRequestCustomObject.planChangeController.retType == 'retModif') ||
                    (!policyRequestCustomObject.planChangeController.isRet))
                ) {
                    return true;
                }
            }
        }
        return false;
    }

    public boolean validateThatExistAtLeastOneRejectTransformationRequest() {
        for (PolicyRequestCustomObject policyRequestCustomObject : policyRequestCustomList) {
            if (policyRequestCustomObject.gestion.recordTypeId == recordTypeRechazaTransformacion) {
                return true;
            }
        }
        return false;
    }

    public boolean checkIfAtLeastOnePolicyIsSelected() {
        //If we have at least one pre saved we return true because we can save.
        if (preSavedChangeOfPlanRequests.size() > 0 || preSavedRetentionOfPlanRequests.size() > 0) {
            return true;
        }

        //If we have at least one policy selected we return true
        for (PolicyRequestCustomObject policyRequestCustomObject : policyRequestCustomList) {
            //If we are saving a claim sinister with false result, return true
            if (policyRequestCustomObject.gestion.recordTypeId == recordTypeDeclararSiniestro) {
                if (!getPolicyRequestCustomObject(recordTypeDeclararSiniestro).formRunnerController.formResult) {
                    return true;
                }
            }

            //if the actual request is a cancelation request, return true because
            //should be possible to save without having selected any policy
            if (
                (policyRequestCustomObject.gestion.recordTypeId == recordTypeBaja &&
                policyRequestCustomObject.selectedPolizaId == null) ||
                (policyRequestCustomObject.gestion.recordTypeId == recordTypeBaja &&
                policyRequestCustomObject.selectedPolizaId == '')
            ) {
                tryingToSaveACancelationRequestWithoutPolicy = true;
                return true;
            }

            if (policyRequestCustomObject.selectedPolizaId != null && policyRequestCustomObject.multiselect == false) {
                return true;
            }

            if (policyRequestCustomObject.multiselect) {
                List<PolizaWrapper> polizas = getPolizaWrapperList(policyRequestCustomObject.gestion.recordTypeId);
                for (PolizaWrapper poliza : polizas) {
                    if (poliza.selected) {
                        return true;
                    }
                }
            }
        }

        return false;
    }

    public List<Gestion__c> generateRequestToInsert(
        List<PolicyRequestCustomObject> policyRequestCustomListAux,
        Case caseForTheCall,
        Task telephoneCall,
        Account client
    ) {
        List<Gestion__c> requestToInsert = new List<Gestion__c>();

        for (PolicyRequestCustomObject policyRequestCustomObject : policyRequestCustomListAux) {
            if (policyRequestCustomObject.gestion.recordTypeId == recordTypeCambioPlan) {
                if (policyRequestCustomObject.selectedPolizaId == '') {
                    String error = 'Debe seleccionar una poliza para el tipo de cambio de plan.';
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, error);
                    ApexPages.addMessage(msg);
                } else {
                    policyRequestCustomObject.planChangeController.clientIdFromGestionarPoliza = client.Id;
                    policyRequestCustomObject.planChangeController.caseFromGestionarController = caseForTheCall;
                    policyRequestCustomObject.planChangeController.observations = policyRequestCustomObject.observations;
                    policyRequestCustomObject.planChangeController.saveRequest();
                    // policyRequestCustomObject.planChangeController.requestFromGestionarPoliza.Estado_MKT__c = 'Para Enviar'; //CNLS 19
                    requestToInsert.add(policyRequestCustomObject.planChangeController.requestFromGestionarPoliza);
                }
            } else if (policyRequestCustomObject.gestion.recordTypeId == recordTypeRetencion) {
                //if(!this.preSavedRetentionOfPlanRequests.isEmpty() && ! policyRequestCustomObject.retentionTemplateRequest) {// Jira 1674 agregado para discriminar el request "template"

                if (
                    (policyRequestCustomObject.retentionTemplateRequest &&
                    this.preSavedRetentionOfPlanRequests.isEmpty()) ||
                    (!policyRequestCustomObject.retentionTemplateRequest &&
                    policyRequestCustomObject.selectedPolizaId == '')
                ) {
                    String error = 'Debe seleccionar una poliza para el tipo retencion.';
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, error);
                    ApexPages.addMessage(msg);
                } else if (!policyRequestCustomObject.retentionTemplateRequest) {
                    policyRequestCustomObject.planChangeController.clientIdFromGestionarPoliza = client.Id;
                    policyRequestCustomObject.planChangeController.caseFromGestionarController = caseForTheCall;
                    policyRequestCustomObject.planChangeController.observations = policyRequestCustomObject.observations;
                    policyRequestCustomObject.planChangeController.saveRequest();
                    policyRequestCustomObject.planChangeController.requestFromGestionarPoliza.Aplica_Bonificacion__c = policyRequestCustomObject.gestion.Aplica_Bonificacion__c; // Jira bonificacion retencion
                    // policyRequestCustomObject.planChangeController.requestFromGestionarPoliza.Estado_MKT__c = 'Para Enviar'; //CNLS 19
                    requestToInsert.add(policyRequestCustomObject.planChangeController.requestFromGestionarPoliza);
                    //Service request
                    if (policyRequestCustomObject.planChangeController.RequestAService) {
                        // policyRequestCustomObject.planChangeController.ServiceRequest.Estado_MKT__c = 'Para Enviar'; //CNLS 19
                        requestToInsert.add(policyRequestCustomObject.planChangeController.ServiceRequest);
                    }
                }
                //}
            } else if (policyRequestCustomObject.gestion.recordTypeId == recordTypeDeclararSiniestro) {
                //Declaracion de siniestro, Creamos gestion aunque no haya ninguna seleccionada.
                Gestion__c request = policyRequestCustomObject.gestion.clone();
                request.Caso__c = caseForTheCall.Id;
                request.Cuenta__c = client.Id;
                request.Observaciones__c = policyRequestCustomObject.gestion.Observaciones__c;
                requestToInsert.add(request);
            } else if (policyRequestCustomObject.gestion.recordTypeId == recordTypeCambioDeBeneficiarios) {
                //Cambio de beneficiario.
                if (policyRequestCustomObject.selectedPolizaId != null) {
                    Gestion__c request = policyRequestCustomObject.gestion.clone();
                    request.Poliza__c = policyRequestCustomObject.selectedPolizaId;
                    request.Caso__c = caseForTheCall.Id;
                    request.Cuenta__c = client.Id;
                    request.Estado_MKT__c = 'Para Enviar'; //CNLS 19
                    request.Observaciones__c = policyRequestCustomObject.beneficiaryController.observations;

                    Decimal acumPercent = 0;
                    for (
                        Integer i = policyRequestCustomObject.beneficiaryController.beneficiaries.size() - 1; i >= 0; --i
                    ) {
                        Beneficiario_de_Gestion__c ben = policyRequestCustomObject.beneficiaryController.beneficiaries.get(
                            i
                        );
                        if (ben.Porcentaje__c == null) {
                            policyRequestCustomObject.beneficiaryController.beneficiaries.remove(i);
                        } else {
                            acumPercent += ben.Porcentaje__c;
                        }
                    }

                    if (policyRequestCustomObject.beneficiaryController.beneficiaries.size() == 0) {
                        ApexPages.addMessage(
                            new ApexPages.Message(ApexPages.Severity.ERROR, 'Debe ingresar al menos un beneficiario')
                        );
                        return null;
                    }

                    if (policyRequestCustomObject.beneficiaryController.beneficiaries.size() > 4) {
                        ApexPages.addMessage(
                            new ApexPages.Message(ApexPages.Severity.ERROR, 'Solo se pueden agregar hasta 4 beneficiarios.')
                        );
                        return null;
                    }

                    if (acumPercent != 100) {
                        ApexPages.addMessage(
                            new ApexPages.Message(
                                ApexPages.Severity.ERROR,
                                'El porcentaje de todos los beneficiarios debe sumar 100%'
                            )
                        );
                        return null;
                    }

                    requestToInsert.add(request);
                } else {
                    String error = 'Debe seleccionar una poliza para el tipo cambio de beneficiario.';
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, error);
                    ApexPages.addMessage(msg);
                }
            } else {
                //Si no es ninguno de los otros tipos. Es de Baja
                List<PolizaWrapper> polizas = getPolizaWrapperList(policyRequestCustomObject.gestion.recordTypeId);

                if (policyRequestCustomObject.multiselect) {
                    for (PolizaWrapper poliza : polizas) {
                        if (poliza.selected) {
                            Gestion__c request = policyRequestCustomObject.gestion.clone();
                            request.Poliza__c = poliza.Id;
                            request.Caso__c = caseForTheCall.Id;
                            request.Cuenta__c = client.Id;
                            request.Observaciones__c = policyRequestCustomObject.gestion.Observaciones__c;

                            if (
                                policyRequestCustomObject.tipo.equalsIgnoreCase('CAMBIO DE DOMICILIO DEL BIEN ASEGURADO') ||
                                policyRequestCustomObject.tipo.equalsIgnoreCase('CAMBIO DE DOMICILIO')
                            ) {
                                request.Estado_MKT__c = 'Para Enviar'; //CNLS 19
                            }
                            requestToInsert.add(request);
                        }
                    }
                } else {
                    //Just can select one policy
                    if (
                        policyRequestCustomObject.selectedPolizaId != null ||
                        policyRequestCustomObject.selectedPolizaId != ''
                    ) {
                        Gestion__c request = policyRequestCustomObject.gestion.clone();
                        request.Poliza__c = policyRequestCustomObject.selectedPolizaId;
                        request.Caso__c = caseForTheCall.Id;
                        request.Cuenta__c = client.Id;
                        request.Observaciones__c = policyRequestCustomObject.gestion.Observaciones__c;
                        requestToInsert.add(request);
                    }
                }
            }
        }

        //Set the opportunity
        if (opptId != null && requestToInsert.size() > 0 && requestToInsert != null) {
            for (Gestion__c request : requestToInsert) {
                request.Oportunidad__c = opptId;
            }
        }

        return requestToInsert;
    }

    /** Jira 1479
	 * @description Crea los casos para gestiones de baja, cuya de polizas valides esta entre 90 a 180 dias, que hayan pedido el reintegro a analizar.
	  Estos casos se crearan solo si son usuarios de calidad y no se ha seleccionado el resultado "Reintegro a Validar".
	 */
    private void createCaseForRefundToAnalyze(
        List<Gestion__c> requests,
        List<PolicyRequestCustomObject> policyRequestObjects,
        Case parentCase
    ) {
        if (this.isCallCenterAgentUser && this.getIsNotResultadoReintegroAAnalizar()) {
            Map<String, PolicyRequestCustomObject> requestCustomObjectsMap = this.generatePolicyRequestCustomObjectMap(
                policyRequestObjects
            );

            for (Gestion__c eachGestion : requests) {
                PolicyRequestCustomObject prCustomObjectToCheck = requestCustomObjectsMap.get(eachGestion.Poliza__c);

                if (prCustomObjectToCheck != null && prCustomObjectToCheck.refundToAnalyze) {
                    Case childCase = parentCase.clone();
                    childCase.ParentId = parentCase.Id;
                    childCase.Caso_Asociado__c = parentCase.Id;
                    childCase.Derivado_a__c = 'Calidad HS';
                    childCase.Reason = 'Facturación';
                    childCase.Resultado__c = 'Reintegro a Validar';
                    childCase.Resolucion_de_Reintegro__c = 'En análisis';
                    childCase.AccountId = parentCase.AccountId;
                    childCase.Gestion_Con_Reintegro_A_Analizar__c = eachGestion.id;
                    childCase.Producto_A_Reintegrar__c = this.clientPoliciesMap.get(
                            prCustomObjectToCheck.selectedPolizaId
                        )[0]
                        .Producto__c;
                    this.casesToAnalyze.add(childCase);
                }
            }
        }
    }

    private Map<String, PolicyRequestCustomObject> generatePolicyRequestCustomObjectMap(
        List<PolicyRequestCustomObject> policyRequestObjects
    ) {
        Map<String, PolicyRequestCustomObject> requestCustomObjectsMap = new Map<String, PolicyRequestCustomObject>();

        for (PolicyRequestCustomObject eachPRCO : policyRequestObjects) {
            requestCustomObjectsMap.put(eachPRCO.selectedPolizaId, eachPRCO);
        }

        return requestCustomObjectsMap;
    }

    // jira 1479
    private void createCaseForRefundToAnalyze(Gestion__c requestToUpdate, Case parentCase) {
        Case childCase = parentCase.clone();
        childCase.Parent = parentCase;
        childCase.Gestion_Con_Reintegro_A_Analizar__r = requestToUpdate;

        this.casesToAnalyze.add(childCase);
    }

    public Boolean getIsNotResultadoReintegroAAnalizar() {
        return !'Reintegro a Validar'.equalsIgnoreCase(caseForTheCall.Resultado__c);
    }
    // Deprecado EV1484
    // /**
    //  * si tiene letras devuelve true
    //  */
    // public boolean checkPostalCode(Gestion__c megaservicioRequest) {
    //     if (String.isNotBlank(megaservicioRequest.Codigo_Postal__c)) {
    //         if (!megaservicioRequest.Codigo_Postal__c.isNumeric()) {
    //             return true;
    //         }
    //     }

    //     return false;
    // }

    public List<Gestion__c> updateCaseInRequests(List<Gestion__c> requestToUpdate, Case caseForTheCall) {
        for (Gestion__c request : requestToUpdate) {
            request.Caso__c = caseForTheCall.Id;
        }
        return requestToUpdate;
    }

    public PageReference newCancellationRequest() {
        //baja prima unica
        if (
            this.getPolicyRequestCustomObject(recordTypeBaja) != null &&
            this.getPolicyRequestCustomObject(recordTypeBaja).gestion.Motivo_Baja__c == 'Baja Prima Unica'
        ) {
            if (String.isNotBlank(this.getPolicyRequestCustomObject(recordTypeBaja).selectedResultForBajaPrimaUnica)) {
                this.getPolicyRequestCustomObject(recordTypeBaja).gestion.Resultado__c = this.getPolicyRequestCustomObject(
                        recordTypeBaja
                    )
                    .selectedResultForBajaPrimaUnica;
            }
        }

        //Jira 1319 Validacion Baja Sapienza
        PolicyRequestCustomObject bajaRequest = this.getPolicyRequestCustomObject(recordTypeBaja);
        if (
            bajaRequest != null &&
            bajaRequest.gestion.Motivo_Baja__c == 'Baja Individual Sapienza' &&
            !GestionarPolizaControllerHelper.validateBajaIndividualSapienza(bajaRequest.gestion)
        ) {
            return null;
        }

        //control cancellation date
        String unallowedDate = '';
        if (this.getPolicyRequestCustomObject(recordTypeBaja) != null) {
            unallowedDate = checkCancellationDate();
        }

        if (unallowedDate != '') {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, unallowedDate);
            ApexPages.addMessage(msg);
            return null;
        }

        // Jira 1602
        if (!GestionarPolizaControllerHelper.validateMotivoDeBajaAndResultado(bajaRequest.gestion)) {
            return null;
        }

        //Empty the error list always the button is clicked, this way we prevent repeat the error message in the vfp
        getPolicyRequestCustomObject(recordTypeBaja).errorsInTheRequests = new List<String>();

        //if the policy that is trying to cancel is the last one, throw a message
        if (getPolicyRequestCustomObject(recordTypeBaja).polizasWrapperList.size() == 1) {
            getPolicyRequestCustomObject(recordTypeBaja)
                .errorsInTheRequests.add(
                    'La actual gestión de baja se esta aplicando sobre la última póliza disponible. No se puede generar una nueva : no hay más pólizas.'
                );
            return null;
        }

        if (
            getPolicyRequestCustomObject(recordTypeBaja).selectedPolizaId != null ||
            getPolicyRequestCustomObject(recordTypeBaja).selectedPolizaId != ''
        ) {
            //Add an error because the user has to select a policy.
            getPolicyRequestCustomObject(recordTypeBaja)
                .errorsInTheRequests.add('Debe seleccionar una poliza sobre la que aplicar la gestion de baja.');
        }

        if (
            getPolicyRequestCustomObject(recordTypeBaja).selectedPolizaId != null &&
            getPolicyRequestCustomObject(recordTypeBaja).selectedPolizaId != ''
        ) {
            getPolicyRequestCustomObject(recordTypeBaja).createCancellationLabel();
            preSavedCancellationRequests.add(getPolicyRequestCustomObject(recordTypeBaja));
            dinamicWhereBaja +=
                ' AND Id != \'' +
                String.escapeSingleQuotes(getPolicyRequestCustomObject(recordTypeBaja).selectedPolizaId) +
                '\'';

            deleteFromRequestList(recordTypeBaja);
            isBaja = false;
            System.currentPageReference().getParameters().put('requestToStart', 'Baja');
            this.showRequest();
        }

        return null;
    }

    public void deletePreSavedChangeOfPlan() {
        String idToDelete = System.currentPageReference().getParameters().get('presevedChangeToDelete');
        PolicyRequestCustomObject policyToDelete;
        integer indice = 0;
        integer indiceAux = 0;
        for (PolicyRequestCustomObject policy : preSavedChangeOfPlanRequests) {
            if (policy.selectedPolizaId == idToDelete) {
                policyToDelete = policy;
                indice = indiceAux;
                dinamicWhereCambioPlan = dinamicWhereCambioPlan.replace(
                    ' AND Id != \'' +
                    String.escapeSingleQuotes(policy.selectedPolizaId) +
                    '\'',
                    ' '
                );

                //We are going to re insert the policy to the policy list.
                List<Poliza__c> policyToAddAgain = [
                    SELECT
                        Id,
                        Name,
                        Producto__c,
                        Ramo__c,
                        Poliza__c,
                        Certificado__c,
                        Endoso__c,
                        Desde__c,
                        Hasta__c,
                        Estado__c,
                        Emision__c,
                        Poliza_Anterior__c,
                        Canal_1__c,
                        Canal_1_IdBHSeg__c,
                        Canal_2__c,
                        Certificado_Id_BHSeg__c,
                        Producto_IdBHSeg__c,
                        Ramo_IdBHSeg__c,
                        Cuenta__c,
                        Medio_de_Pago__c,
                        Origen_de_Pago__c,
                        Cuenta_Pago__c,
                        Productor__c, // Jira 1522
                        Incluye_Camara__c,
                        Premio__c,
                        Tipo_Endoso_IdBHSeg__c
                    FROM Poliza__c
                    WHERE Id = :policy.selectedPolizaId
                ];

                getPolizaWrapperList(recordTypeCambioPlan).add(this.generatePolicyRequestCustomObject(policyToAddAgain)[0]);
            }
            indiceAux += 1;
        }
        preSavedChangeOfPlanRequests.remove(indice);
    }

    public void deletePreSavedRetention() {
        String idToDelete = System.currentPageReference().getParameters().get('presevedChangeToDelete');

        PolicyRequestCustomObject policyToDelete;
        integer indice = 0;
        integer indiceAux = 0;
        for (PolicyRequestCustomObject policy : preSavedRetentionOfPlanRequests) {
            if (policy.selectedPolizaId == idToDelete) {
                policyToDelete = policy;
                indice = indiceAux;
                dinamicWhereRetencion = dinamicWhereRetencion.replace(
                    ' AND Id != \'' +
                    String.escapeSingleQuotes(policy.selectedPolizaId) +
                    '\'',
                    ' '
                );

                //We are going to re insert the policy to the policy list.
                List<Poliza__c> policyToAddAgain = [
                    SELECT
                        Id,
                        Name,
                        Producto__c,
                        Ramo__c,
                        Poliza__c,
                        Certificado__c,
                        Endoso__c,
                        Desde__c,
                        Hasta__c,
                        Estado__c,
                        Emision__c,
                        Poliza_Anterior__c,
                        Canal_1__c,
                        Canal_1_IdBHSeg__c,
                        Canal_2__c,
                        Certificado_Id_BHSeg__c,
                        Producto_IdBHSeg__c,
                        Ramo_IdBHSeg__c,
                        Cuenta__c,
                        Medio_de_Pago__c,
                        Origen_de_Pago__c,
                        Cuenta_Pago__c,
                        Productor__c, // Jira 1522
                        Incluye_Camara__c,
                        Premio__c,
                        Tipo_Endoso_IdBHSeg__c
                    FROM Poliza__c
                    WHERE Id = :policy.selectedPolizaId
                ];
                getPolizaWrapperList(recordTypeRetencion).add(this.generatePolicyRequestCustomObject(policyToAddAgain)[0]);
            }
            indiceAux += 1;
        }

        preSavedRetentionOfPlanRequests.remove(indice);

        //now we recalculate the presaved retention to only show the megaservicio button at the first request place
        // Deprecado EV1484
        // controlMegaServicioButtonDisplay(preSavedRetentionOfPlanRequests);
    }

    public void deletePreSavedCancellation() {
        String idToDelete = System.currentPageReference().getParameters().get('presavedCancellationToDelete');
        PolicyRequestCustomObject policyToDelete;
        integer indice = 0;
        integer indiceAux = 0;
        for (PolicyRequestCustomObject policy : preSavedCancellationRequests) {
            if (policy.selectedPolizaId == idToDelete) {
                policyToDelete = policy;
                indice = indiceAux;
                dinamicWhereBaja = dinamicWhereBaja.replace(
                    ' AND Id != \'' +
                    String.escapeSingleQuotes(policy.selectedPolizaId) +
                    '\'',
                    ' '
                );

                //We are going to re insert the policy to the policy list.
                List<Poliza__c> policyToAddAgain = [
                    SELECT
                        Id,
                        Name,
                        Producto__c,
                        Ramo__c,
                        Poliza__c,
                        Certificado__c,
                        Endoso__c,
                        Desde__c,
                        Hasta__c,
                        Estado__c,
                        Canal_1__c,
                        Emision__c,
                        Poliza_Anterior__c,
                        Canal_1_IdBHSeg__c,
                        Canal_2__c,
                        Certificado_Id_BHSeg__c,
                        Producto_IdBHSeg__c,
                        Ramo_IdBHSeg__c,
                        Cuenta__c,
                        Medio_de_Pago__c,
                        Origen_de_Pago__c,
                        Cuenta_Pago__c,
                        Productor__c, // Jira 1522
                        Incluye_Camara__c,
                        Premio__c,
                        Tipo_Endoso_IdBHSeg__c
                    FROM Poliza__c
                    WHERE Id = :policy.selectedPolizaId
                ];
                getPolizaWrapperList(recordTypeBaja).add(this.generatePolicyRequestCustomObject(policyToAddAgain)[0]);
            }
            indiceAux += 1;
        }
        preSavedCancellationRequests.remove(indice);
    }

    public void controlReasonForTheCall() {
        isAnErrorWithTheReasonForTheCall = true;
        if (callType == 'OUT') {
            if (
                caseForTheCall.Reason == 'RESPUESTA CLIENTE' ||
                caseForTheCall.Reason == 'CÚMULOS' ||
                caseForTheCall.Reason == 'FACTURACIÓN' ||
                caseForTheCall.Reason == 'TRANSFORMACIÓN DE PLAN' ||
                caseForTheCall.Reason == 'BAJA' ||
                caseForTheCall.Reason == 'MODIFICACIONES' ||
                caseForTheCall.Reason == 'CONSULTAS GENERALES' ||
                caseForTheCall.Reason == 'ENVÍO DE PÓLIZAS' ||
                caseForTheCall.Reason == 'SINIESTROS' ||
                caseForTheCall.Reason == 'VENTA' ||
                caseForTheCall.Reason == 'OTRO'
            ) {
                isAnErrorWithTheReasonForTheCall = false;
            }
        } else {
            if (
                caseForTheCall.Reason == 'RESPUESTA CLIENTE' ||
                caseForTheCall.Reason == 'CÚMULOS' ||
                caseForTheCall.Reason == 'FACTURACIÓN' ||
                caseForTheCall.Reason == 'TRANSFORMACIÓN DE PLAN' ||
                caseForTheCall.Reason == 'BAJA' ||
                caseForTheCall.Reason == 'MODIFICACIONES' ||
                caseForTheCall.Reason == 'CONSULTAS GENERALES' ||
                caseForTheCall.Reason == 'ENVÍO DE PÓLIZAS' ||
                caseForTheCall.Reason == 'SINIESTROS' ||
                caseForTheCall.Reason == 'Otro'
            ) {
                isAnErrorWithTheReasonForTheCall = false;
            }
        }
    }

    public PageReference cleanDataFromLastPolicyInRetentionRequest() {
        if (isRetencion) {
            String recordTypeRetencion = [SELECT Id FROM RecordType WHERE DeveloperName = 'Retencion' AND IsActive = TRUE]
            .Id;
            deleteFromRequestList(recordTypeRetencion);
            isRetencion = false;
            System.currentPageReference().getParameters().put('requestToStart', 'Retencion');
            this.showRequest();
        }
        return null;
    }

    public void controlResultForTheCall() {
        isAnErrorWithTheResultForTheCall = false;

        controlReasonForTheCall();
        if (callType == 'OUT') {
            if (
                caseForTheCall.Reason == 'OTRO' &&
                (caseForTheCall.Resultado__c == 'Se deriva a Ventas' ||
                caseForTheCall.Resultado__c == 'Se deriva a BH.' ||
                caseForTheCall.Resultado__c == 'Se deriva a Customer' ||
                caseForTheCall.Resultado__c == 'Se deriva a Retencion' ||
                caseForTheCall.Resultado__c == 'Se deriva a Siniestros')
            ) {
                isAnErrorWithTheResultForTheCall = true;
            }
        } else if (callType == 'IN' && caseForTheCall.Resultado__c == 'No contactado') {
            isAnErrorWithTheResultForTheCall = true;
        } else {
            isAnErrorWithTheResultForTheCall = false;
        }
    }

    public PolicyRequestCustomObject getPolicyRequestCustomObject(String recordType) {
        for (PolicyRequestCustomObject policyRequestCustomObject : policyRequestCustomList) {
            if (policyRequestCustomObject.gestion.RecordTypeId == recordType) {
                return policyRequestCustomObject;
            }
        }
        return null;
    }

    public List<PolizaWrapper> getPolizaWrapperList(String recordType) {
        for (PolicyRequestCustomObject policyRequestCustomObject : policyRequestCustomList) {
            if (policyRequestCustomObject.gestion.RecordTypeId == recordType) {
                return policyRequestCustomObject.polizasWrapperList;
            }
        }
        return null;
    }

    //Borra la gestion del tipo recordTypeId, de las gestiones que se estan realizando
    public void deleteFromRequestList(String recordTypeId) {
        PolicyRequestCustomObject policyRequestToRemove = null;
        //Itera por cada request buscando el correcto a borrar, si lo encuentra lo guarda y sale del loop.
        for (PolicyRequestCustomObject policyRequestCustomObject : policyRequestCustomList) {
            if (policyRequestCustomObject.gestion.RecordTypeId == recordTypeId) {
                policyRequestToRemove = policyRequestCustomObject;
                break;
            }
        }
        //Se pregunta si es distinto a null para evitar un indexOutOfBounds.
        if (policyRequestToRemove != null) {
            policyRequestCustomList.remove(policyRequestCustomList.indexOf(policyRequestToRemove));
        }
    }

    public PageReference sendActualValuesToController() {
        //this method was made just to call it when the user is filling fields in the page.
        //Eg: When delete a pre-saved request having prefilled fields for another request
        //this fields lost their values, but invoking this method with actionfunction in vfp fix it.
        return null;
    }

    //HOGAR MA
    public class Incendio {
        public Integer incendio_de_edificio { get; set; }
        public Integer danios_por_granizo_al_edificio { get; set; }
        public Integer responsabilidad_civil_hechos_privados { get; set; }
        public Integer rc_por_incendio_o_explosion { get; set; }
        public Integer incendio_del_contenido { get; set; }
        public Integer gastos_de_limpieza_por_incendio { get; set; }
        public Integer alojamiento_por_incendio_o_explosion { get; set; }
        public String opcion { get; set; }
        public List<SelectOption> opciones { get; set; }

        public Incendio() {
            this.opciones = new List<SelectOption>();
            this.opciones.add(new SelectOption('A', 'A'));
            this.opciones.add(new SelectOption('B', 'B'));
            this.opciones.add(new SelectOption('C', 'C'));
            this.opciones.add(new SelectOption('D', 'D'));
        }
    }

    public class Contenido {
        public Integer robo_o_hurto_del_contenido_general { get; set; }
        public Integer rotura_de_cristales { get; set; }
        public Integer incendio_del_contenido { get; set; }
        public Integer responsabilidad_civil_tenencia_de_animales { get; set; }
        public Integer electrodomesticos_o_equipos_electronicos { get; set; }
        public Integer danios_por_robo_o_intento_de_robo { get; set; }
        public Integer responsabilidad_civil_hechos_privados { get; set; }
        public Integer danios_por_agua_al_contenido { get; set; }
        public String opcion { get; set; }
        public List<SelectOption> opciones { get; set; }

        public Contenido() {
            this.opciones = new List<SelectOption>();
            this.opciones.add(new SelectOption('A', 'A'));
            this.opciones.add(new SelectOption('B', 'B'));
            this.opciones.add(new SelectOption('C', 'C'));
        }
    }

    public class Servicios {
        public Servicios(List<Combinacion_Modulo_Servicios__c> combinacionesModuloServicio) {
            this.opciones = new List<SelectOption>();
            this.combinacionesModuloServicio = combinacionesModuloServicio;
            this.opciones = getOpcionesFromCs();
            this.asistencia_clasica = false;
            this.asistencia_full = false;
            this.asistencia_plus = false;
        }

        public Integer rotura_de_cristales { get; set; }
        public Integer responsabilidad_civil_tenencia_de_animales { get; set; }
        public Integer robo_o_hurto_en_vacaciones { get; set; }
        public Integer objetos_especificos { get; set; }
        public Integer danios_por_robo_o_intento_de_robo { get; set; } // CNLS Retencion Pardo
        public Integer electrodomesticos_o_equipos_electronicos { get; set; }
        public Integer danios_por_agua_al_contenido { get; set; }
        public String opcion { get; set; }
        public List<SelectOption> opciones { get; set; }
        public Boolean asistencia_clasica { get; set; }
        public Boolean asistencia_plus { get; set; }
        public Boolean asistencia_full { get; set; }
        public List<Combinacion_Modulo_Servicios__c> combinacionesModuloServicio { get; set; }

        public List<SelectOption> getOpcionesFromCs() {
            List<SelectOption> response = new List<SelectOption>();
            for (Combinacion_Modulo_Servicios__c opcion : combinacionesModuloServicio) {
                response.add(new SelectOption(opcion.codigo__c, opcion.Descripcion__c));
            }
            return response;
        }
    }

    public class Premios {
        public Premios() {
            this.premio = 0;
            this.premio_diario = 0;
            this.incluye_camara = false;
        }
        public Integer premio { get; set; }
        public Integer premio_diario { get; set; }
        public Boolean incluye_camara { get; set; }
    }

    public void onchangeServiciosOptionHandlerHogarProtegidoV2CambioPlan() {
        this.requestToStart = 'CambioPlan';
        this.module_changed = Apexpages.currentPage().getParameters().get('selectedOption');
        this.changeModuleOption();
    }

    public void onchangeServiciosOptionHandlerHogarProtegidoV2Retencion() {
        this.requestToStart = 'Retencion';
        this.module_changed = Apexpages.currentPage().getParameters().get('selectedOption');
        this.changeModuleOption();
    }

    // CNLS RETENCION PARDO
    /**
     * Actualiza todas las sumas aseguradas a contratar para la retencion o cambio de plan de un Hogar Protegido Pardo
     */
    public void changeCoveragesForPardo() {
        PolicyRequestCustomObject aPolicyRequest = this.getActualPolicyRequestForCambioPlanOrRetention();

        if (
            aPolicyRequest != null &&
            String.isNotBlank(aPolicyRequest.combinatoria_aContratar) &&
            aPolicyRequest.combinatoria_aContratar.length() == 3
        ) {
            this.setPardoCoverages(aPolicyRequest);
            if (this.requestToStart == 'Retencion') {
                aPolicyRequest.planChangeController.checkIfTheClientCanRequestAService_forHogarProtegido(
                    aPolicyRequest.combinatoria,
                    aPolicyRequest.combinatoria_aContratar
                );
            }
        }
    }

    // CNLS RETENCION PARDO
    public void setPardoCoverages(PolicyRequestCustomObject aRequestToUpgradeCoverages) {
        String coverageOption = aRequestToUpgradeCoverages.combinatoria_aContratar.substring(0, 1);
        String firstModule = '1' + coverageOption;
        String secondModule = '2' + coverageOption;
        String thirdModule = '3' + coverageOption;

        if (
            aRequestToUpgradeCoverages.planChangeController.sumaCoberturasMap.containsKey(firstModule) &&
            aRequestToUpgradeCoverages.planChangeController.sumaCoberturasMap.containsKey(secondModule) &&
            aRequestToUpgradeCoverages.planChangeController.sumaCoberturasMap.containsKey(thirdModule)
        ) {
            this.setAContratarIncendioValuesFromCS(
                aRequestToUpgradeCoverages,
                aRequestToUpgradeCoverages.planChangeController.sumaCoberturasMap.get(firstModule)
            );
            this.setAContratarContenidoValuesFromCS(
                aRequestToUpgradeCoverages,
                aRequestToUpgradeCoverages.planChangeController.sumaCoberturasMap.get(secondModule)
            );
            this.setServiciosValuesFromCS(
                aRequestToUpgradeCoverages,
                aRequestToUpgradeCoverages.planChangeController.sumaCoberturasMap.get(thirdModule)
            );
            this.defineCamaraAndPremiosValues(aRequestToUpgradeCoverages);
        }
    }

    // CNLS RETENCION PARDO
    public PolicyRequestCustomObject getActualPolicyRequestForCambioPlanOrRetention() {
        List<PolicyRequestCustomObject> policyrequestCustomObjectLists;
        // Si no es cambioPlan, se asume que es retencion
        if ('CambioPlan'.equalsIgnoreCase(requestToStart)) {
            policyrequestCustomObjectLists = policyRequestCustomList;
        } else {
            policyrequestCustomObjectLists = preSavedRetentionOfPlanRequests;
        }

        for (PolicyRequestCustomObject aPolicyrequestCustomObject : policyrequestCustomObjectLists) {
            if (aPolicyrequestCustomObject.planChangeController.isAHogarProtegido) {
                return aPolicyrequestCustomObject;
            }
        }
        return null;
    }

    // CNLS RETENCION PARDO
    public void setAContratarIncendioValuesFromCS(PolicyRequestCustomObject prco, List<Suma_Cobertura__c> coberturas) {
        for (Suma_Cobertura__c cobertura : coberturas) {
            if (String.isNotBlank(cobertura.segmento__c)) {
                prco.incendio_aContratar.opcion = cobertura.segmento__c;
            }
            switch on cobertura.cobertura__c {
                when '031' {
                    prco.incendio_aContratar.incendio_de_edificio = Integer.valueOf(cobertura.suma__c);
                }
                when '032' {
                    prco.incendio_aContratar.incendio_del_contenido = Integer.valueOf(cobertura.suma__c);
                }
                when '035' {
                    prco.incendio_aContratar.rc_por_incendio_o_explosion = Integer.valueOf(cobertura.suma__c);
                }
                when '036' {
                    prco.incendio_aContratar.alojamiento_por_incendio_o_explosion = Integer.valueOf(cobertura.suma__c);
                }
                when '037' {
                    prco.incendio_aContratar.gastos_de_limpieza_por_incendio = Integer.valueOf(cobertura.suma__c);
                }
                when '040' {
                    prco.incendio_aContratar.responsabilidad_civil_hechos_privados = Integer.valueOf(cobertura.suma__c);
                }
                when '060' {
                    prco.incendio_aContratar.danios_por_granizo_al_edificio = Integer.valueOf(cobertura.suma__c);
                }
            }
        }
    }

    // CNLS RETENCION PARDO
    public void setAContratarContenidoValuesFromCS(PolicyRequestCustomObject prco, List<Suma_Cobertura__c> coberturas) {
        for (Suma_Cobertura__c cobertura : coberturas) {
            if (String.isNotBlank(cobertura.segmento__c)) {
                prco.contenido_aContratar.opcion = cobertura.segmento__c;
            }
            switch on cobertura.cobertura__c {
                when '029' {
                    prco.contenido_aContratar.robo_o_hurto_del_contenido_general = Integer.valueOf(cobertura.suma__c);
                }
                when '033' {
                    prco.contenido_aContratar.electrodomesticos_o_equipos_electronicos = Integer.valueOf(cobertura.suma__c);
                }
                when '038' {
                    prco.contenido_aContratar.danios_por_robo_o_intento_de_robo = Integer.valueOf(cobertura.suma__c);
                }
                when '040' {
                    prco.contenido_aContratar.responsabilidad_civil_hechos_privados = Integer.valueOf(
                        Decimal.valueOf(cobertura.suma__c)
                    );
                }
                when '058' {
                    prco.contenido_aContratar.danios_por_agua_al_contenido = Integer.valueOf(cobertura.suma__c);
                }
                when '034' {
                    prco.contenido_aContratar.rotura_de_cristales = Integer.valueOf(cobertura.suma__c);
                }
                when '032' {
                    prco.contenido_aContratar.incendio_del_contenido = Integer.valueOf(Decimal.valueOf(cobertura.suma__c));
                }
                when '055' {
                    prco.contenido_aContratar.responsabilidad_civil_tenencia_de_animales = Integer.valueOf(
                        cobertura.suma__c
                    );
                }
            }
        }
    }

    /**
     * onchange del combo "Opcion" del Modulo 3 Servicios del hogar protegido A Contratar
     */
    public void changeModuleOption() {
        PolicyRequestCustomObject thisPW;
        List<PolicyRequestCustomObject> pws;

        if (requestToStart == 'CambioPlan') {
            pws = policyRequestCustomList;
        } else if (requestToStart == 'Retencion') {
            pws = preSavedRetentionOfPlanRequests;
        }
        for (PolicyRequestCustomObject pw : pws) {
            if (pw.planChangeController.isAHogarProtegido) {
                thisPW = pw;
                break;
            }
        }
        if (thisPW != null) {
            String key = '3' + module_changed;
            if (String.isNotBlank(key)) {
                String aux = thisPW.combinatoria.substring(0, 2);
                if (aux.length() == 2) {
                    thisPW.combinatoria_aContratar = aux + module_changed;
                }
                this.setCoberturasInModules(thisPW, key);
                if (requestToStart == 'Retencion') {
                    thisPW.planChangeController.checkIfTheClientCanRequestAService_forHogarProtegido(
                        thisPW.combinatoria,
                        thisPW.combinatoria_aContratar
                    );
                }
            }
        }
    }

    public void checkRetType() {
        PolicyRequestCustomObject thisPW;
        String retType = '';

        for (PolicyRequestCustomObject pw : preSavedRetentionOfPlanRequests) {
            if (pw.planChangeController.isAHogarProtegido) {
                thisPW = pw;
                retType = thisPw.planChangeController.retType;
                break;
            }
        }

        if (thisPW != null && retType == 'retMant') {
            String key = thisPW.combinatoria.substring(1, 3);

            thisPW.combinatoria_aContratar = thisPW.combinatoria;
            if (thisPW.planChangeController.getIsHogarProtegidoPardo()) {
                // CNLS retencion pardo
                this.changeCoveragesForPardo();
            } else if (thisPW.combinatoria_aContratar.length() == 3) {
                String opcion = thisPW.combinatoria_aContratar.substring(2, 3);

                if (String.isNotBlank(opcion)) {
                    thisPW.servicios_aContratar.opcion = opcion;
                    this.setCoberturasInModules(thisPW, key);
                    thisPW.planChangeController
                        .checkIfTheClientCanRequestAService_forHogarProtegido(
                            thisPW.combinatoria,
                            thisPW.combinatoria_aContratar
                        );
                    this.defineCamaraAndPremiosValues(thisPW);
                    this.defineAsistenciaDomiciliaria(thisPW, thisPW.servicios_aContratar.opcion, true);
                }
            }
        }
    }

    public void defineCamaraAndPremiosValues(PolicyRequestCustomObject pw) {
        String combinatoria_aContratar = pw.combinatoria_aContratar;
        GestionarPolizaController.Premios premios = pw.premios_aContratar;

        Cotizacion__c cotizacion = pw.planChangeController.cotizacionesMap.get(combinatoria_aContratar);
        if (cotizacion != null) {
            String camara = cotizacion.camara__c;
            String premio_mensual = cotizacion.premio__c;
            if (String.isNotBlank(camara)) {
                if (camara.toUpperCase() == 'S') {
                    premios.incluye_camara = true;
                } else if (camara.toLowerCase() == 'N') {
                    premios.incluye_camara = false;
                }
            }
            if (String.isNotBlank(premio_mensual)) {
                premios.premio = Integer.valueOf(premio_mensual);
                premios.premio_diario = premios.premio / 31;
            }
        }
    }

    public void setCoberturasInModules(PolicyRequestCustomObject pw, String threeKeys) {
        String key = threeKeys;
        if (key.contains('3') && pw.planChangeController.sumaCoberturasMap.get(key) != null) {
            this.setServiciosValuesFromCS(pw, pw.planChangeController.sumaCoberturasMap.get(key));
            this.defineAsistenciaDomiciliaria(pw, pw.servicios_aContratar.opcion, true);
            this.defineCamaraAndPremiosValues(pw);
        }
    }

    /**
     * Setea los servicios del hogar protegido a contratar
     */
    public void setServiciosValuesFromCS(PolicyRequestCustomObject policyRequest, List<Suma_Cobertura__c> coberturas) {
        for (Suma_Cobertura__c cobertura : coberturas) {
            if (policyRequest.planChangeController.hogarProtegidoVersion == cobertura.plan__c) {
                if (cobertura.cobertura__c == '033') {
                    policyRequest.servicios_aContratar.electrodomesticos_o_equipos_electronicos = Integer.valueOf(
                        cobertura.suma__c
                    );
                }

                if (cobertura.cobertura__c == '034') {
                    policyRequest.servicios_aContratar.rotura_de_cristales = Integer.valueOf(cobertura.suma__c);
                }

                if (cobertura.cobertura__c == '053') {
                    policyRequest.servicios_aContratar.robo_o_hurto_en_vacaciones = Integer.valueOf(cobertura.suma__c);
                }

                if (cobertura.cobertura__c == '054') {
                    policyRequest.servicios_aContratar.objetos_especificos = Integer.valueOf(cobertura.suma__c);
                }

                if (cobertura.cobertura__c == '055') {
                    policyRequest.servicios_aContratar.responsabilidad_civil_tenencia_de_animales = Integer.valueOf(
                        cobertura.suma__c
                    );
                }

                if (cobertura.cobertura__c == '058') {
                    policyRequest.servicios_aContratar.danios_por_agua_al_contenido = Integer.valueOf(cobertura.suma__c);
                }
            }
        }
    }

    public void defineAsistenciaDomiciliaria(PolicyRequestCustomObject pw, String opcion, boolean calledFromAContratar) {
        if (opcion == 'A') {
            pw.servicios_aContratar.asistencia_clasica = true;
            pw.servicios_aContratar.asistencia_plus = false;
            pw.servicios_aContratar.asistencia_full = false;

            if (!calledFromAContratar) {
                pw.servicios.asistencia_clasica = true;
                pw.servicios.asistencia_plus = false;
                pw.servicios.asistencia_full = false;
            }
        } else if (opcion == 'B') {
            pw.servicios_aContratar.asistencia_clasica = false;
            pw.servicios_aContratar.asistencia_plus = true;
            pw.servicios_aContratar.asistencia_full = false;

            if (!calledFromAContratar) {
                pw.servicios.asistencia_clasica = false;
                pw.servicios.asistencia_plus = true;
                pw.servicios.asistencia_full = false;
            }
        } else if (opcion == 'C') {
            pw.servicios_aContratar.asistencia_clasica = false;
            pw.servicios_aContratar.asistencia_plus = false;
            pw.servicios_aContratar.asistencia_full = true;

            if (!calledFromAContratar) {
                pw.servicios.asistencia_clasica = false;
                pw.servicios.asistencia_plus = false;
                pw.servicios.asistencia_full = true;
            }
        }
    }

    public void bajaSapienzaPaymentMethodChangedHelper() {
        getPolicyRequestCustomObject(recordTypeBaja).bajaSapienzaPaymentMethodChanged();
    }

    // DELIVERY
    public void resendPhisycalPolicies() {
        // Modificado por jira 1603
        this.resendPolicies(Enumerate.ResendPolicyType.PHYSICAL);
    }

    public void resendDigitalPolicies() {
        // Modificado por Jira 1603
        this.resendPolicies(Enumerate.ResendPolicyType.DIGITAL);
    }

    // Jira 1603
    public void resendPolicies(Enumerate.ResendPolicyType resendType) {
        User currentUser = UserChecker.getCurrentUser();

        List<Account> client = [SELECT Id, Cuit__c FROM Account WHERE Id = :accId];

        List<ApexPages.Message> messagesToShowInThePage = new List<ApexPages.Message>();

        for (PolicyRequestCustomObject policyRequestCustomObject : policyRequestCustomList) {
            if ((policyRequestCustomObject.gestion.recordTypeId == recordTypeReenvioPoliza)) {
                List<PolizaWrapper> polizas = getPolizaWrapperList(policyRequestCustomObject.gestion.recordTypeId);
                for (PolizaWrapper poliza : polizas) {
                    if (poliza.selected) {
                        Boolean result;
                        String message;
                        if (resendType == Enumerate.ResendPolicyType.PHYSICAL) {
                            result = this.policyResender.resendPhysicalPolicy(
                                poliza.RamoIdBHSeg,
                                poliza.Poliza,
                                poliza.Certificado,
                                poliza.ProductoIdBHSeg,
                                poliza.Endoso,
                                client[0].CUIT__c,
                                currentUser.Active_Directory_Username__c
                            );
                        } else {
                            result = this.policyResender.resendDigitalPolicy(
                                poliza.RamoIdBHSeg,
                                poliza.Poliza,
                                poliza.Certificado,
                                poliza.ProductoIdBHSeg,
                                poliza.Endoso,
                                client[0].CUIT__c,
                                currentUser.Active_Directory_Username__c
                            );
                        }

                        if (result) {
                            message = 'Se programo el envio correctamente.'; // se podria agregar el nro de poliza afectada
                        } else {
                            message = 'Error al programar el envio.';
                        }

                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));

                        poliza.selected = false;
                    }
                }
            }
        }
    }

    public class PolizaWrapper {
        public String Name { get; set; }
        public String Estado { get; set; }
        public String Id { get; set; }
        public String Ramo { get; set; }
        public String Producto { get; set; }
        public boolean selected { get; set; }
        public Decimal Poliza { get; set; }
        public Decimal Certificado { get; set; }
        public Decimal Endoso { get; set; }
        public dateTime Desde { get; set; }
        public dateTime Hasta { get; set; }
        public String canal1 { get; set; }
        public String canal2 { get; set; }
        public String ProductoIdBHSEG { get; set; }
        public String RamoIdBHSEG { get; set; }
        public String medioDePago { get; set; }
        public String origenDePago { get; set; }
        public String cuentaDePago { get; set; }

        public String vigencia { get; set; } // Jira 1479

        public PolizaWrapper(Poliza__c polizaAux) {
            this.selected = false;
            this.Id = polizaAux.Id;
            this.Name = polizaAux.name;
            this.Producto = polizaAux.Producto__c;
            this.ProductoIdBHSEG = polizaAux.Producto_IdBHSeg__c;
            this.RamoIdBHSEG = polizaAux.Ramo_IdBHSeg__c;
            this.Ramo = polizaAux.Ramo__c;
            this.Poliza = polizaAux.Poliza__c;
            this.Certificado = polizaAux.Certificado__c;
            this.Endoso = polizaAux.Endoso__c;
            this.Desde = polizaAux.Desde__c;
            this.Hasta = polizaAux.Hasta__c;
            this.Estado = polizaAux.Estado__c;
            this.canal1 = polizaAux.Canal_1__c;
            this.canal2 = polizaAux.Canal_2__c;
            this.medioDePago = polizaAux.Medio_de_Pago__c;
            this.origenDePago = polizaAux.Origen_de_Pago__c;
            this.cuentaDePago = polizaAux.Cuenta_Pago__c;
            this.vigencia = GestionarPolizaControllerHelper.getStringValidity(polizaAux);
        }
    }

    public class NoRequestSelectedException extends Exception {
    }
}