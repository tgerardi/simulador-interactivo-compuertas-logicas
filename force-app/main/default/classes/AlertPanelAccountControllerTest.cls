@isTest
private class AlertPanelAccountControllerTest {

    @TestSetup
    private static void makeData() {
        // Bines para los tests del Jira EV-2024
        INSERT new List<Bin_Tarjeta__c> {
            new Bin_Tarjeta__c(
                Name = 'VISA-442014',
                Bandera__c = 'VISA',
                Bin__c = '442014',
                Marca__c = 'SIGNATURE',
                Tipo_de_Tarjeta__c = 'CR',
                Emisor__c = 'Banco Hipotecario'
            ),
            new Bin_Tarjeta__c(
                Name = 'VISA-442015',
                Bandera__c = 'VISA',
                Bin__c = '442015',
                Marca__c = 'PLATINUM',
                Tipo_de_Tarjeta__c = 'CR',
                Emisor__c = 'Banco Hipotecario'
            )
        };
    }

    @IsTest
    private static void ShouldDontBeCreateAnAlertWhenTheAccountDoesntHaveRNCCase() {
        // Setup (Given)
        Account client = Build.aClient().build();
        client.Fecha_ultima_verificacion__c = System.today();
        insert client;

        insert Build.anAlerta()
            .withTitulo('Cliente con casos de RNC')
            .withTipodeAlerta('Informacion')
            .withCuenta(client)
            .withEliminable(false)
            .build();

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);

        // Exercise (When)
        Test.startTest();
        controller.updateAlerts();
        Test.stopTest();

