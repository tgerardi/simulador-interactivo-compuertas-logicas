public class GestionHelper {
    /**
     * Metodo que actualiza el codigo de ramo y producto en la gestion, basandose en la
     * poliza asociada que posee la misma.
     **/
    public static void associateProductDataToRequest(List<Gestion__c> requests, List<String> policiesIds) {
        Map<Id, Poliza__c> policies = new Map<Id, Poliza__c>(
            [SELECT Id, Ramo_IdBHSeg__c, Producto_IdBHSeg__c FROM Poliza__c WHERE Id IN :policiesIds]
        );

        for (Gestion__c request : requests) {
            if (request.Poliza__c != null) {
                if (String.isBlank(request.Ramo_IdBHSeg__c)) {
                    request.Ramo_IdBHSeg__c = policies.get(request.Poliza__c).Ramo_IdBHSeg__c;
                }
                if (String.isBlank(request.Producto_IdBHSeg__c)) {
                    request.Producto_IdBHSeg__c = policies.get(request.Poliza__c).Producto_IdBHSeg__c;
                }
            }
        }
    }

    /* Recibe un mapa Key: numero de gestion rector, Value: gestion e intenta asociarle el caso 
       correspondiente al objeto de reenvio de poliza que posee el mismo numero. 
       NO CHEQUEA SI YA TIENE CASO ASOCIADO
       ¡Este metodo trabaja por referencia! No retorna nada*/
    public static void associateGestionToCaseThroughtReenvio(Map<String, Gestion__c> requestByNumber) {
        System.debug('associateGestionToCaseThroughtReenvio()');

        List<Reenvio_de_Poliza__c> reenviosDePoliza = [
            SELECT Id, Numero__c, Caso__c
            FROM Reenvio_de_Poliza__c
            WHERE Numero__c IN :requestByNumber.keySet()
        ];

        Gestion__c requestToAssociate;
        for (Reenvio_de_Poliza__c eachReenvio : reenviosDePoliza) {
            requestToAssociate = requestByNumber.get(eachReenvio.Numero__c);
            requestToAssociate.Caso__c = eachReenvio.Caso__c;

            requestToAssociate = null;
        }
    }

    //START CNLS-439 -----------------------------------------------------------------------
    public static Map<String, String> mapPaymentMethodsByDesc() {
        Map<String, String> mediosDePagoByDesc = new Map<String, String>();

        for (Medio_de_Pago__c mdp : Medio_de_Pago__c.getall().values()) {
            mediosDePagoByDesc.put(mdp.Descripcion__c, mdp.Name);
        }

        return mediosDePagoByDesc;
    }

    public static void fillChannel1(List<Gestion__c> newRequest) {
        Id cmdpRT = [SELECT Id FROM RecordType WHERE Name = 'Cambio Medio Pago'].Id;
        Map<Id, Gestion__c> requestByPolicyId = new Map<Id, Gestion__c>();
        for (Gestion__c request : newRequest) {
            if (request.RecordTypeId == cmdpRT) {
                requestByPolicyId.put(request.Poliza__c, request);
            }
        }

        for (Poliza__c poliza : [
            SELECT Id, Canal_1_IdBHSeg__c
            FROM Poliza__c
            WHERE Id IN :requestByPolicyId.keySet()
        ]) {
            requestByPolicyId.get(poliza.Id).Canal_1_IdBHSeg__c = poliza.Canal_1_IdBHSeg__c;
        }
    }

    public static Map<String, List<String>> mapRestrictedPaymentMethodsByChannel() {
        Map<String, List<String>> restrictedPaymentMethodsByChannel = new Map<String, List<String>>();

        for (Canal1__c canal : Canal1__c.getall().values()) {
            if (canal.Medios_de_Pago_Restringidos__c == null)
                continue;
            restrictedPaymentMethodsByChannel.put(canal.Name, canal.Medios_de_Pago_Restringidos__c.split('\\|'));
        }

        return restrictedPaymentMethodsByChannel;
    }

    public static Boolean paymentMethodIsNotAdmitedByChannel(
        Gestion__c request,
        Map<String, String> mediosDePagoByDesc,
        Map<String, List<String>> restrictedPaymentMethodsByChannel
    ) {
        return (restrictedPaymentMethodsByChannel.containsKey(request.Canal_1_IdBHSeg__c) &&
        restrictedPaymentMethodsByChannel.get(request.Canal_1_IdBHSeg__c)
            .contains(mediosDePagoByDesc.get(request.Medio_de_Pago__c)));
    }
    //END CNLS-439 -----------------------------------------------------------------------

    public static Boolean isAResendPolicyRequestWithRecordType(Gestion__c aRequest, Id recordTypeId) {
        System.debug('isAResendPolicyRequestWithRecordType()');

        String observacionEnvioFisico = 'El cliente solicita en envio de la Póliza Fisica.';
        String observacionEnvioElectronico = 'El cliente solicita en envio de la Póliza Electronica.';

        return aRequest.Numero__c > 0 &&
            aRequest.RecordTypeId == recordTypeId &&
            aRequest.Caso__c == null &&
            aRequest.Tramite__c == 'CONSULTA' &&
            (observacionEnvioElectronico == aRequest.Observaciones__c ||
            observacionEnvioFisico == aRequest.Observaciones__c);
    }

    public static Boolean hasConfirmedCancellationRequestForPolicy(String polizaId) {
        return (Integer) ([
                    SELECT Count(Id) requests
                    FROM Gestion__C
                    WHERE
                        Poliza__c = :polizaId
                        AND (RecordType.DeveloperName = 'Baja'
                        OR Tipo_de_gestion__c = 'Baja'
                        OR Tramite__c = 'BAJA')
                        AND Estado__C IN ('', 'PENDIENTE', 'FINALIZADO', 'DERIVADO')
                        AND Detalle_endoso__c IN ('', 'ACEPTADO')
                ][0]
                .get('requests')) > 0;
    }
}