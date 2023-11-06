public class AG_BaseController  {
    
    @AuraEnabled
    public static MainWrapper getInitBase(){
        
        MainWrapper mainWrapper = new MainWrapper();
        
        User currentLoginUser = [
            SELECT Id, Name, Username, AccountId 
            FROM User 
            WHERE Id = :UserInfo.getUserId()
        ];
        
        List<Account> currentPersonalAccountLoginUser = [
            SELECT Id, IdBHSeg__c, FirstName, LastName, Genero__c, PersonBirthdate, CUIT__c,
            Tipo_de_Documento__c, Numero_de_Documento__c, Estado_Civil__c, Id_Cliente_BHSeg__c,
            Phone, PersonHomePhone, PersonMobilePhone, PersonEmail, Email_Secundario__c, score__c,
            Fecha_ultima_verificacion__c, Cumulo__c
            FROM Account
            WHERE Id = :currentLoginUser.AccountId
        ];
        
        if(currentLoginUser!=null 
           && !currentPersonalAccountLoginUser.isEmpty()){
               mainWrapper.fullName = currentPersonalAccountLoginUser[0].FirstName+' '+currentPersonalAccountLoginUser[0].LastName;
               mainWrapper.userName = currentLoginUser.Username;
               mainWrapper.status = 'OK';
               mainWrapper.message = 'Los datos del cliente fueron sincronizados satisfactoriamente';
           }else{
               mainWrapper.status = 'NOK';
               mainWrapper.message = 'Los datos del cliente no fueron sincronizados';
           }
        
        return mainWrapper;
        
    }
    
    
    public class MainWrapper {
        @AuraEnabled public List<Poliza__c>  relatedAccountsProducts {get;set;}
        @AuraEnabled public String fullName {get;set;}
        @AuraEnabled public String userName {get;set;}
        @AuraEnabled public String idClienteBHSeg {get;set;}
        @AuraEnabled public String status {get;set;}
        @AuraEnabled public String message {get;set;}
        @AuraEnabled public String errorInfo {get;set;}
        @AuraEnabled public Boolean isEmpty {get; set;}
        
        public void MainWrapper(){
            isEmpty = false;
        }
    }
}