        // Test (Then)
        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id
                AND Titulo__c = :'Cliente con casos de RNC'
        ];

        System.assertEquals(0, alerts.size(), 'No tiene que haber alertas generadas');
    }

    @IsTest
    private static void ShouldBeCreateAnAlertWhenTheAccountHasRNCCase() {
        // Setup (Given)
        Account client = Build.aClient().build();
        insert client;

        Case theCase = Build.aCase().forClient(client).withSubject('Riesgo no cubierto').withStatus('Cerrado').build();
		insert theCase;

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);

        // Exercise (When)
        Test.startTest();
        controller.updateAlerts();
        Test.stopTest();

        // Test (Then)
        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id
                AND Titulo__c = :'Cliente con casos de RNC'
        ];

        System.assertEquals(1, alerts.size(), 'Tiene que haber alertas generadas');
    }

    @IsTest
    private static void EV1322_ifAlreadyExistTelemedicinaAlert_ButClientDontHasAnyTelemedicinaPolicy_TheAlertShouldBeDeleted() {
        // Setup (Given)
        Account client = Build.aClient().build();
        client.Fecha_ultima_verificacion__c = System.today();
        insert client;

        insert Build.anAlerta()
            .withTitulo('Cliente con Telemedicina')
            .withTipodeAlerta('Informacion')
            .withCuenta(client)
            .withEliminable(false)
            .withIdentificadorAdicional('Telemedicina-'+client.id_cliente_bhseg__c)
            .build();

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);

        // Exercise (When)
        Test.startTest();
        controller.updateAlerts();
        Test.stopTest();

        // Test (Then)
        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id
        ];
        System.assertEquals(0, alerts.size(), 'No tiene que haber alertas generadas');
    }


    @IsTest
    private static void EV1322_ifAlreadyExistTelemedicinaAlertAndBeneficiaryAlert_theseTypeOfAlertShouldNotGenerateNewOnes() {
        // Setup (Given)
        Account client = Build.aClient().build();
        client.Fecha_ultima_verificacion__c = System.today();
        insert client;

        Poliza__c policy = Build.aPolicy()
            .forClient(client)
            .withPremio(100)
            .withVigente(true)
            .withAsistencias('Telemedicina')
            .withAlertaDesignacionBeneficiarios(true)
            .build();

        insert policy;
        policy = [SELECT Name FROM Poliza__C WHERE id = :policy.id];

        insert new List<Alerta__c>{
            Build.anAlerta()
                .withTitulo('La Póliza ' + policy.Name + ' aún no tiene designación de beneficiarios')
                .withTipodeAlerta('Exclamacion')
                .withCuenta(client)
                .withEliminable(false)
                .withIdentificadorAdicional(policy.Name + '-' + 'NTDB')
                .build(),
            Build.anAlerta()
                .withTitulo('Cliente con Telemedicina')
                .withTipodeAlerta('Informacion')
                .withCuenta(client)
                .withEliminable(false)
                .withIdentificadorAdicional('Telemedicina-'+client.id_cliente_bhseg__c)
                .build()
        };

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);

        // Exercise (When)
        Test.startTest();
        controller.updateAlerts();
        Test.stopTest();

        // Test (Then)
        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id
        ];
        System.assertEquals(2, alerts.size(), 'Solo tienen que haber las 2 alertas que se generaron en un principio');
    }

    @IsTest
    private static void EV1322_ifTheClientHasAPoliciesWithTelemedicinaAssistance_canOnylyGenerateOneAlert() {
        // Setup (Given)
        Account client = Build.aClient().build();
        client.Fecha_ultima_verificacion__c = System.today();
        insert client;

        insert new List<SObject>{
            Build.aPolicy().forClient(client).withPremio(100).withVigente(true).withAsistencias('Telemedicina').build(),
            Build.aPolicy()
                .forClient(client)
                .withTradeNumber('99')
                .withPremio(100)
                .withVigente(true)
                .withAsistencias('Telemedicina')
                .withCertificadoIdBhseg('1|1|Test')
                .withIdBhseg('1|1|Test')
                .build()
        };

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);

        // Exercise (When)
        Test.startTest();
        controller.updateAlerts();
        Test.stopTest();

        // Test (Then)
        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c, Identificador_Adicional__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id
        ];

        System.assertEquals(1, alerts.size(), 'Solo tiene que haber una alerta');
        System.assertEquals('Telemedicina-'+client.id_cliente_bhseg__c, alerts[0].Identificador_Adicional__c, 'Solo tiene que haber una alerta');
    }

    @IsTest
    private static void ifTheClientHavetheCMDPAlert_butNowTheCMDPRecordHaveARequestAssigned_theAlertShouldBeReplacedWithANewOneWithFinalizadaInTheTitle() {
        Account client = Build.aClient().build();
        client.Fecha_ultima_verificacion__c = System.today();
        insert client;

        Poliza__c policy = Build.aPolicy().forClient(client).build();
        policy.Premio__c = 100;
        policy.Vigente__c = true;
        policy.Alerta_Designacion_de_Beneficiarios__c = true;
        insert policy;

        Origen_de_Pago__c op = new Origen_de_Pago__c();
        op.Name = 'VISAop';
        op.Codigo__c = '05';
        op.Descripcion__c = 'VISA';
        insert op;

        Medio_de_Pago__c mp = new Medio_de_Pago__c();
        mp.name = '2';
        mp.Descripcion__c = 'TARJETA DE CREDITO';
        insert mp;

        Gestion__c gestion = Build.aRequest('Cambio_Medio_Pago').forClient(client).forPolicy(policy).build();
        gestion.Estado_Comunicacion_Rector__c = 'Enviada';
        insert gestion;

        CMDP_Prestamo__c cmdp = new CMDP_Prestamo__c();
        cmdp.apellido__c = client.LastName;
        cmdp.certificado__c = policy.Certificado__c;
        cmdp.email__c = client.PersonEmail;
        cmdp.endoso__c = policy.Endoso__c;
        cmdp.id_cliente_bhseg__c = client.Id_Cliente_BHSeg__c;
        cmdp.nombre__c = client.FirstName;
        cmdp.poliza__c = policy.Poliza__c;
        cmdp.premio_actual__c = 10;
        cmdp.premio_con_descuento__c = 8;
        cmdp.producto__c = policy.Producto_IdBHSeg__c;
        cmdp.ramo__c = policy.Ramo_IdBHSeg__c;
        cmdp.vencimiento_MDP__c = System.today();
        cmdp.vigencia_desde__c = System.today();
        cmdp.vigencia_hasta__c = System.today();
        cmdp.token__c = '4398728045218854';
        cmdp.Origen_de_Pago__c = 'VISA';
        cmdp.Gestion__c = gestion.Id;
        insert cmdp;

        Alerta__c alert = new Alerta__c();
        alert.Titulo__c = 'Participa de la campaña CMDP(Prestamos a Vencer) - (En Curso)';
        alert.Contenido__c = '';
        alert.Tipo_de_Alerta__c = 'Comentario';
        alert.Cuenta__c = client.Id;
        alert.Eliminable__c = false;
        insert alert;

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);

        Test.startTest();
        controller.updateAlerts();
        Test.stopTest();

        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c
            FROM Alerta__c
            WHERE
                Cuenta__c = :client.Id
                AND Titulo__c = 'Participa de la campaña CMDP(Prestamos a Vencer) - (Finalizada)'
        ];
        List<Alerta__c> alertsBene = [
            SELECT Id, Titulo__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id AND Identificador_Adicional__c LIKE '%NTDB'
        ];

        system.assertEquals(1, alerts.size());
        system.assertEquals(1, alertsBene.size());
    }

    @IsTest
    private static void ifTheClientAppearINACMDPRecord_andHaveTheRequestFieldPopulated_anAlertShouldBeInsertedWithFinalizada() {
        Account client = Build.aClient().build();
        client.Fecha_ultima_verificacion__c = System.today();
        insert client;

        Poliza__c policy = Build.aPolicy().forClient(client).build();
        policy.Premio__c = 100;
        insert policy;

        Origen_de_Pago__c op = new Origen_de_Pago__c();
        op.Name = 'VISAop';
        op.Codigo__c = '05';
        op.Descripcion__c = 'VISA';
        insert op;

        Medio_de_Pago__c mp = new Medio_de_Pago__c();
        mp.name = '2';
        mp.Descripcion__c = 'TARJETA DE CREDITO';
        insert mp;

        Gestion__c gestion = Build.aRequest('Cambio_Medio_Pago').forClient(client).forPolicy(policy).build();
        gestion.Estado_Comunicacion_Rector__c = 'Enviada';
        insert gestion;

        CMDP_Prestamo__c cmdp = new CMDP_Prestamo__c();
        cmdp.apellido__c = client.LastName;
        cmdp.certificado__c = policy.Certificado__c;
        cmdp.email__c = client.PersonEmail;
        cmdp.endoso__c = policy.Endoso__c;
        cmdp.id_cliente_bhseg__c = client.Id_Cliente_BHSeg__c;
        cmdp.nombre__c = client.FirstName;
        cmdp.poliza__c = policy.Poliza__c;
        cmdp.premio_actual__c = 10;
        cmdp.premio_con_descuento__c = 8;
        cmdp.producto__c = policy.Producto_IdBHSeg__c;
        cmdp.ramo__c = policy.Ramo_IdBHSeg__c;
        cmdp.vencimiento_MDP__c = System.today();
        cmdp.vigencia_desde__c = System.today();
        cmdp.vigencia_hasta__c = System.today();
        cmdp.token__c = '4398728045218854';
        cmdp.Origen_de_Pago__c = 'VISA';
        cmdp.Gestion__c = gestion.Id;
        insert cmdp;

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);

        Test.startTest();
        controller.updateAlerts();
        Test.stopTest();

        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id
        ];

        system.assertEquals(1, alerts.size());
        system.assertEquals('Participa de la campaña CMDP(Prestamos a Vencer) - (Finalizada)', alerts[0].Titulo__c);
    }

    @IsTest
    private static void ifTheClientAppearInACMDPRecord_anAlertShouldBeInserted() {
        Account client = Build.aClient().build();
        client.Fecha_ultima_verificacion__c = System.today();
        insert client;

        Poliza__c policy = Build.aPolicy().forClient(client).build();
        policy.Premio__c = 100;
        insert policy;

        Origen_de_Pago__c op = new Origen_de_Pago__c();
        op.Name = 'VISAop';
        op.Codigo__c = '05';
        op.Descripcion__c = 'VISA';
        insert op;

        Medio_de_Pago__c mp = new Medio_de_Pago__c();
        mp.name = '2';
        mp.Descripcion__c = 'TARJETA DE CREDITO';
        insert mp;

        CMDP_Prestamo__c cmdp = new CMDP_Prestamo__c();
        cmdp.apellido__c = client.LastName;
        cmdp.certificado__c = policy.Certificado__c;
        cmdp.email__c = client.PersonEmail;
        cmdp.endoso__c = policy.Endoso__c;
        cmdp.envio__c = 'PARA ENVIAR';
        cmdp.id_cliente_bhseg__c = client.Id_Cliente_BHSeg__c;
        cmdp.nombre__c = client.FirstName;
        cmdp.poliza__c = policy.Poliza__c;
        cmdp.premio_actual__c = 10;
        cmdp.premio_con_descuento__c = 8;
        cmdp.producto__c = policy.Producto_IdBHSeg__c;
        cmdp.ramo__c = policy.Ramo_IdBHSeg__c;
        cmdp.vencimiento_MDP__c = System.today();
        cmdp.vigencia_desde__c = System.today();
        cmdp.vigencia_hasta__c = System.today();
        cmdp.token__c = '4398728045218854';
        cmdp.Estado_Gestion__c = 'Para Enviar';
        cmdp.Origen_de_Pago__c = 'VISA';
        insert cmdp;

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);

        Test.startTest();
        controller.updateAlerts();
        Test.stopTest();

        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id
        ];

        system.assertEquals(1, alerts.size());
        system.assertEquals('Participa de la campaña CMDP(Prestamos a Vencer) - (En Curso)', alerts[0].Titulo__c);
    }

    @IsTest
    private static void newAlertIsCreatedIfLastVerifiedTimeIsGreaterThan30Days() {
        Account client = Build.aClient().withVerifiedDate(Date.today().addDays(-30)).build();
        insert client;

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);
        controller.updateAlerts();

        List<Alerta__c> alerts = [SELECT Id, Titulo__c FROM Alerta__c WHERE Cuenta__c = :client.Id];

        system.assertEquals(1, alerts.size());
        system.assertEquals('Debe verificar datos de contacto', alerts[0].Titulo__c);
    }

    @IsTest
    private static void newAlertIsCreatedIfLastVerifiedTimeIsNotSpecified() {
        Account client = Build.aClient().build();
        insert client;

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);
        controller.updateAlerts();

        List<Alerta__c> alerts = [SELECT Id, Titulo__c FROM Alerta__c WHERE Cuenta__c = :client.Id];

        system.assertEquals(1, alerts.size());
        system.assertEquals('Debe verificar datos de contacto', alerts[0].Titulo__c);
    }

    @IsTest
    private static void noNewAlertIsCreatedIfAlertAlreadyExists() {
        Account client = Build.aClient().build();
        insert client;

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);
        controller.updateAlerts();

        List<Alerta__c> alerts = [SELECT Id, Titulo__c FROM Alerta__c WHERE Cuenta__c = :client.Id];

        system.assertEquals(1, alerts.size());

        controller.updateAlerts();

        alerts = [SELECT Id, Titulo__c FROM Alerta__c WHERE Cuenta__c = :client.Id];

        system.assertEquals(1, alerts.size());
    }

    @IsTest
    private static void alertIsDeletedIfLastVerifiedTimeIsLessThan30Days() {
        Account client = Build.aClient().withVerifiedDate(Date.today().addDays(-31)).build();
        insert client;

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);
        controller.updateAlerts();

        List<Alerta__c> alerts = [SELECT Id FROM Alerta__c WHERE Cuenta__c = :client.Id];

        system.assertEquals(1, alerts.size());

        client.Fecha_ultima_verificacion__c = Date.today().addDays(-29);
        upsert client;

        stdController = new ApexPages.StandardController(client);
        controller = new AlertPanelAccountController(stdController);
        controller.updateAlerts();

        alerts = [SELECT Id FROM Alerta__c WHERE Cuenta__c = :client.Id];

        system.assertEquals(0, alerts.size());
    }

    @IsTest
    private static void controllerShowsAllAlertsForClient() {
        Account client = Build.aClient().withVerifiedDate(Date.today().addDays(-30)).build();
        insert client;

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);
        controller.updateAlerts();

        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id
        ];

        system.assertEquals(alerts.size(), controller.alerts.size());
    }

    @IsTest
    private static void alertsCanBeDeleted() {
        Account client = Build.aClient().withVerifiedDate(Date.today().addDays(-30)).build();
        insert client;

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);
        controller.updateAlerts();

        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id
        ];

        system.assertEquals(1, alerts.size());

        Apexpages.currentPage().getParameters().put('alertId', alerts[0].Id);
        controller.deleteAlert();

        alerts = [
            SELECT Id, Titulo__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id
        ];

        system.assertEquals(0, alerts.size());
    }

    @IsTest
    private static void generateAlertForAClientWithTCVisaBHInAPolicy() {
        String identiTCVisaBH = 'PoseeTCVisaBH-%';
        Account client = Build.aClient().build();
        INSERT client;

        Poliza__c policy = Build.aPolicy()
            .forClient(client)
            .withPremio(10000)
            .withVigente(true)
            .withMedioDePago('TARJETA DE CREDITO')
            .withOrigenDePago('VISA')
            .withCuentaPago('4420150000000001')
            .build();
        INSERT policy;

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);
        
        // Exercise (When)
        Test.startTest();
        controller.updateAlerts();
        Test.stopTest();

        // Test (Then)
        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c, Identificador_Adicional__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id
                AND Identificador_Adicional__c LIKE :identiTCVisaBH
        ];
        System.assertEquals(1, alerts.size(), 'Se debe crear la alerta');
        System.assertEquals('Cliente con TC Visa Signature/Platinum del BH', alerts[0].Titulo__c);
    }

    @IsTest
    private static void mantainTCVisaBHAlertIfTheClientAlreadyHasOne() {
        String identiTCVisaBH = 'PoseeTCVisaBH-%';
        Account client = Build.aClient().build();
        INSERT client;

        Poliza__c policy = Build.aPolicy()
            .forClient(client)
            .withPremio(100)
            .withVigente(true)
            .withMedioDePago('TARJETA DE CREDITO')
            .withOrigenDePago('VISA')
            .withCuentaPago('4420150000000001')
            .build();
        INSERT policy;
        
        policy = [SELECT Name FROM Poliza__C WHERE Id = :policy.Id];

        Alerta__c alerta = Build.anAlerta()
            .withTitulo('Cliente con TC Visa Signature/Platinum del BH')
            .withTipodeAlerta('Exclamacion')
            .withCuenta(client)
            .withEliminable(false)
            .withIdentificadorAdicional('PoseeTCVisaBH-'+client.Id_Cliente_BHSeg__c)
            .build();
        INSERT alerta;

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);

        // Exercise (When)
        Test.startTest();
        controller.updateAlerts();
        Test.stopTest();

        // Test (Then)
        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id AND 
                Identificador_Adicional__c LIKE :identiTCVisaBH
        ];
        System.assertEquals(1, alerts.size(), 'Se debe mantener la alerta');
    }

    @IsTest
    private static void alertTCVisaBHIsDeletedOnPaymentMethodChangeOfAPolicy() {
        String identiTCVisaBH = 'PoseeTCVisaBH-%';
        Account client = Build.aClient().build();
        INSERT client;

        Poliza__c policy = Build.aPolicy()
            .forClient(client)
            .withPremio(100)
            .withVigente(true)
            .withMedioDePago('TARJETA DE CREDITO')
            .withOrigenDePago('VISA')
            .withCuentaPago('4420150000000001')
            .build();

        INSERT policy;
        policy = [SELECT Name, Cuenta_Pago__c FROM Poliza__c WHERE id = :policy.Id];

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);
        controller.updateAlerts();

        List<Alerta__c> alerts = [SELECT Id FROM Alerta__c WHERE Cuenta__c = :client.Id AND  Identificador_Adicional__c LIKE :identiTCVisaBH];
        System.assertEquals(1, alerts.size(), 'Se debe crear la alerta');

        policy.Cuenta_Pago__c = '1111110000000000';
        UPSERT policy;

        stdController = new ApexPages.StandardController(client);
        controller = new AlertPanelAccountController(stdController);
        controller.updateAlerts();

        alerts = [
            SELECT Id 
            FROM Alerta__c 
            WHERE Cuenta__c = :client.Id AND 
                Identificador_Adicional__c LIKE :identiTCVisaBH];

        System.assertEquals(0, alerts.size(), 'Se debe eliminar la alerta');
    }

    @IsTest
    private static void generateAlertForAClientWithOsutiPolicy() {
        String identiOsuti = 'PolizaOsuti-%';
        Account client = Build.aClient().build();
        INSERT client;

        Poliza__c policy = Build.aPolicy()
            .forClient(client)
            .withPremio(10000)
            .withVigente(true)
            .withProductorIdBhSeg('606')
            .withTradeNumber('19')
            .withProductoIdBHSeg('272')
            .build();
        INSERT policy;

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);
        
        // Exercise (When)
        Test.startTest();
        controller.updateAlerts();
        Test.stopTest();

        // Test (Then)
        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c, Identificador_Adicional__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id
                AND Identificador_Adicional__c LIKE :identiOsuti
        ];
        System.assertEquals(1, alerts.size(), 'Se debe crear la alerta');
    }

    @IsTest
    private static void keepAlertForAClientThatAlreadyHasOsutiPolicy() {
        String identiOsuti = 'PolizaOsuti-%';
        Account client = Build.aClient().build();
        INSERT client;

        Poliza__c policy = Build.aPolicy()
            .forClient(client)
            .withPremio(10000)
            .withVigente(true)
            .withProductorIdBhSeg('606')
            .withTradeNumber('19')
            .withProductoIdBHSeg('272')
            .build();
        INSERT policy;

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);
        
        // Exercise (When)
        Test.startTest();
        controller.updateAlerts();
        
        stdController = new ApexPages.StandardController(client);
        controller = new AlertPanelAccountController(stdController);
        

        controller.updateAlerts();
        Test.stopTest();
        
        // Test (Then)
        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c, Identificador_Adicional__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id
                AND Identificador_Adicional__c LIKE :identiOsuti
        ];
        System.assertEquals(1, alerts.size(), 'Se debe crear la alerta');
    }

    @IsTest
    private static void generateAlertForAClientWithCurrentIBBrokerPolicy() {
        Account client = Build.aClient().build();
        INSERT client;
        
        Poliza__c policy = Build.aPolicy()
        .forClient(client)
        .withPremio(10)
        .withStatus('VIGENTE')
        .withProductorIdBhSeg('602')
        .withTradeNumber('9')
        .withProductoIdBHSeg('255')
        .build();
        INSERT policy;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);
        
        // Exercise (When)
        Test.startTest();
        controller.updateAlerts();
        Test.stopTest();
        
        // Test (Then)
        String identiIBBroker = 'PolizaIBBroker-'+client.Id_Cliente_BHSeg__c;
        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c, Identificador_Adicional__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id
                AND Identificador_Adicional__c LIKE :identiIBBroker
        ];
        System.assertEquals(1, alerts.size(), 'Se debe crear la alerta');
    }

    @IsTest
    private static void generateAlertForAClientWithExpiredIBBrokerPolicy() {
        Account client = Build.aClient().build();
        INSERT client;

        Poliza__c policy = Build.aPolicy()
            .forClient(client)
            .withPremio(10)
            .withStatus('VENCIDO')
            .withProductorIdBhSeg('602')
            .withTradeNumber('9')
            .withProductoIdBHSeg('255')
            .build();
        INSERT policy;

        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);
        
        // Exercise (When)
        Test.startTest();
        controller.updateAlerts();
        Test.stopTest();

        // Test (Then)
        String identiIBBroker = 'PolizaIBBroker-'+client.Id_Cliente_BHSeg__c;
        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c, Identificador_Adicional__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id
                AND Identificador_Adicional__c LIKE :identiIBBroker
        ];
        System.assertEquals(0, alerts.size(), 'Se debe borrar la alerta.');
    }

    @IsTest
    private static void keepAlertForAClientThatAlreadyHasIBBrokerPolicy() {
        Account client = Build.aClient().build();
        INSERT client;
        
        Poliza__c policy = Build.aPolicy()
        .forClient(client)
        .withPremio(10)
        .withStatus('VIGENTE')
        .withProductorIdBhSeg('602')
        .withTradeNumber('9')
        .withProductoIdBHSeg('255')
        .build();
        INSERT policy;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(client);
        AlertPanelAccountController controller = new AlertPanelAccountController(stdController);
        
        // Exercise (When)
        Test.startTest();
        controller.updateAlerts();
        
        stdController = new ApexPages.StandardController(client);
        controller = new AlertPanelAccountController(stdController);
        
        
        controller.updateAlerts();
        Test.stopTest();
        
        // Test (Then)
        String identiIBBroker = 'PolizaIBBroker-'+client.Id_Cliente_BHSeg__c;
        List<Alerta__c> alerts = [
            SELECT Id, Titulo__c, Identificador_Adicional__c
            FROM Alerta__c
            WHERE Cuenta__c = :client.Id
                AND Identificador_Adicional__c LIKE :identiIBBroker
        ];
        System.assertEquals(1, alerts.size(), 'Se debe crear la alerta');
    }
}