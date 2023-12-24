@isTest
public class GestionarMegaservicioControllerTest {
    
    static testmethod void theControllerShouldPrePopulateSomeRequestFieldsWithClientAddressInfo(){
        
        Account client = Build.aClient().build();
        insert client;
        
        Domicilio__c address = new Domicilio__c(
        	Cuenta__c = client.id,
            Calle__c = 'Calle Prueba',
            Numero__c = 1,
            Depto__c = '2',
            Piso__c = '3',
            Codigo_postal__c = '1111'
        );
        Insert address;
        
        Poliza__c policy = Build.aPolicy().forClient(client).build();
        Insert policy;
        
        Servicios_Por_Producto__c customSetting = new Servicios_Por_Producto__c();
        customSetting.Name = 'CS';
        customSetting.Producto__c = policy.Producto_IdBHSeg__c;
        customSetting.Ramo__c = policy.Ramo_IdBHSeg__c;
        customSetting.Servicio__c = '11';
        Insert customSetting;
        
        Gestion__c request = Build.aRequest('Retencion').forPolicy(policy).build();
        request.Premio_Plan_Nuevo__c = 100;
        request.Premio_Plan_Original__c = 90;
        request.Estado_Comunicacion_Rector__c = 'Enviada';
        Insert request;
        
        Localidad_Provincia__c localidadYProvincia = new Localidad_Provincia__c();
        Insert localidadYProvincia;
        
        String url = '/apex/GestionarMegaservicio';
        Test.setCurrentPageReference(new PageReference(url));
        system.currentPageReference().getParameters().put('accId',client.id);
        
        Test.startTest();
        GestionarMegaservicioController controller = new GestionarMegaservicioController();
        Test.stopTest();
        
        system.assertEquals(controller.request.Calle__c, address.calle__c);
        system.assertEquals(controller.request.Piso__c, address.Piso__c);
        system.assertEquals(controller.request.Altura__c, String.valueOf(address.Numero__c));
        system.assertEquals(controller.request.Departamento__c, address.Depto__c);
        system.assertEquals(controller.request.Codigo_postal__c, address.Codigo_postal__c);
    }
	
    static testmethod void ifTheClientDoNotCompleteTheRequestRequeriments_throwAMsg(){
        
        Account client = Build.aClient().build();
        insert client;
        
        String url = '/apex/GestionarMegaservicio';
        Test.setCurrentPageReference(new PageReference(url));
        system.currentPageReference().getParameters().put('accId',client.id);
        
        Test.startTest();
        GestionarMegaservicioController controller = new GestionarMegaservicioController();
        Test.stopTest();
        
        List<ApexPages.Message> errorMsg = ApexPages.getMessages();
        system.assert(!errorMsg.isEmpty());
        ApexPages.Message theError = errorMsg[0];
        system.assert(theError.getDetail().contains('no cumple las condiciones'));
    }
    
    static testmethod void ifTheClientCompleteTheRequestRequeriments_canCreateAMegaservicioRequest(){
        
        SendRequestToRectorMock mock = Build.aSendRequestToRectorMock().withResult(true).build();    	
        Test.setMock(HttpCalloutMock.class, mock); 
        
        Account client = Build.aClient().build();
        insert client;
        
        Poliza__c policy = Build.aPolicy().forClient(client).build();
        Insert policy;
        
        Servicios_Por_Producto__c customSetting = new Servicios_Por_Producto__c();
        customSetting.Name = 'CS';
        customSetting.Producto__c = policy.Producto_IdBHSeg__c;
        customSetting.Ramo__c = policy.Ramo_IdBHSeg__c;
        customSetting.Servicio__c = '11';
        Insert customSetting;
        
        Gestion__c request = Build.aRequest('Retencion').forPolicy(policy).build();
        request.Premio_Plan_Nuevo__c = 100;
        request.Premio_Plan_Original__c = 90;
        request.Estado_Comunicacion_Rector__c = 'Enviada';
        Insert request;
        
        Localidad_Provincia__c localidadYProvincia = new Localidad_Provincia__c();
        Insert localidadYProvincia;
        
        String url = '/apex/GestionarMegaservicio';
        Test.setCurrentPageReference(new PageReference(url));
        system.currentPageReference().getParameters().put('accId',client.id);
        
        Test.startTest();
        GestionarMegaservicioController controller = new GestionarMegaservicioController();
        
        List<ApexPages.Message> errorMsg = ApexPages.getMessages();
        system.assert(errorMsg.isEmpty());
        
        controller.request.Fecha_Megaservicio__c = system.today();
        controller.request.Calle__c = 'Calle Prueba';
        controller.request.Piso__c = '1';
        controller.request.Altura__c = '2000';
        controller.request.Departamento__c = '1';
        controller.request.Codigo_Postal__c = '1222';
        controller.request.Localidad_y_Provincia__c = localidadYProvincia.id;
        
        controller.save();
        
        Test.stopTest();
        
        List<Gestion__c> megaservicioRequestForTheClient = [SELECT Id FROM Gestion__c WHERE RecordType.Name = 'Megaservicio' AND Cuenta__c = :client.id];
        //system.assertEquals(megaservicioRequestForTheClient.size(),1);
    }
    
}