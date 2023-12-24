public class GestionarMegaservicioController {
    
    Public Gestion__c request {get;Set;}
    Public String accId {get;set;}
    Public boolean hasError {get;Set;}
    
    Public GestionarMegaservicioController(){
        setup();
    }
    
    //Aux Methods
    Public void save(){
        boolean dmlError = false;
        if(hasError){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El cliente no cumple las condiciones para generar una gestion de megaservicio.'));    	    
        }else{
            try{
                Insert request;
            }catch(Exception e){
                system.debug('Exception : ' + e.getMessage());
                dmlError = true;
            }
        	
            if(!dmlError){
            	String requestName = [SELECT Name FROM Gestion__c WHERE id = :request.id].Name;
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'La gestion de Megaservicio se ha generado satisfactoriamente. Puede acceder a la misma mediante el siguiente link: ' + '<a href="/' + request.id + '">' + requestName + '</a>'));    	    
        	}
            
        }
    }
    
    Public void setup(){
        hasError = false;
        accId = System.currentPageReference().getParameters().get('accId');
        system.debug('accId: ' + accId);
        if(String.isNotBlank(accId)){
            
            //check if some retention request matches the conditions
            boolean someRequestMatchTheConditions = false;
            List<Gestion__c> clientRetentionRequests = [SELECT Premio_Plan_Nuevo__c, Premio_Plan_Original__c
                                                        FROM Gestion__c
                                                       	WHERE Cuenta__c = :accId
                                                        AND RecordType.Name = 'Retencion'];
            
            for(Gestion__c clientRetentionRequest : clientRetentionRequests){
                if(clientRetentionRequest.Premio_Plan_Nuevo__c >= clientRetentionRequest.Premio_Plan_Original__c){
                	someRequestMatchTheConditions = true;
                    system.debug('Una gestión matcheo: ' + clientRetentionRequest);
                }
            }
            
            if(!someRequestMatchTheConditions){
            	system.debug('No se encontraron retenciones que matcheen las condiciones');   
            }
            
            //first we should retrieve all client policyes to check if some can request the megaservicio
            List<String> policiesRamoIdBHSeg = new List<String>();
            List<String> policiesProductoIdBHSeg = new List<String>();
            
            List<Poliza__c> clientPolicies = [SELECT Producto_IdBHSeg__c, Ramo_IdBHSeg__c
                                              FROM Poliza__c
                                              WHERE Cuenta__c = :accId
                                              AND Estado__c = 'VIGENTE'];
            
            if(!clientPolicies.isEmpty()){
                
                for(Poliza__c policy : clientPolicies){
                	policiesRamoIdBHSeg.add(policy.Ramo_IdBHSeg__c);
                    policiesProductoIdBHSeg.add(policy.Producto_IdBHSeg__c);
                }
                
                if(!policiesRamoIdBHSeg.isEmpty() && !policiesProductoIdBHSeg.isEmpty()){
                    
                    List<Servicios_Por_Producto__c> servicesForTheClient = [SELECT Name, Servicio__c, Id
                                                                    FROM Servicios_Por_Producto__c
                                                                    WHERE Producto__c IN :policiesProductoIdBHSeg
                                                                    AND Ramo__c IN :policiesRamoIdBHSeg
                                                                    AND Servicio__c = '11'];
                    
                    boolean theClientHaveNotAMegaServicioRequest = true;
                    List<Gestion__c> requestOfTheClient = [SELECT Id FROM Gestion__c WHERE RecordType.Name = 'Megaservicio' AND Cuenta__c = :accId];
                    if(requestOfTheClient.size() > 0){
                        theClientHaveNotAMegaServicioRequest = false;
                    }
                    
                    system.debug('servicesForTheClient: ' + servicesForTheClient);
                    system.debug('theClientHaveNotAMegaServicioRequest: ' + theClientHaveNotAMegaServicioRequest);
                    system.debug('someRequestMatchTheConditions: ' + someRequestMatchTheConditions);
                    
                    if(servicesForTheClient.isEmpty() || !theClientHaveNotAMegaServicioRequest || !someRequestMatchTheConditions){
                    	hasError = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El cliente no cumple las condiciones para generar una gestión de Megaservicio'));    
                    }else if(servicesForTheClient.size() > 0 && theClientHaveNotAMegaServicioRequest && someRequestMatchTheConditions){
                        
                        //PRE POPULATE SOME FIELDS
						List<Domicilio__c> clientAddress = [SELECT Calle__c, Numero__c, Piso__c, Depto__c, Codigo_Postal__c, Provincia__c
                                                FROM Domicilio__c
                                                WHERE Cuenta__c = :accId];                        
                        
                        request = new Gestion__c(RecordTypeId = [SELECT id FROM Recordtype WHERE Name = 'Megaservicio'].id);
        				request.Estado_Comunicacion_Rector__c = 'Para Enviar';
                        request.Cuenta__c = accId;
                        request.Fecha_Megaservicio__c = system.today();
                        
                        if(clientAddress.size() > 0){
                            request.Calle__c = clientAddress[0].Calle__c;
                            request.Piso__c = clientAddress[0].Piso__c;
                            request.Altura__c = String.valueOf(clientAddress[0].Numero__c);
                            request.Departamento__c = clientAddress[0].depto__c;
                            request.Codigo_Postal__c = clientAddress[0].Codigo_Postal__c;
                        }
                        
                    }
                    
                }
                
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El cliente no cumple las condiciones para generar una gestión de Megaservicio'));    
            }
            
        }
    }

}