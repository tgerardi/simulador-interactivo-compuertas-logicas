public class GestionarPolizaValidator {

	public static Boolean validateMotivoDeLlamadaCompleted(Task telephoneCall){
		return String.isNotBlank(telephoneCall.Motivo_de_llamado_BO__c) 
			&& telephoneCall.Motivo_de_llamado_BO__c != '--Ninguno--';
	}

    // Jira 1602
    public static Boolean validateMotivoDeBajaSelected(Gestion__c cancellationRequest){
        System.debug('validateMotivoDeBajaSelected()');
        System.debug(cancellationRequest.Motivo_Baja__c);
        return ! '--Ninguno--'.equalsIgnoreCase(cancellationRequest.Motivo_Baja__c) 
            && cancellationRequest.Motivo_Baja__c != null;
    }

    // Jira 1602
    public static Boolean validateResultadoSelected(Gestion__c cancellationRequest){
        System.debug('validateResultadoSelected()');
        System.debug(cancellationRequest.Resultado__c);
        return ! '--Ninguno--'.equalsIgnoreCase(cancellationRequest.Resultado__c) 
            && cancellationRequest.Resultado__c != null;
    }
}