public without sharing class GestionarPolizaControllerHelper {

	//Jira 1643
	public static void insertCameraChildCase(Case parentCase) {
		System.debug('insertCameraChildCase()');

		Case childCase = parentCase.clone();
		childCase.ParentId = parentCase.Id;
		childCase.Caso_Asociado__c = parentCase.Id;
		
		childCase.Status = 'Derivado';
		childCase.Derivado_a__c = 'BACK OFFICE';
		childCase.Subject = 'CONTROL DEVOLUCION CAMARA HP';

		childCase.Camara__c = getCamara(childCase.accountid);

		insert childCase;

	}

	public static Id getCamara(Id accid) {
		System.debug('getCamara()');
        Account acc = [SELECT Id, CUIT__c FROM Account WHERE id = :accid];
        String prefijo = acc.CUIT__c.substring(0,2);
        String numero = acc.CUIT__c.substring(2,10);
        String verificador = acc.CUIT__c.substring(10,11);
		try {
			Producto_Vendido__c clientSoldProduct = [
                SELECT Numero_de_Serie_Camara__c
			    FROM Producto_Vendido__c
			    WHERE Numero_de_Serie_Camara__c != null
                    AND (Cuenta__c = :accid
                        OR (Venta__r.CUIL_CUIT_Digito_Verificador__c = :verificador
	                        AND Venta__r.CUIL_CUIT_Numero__c = :numero
	                        AND Venta__r.CUIL_CUIT_Prefijo__c = :prefijo
                        ))
                ORDER BY CreatedDate DESC
			    LIMIT 1];
			System.debug('clientSoldProduct.Numero_de_Serie_Camara__c: ' + clientSoldProduct.Numero_de_Serie_Camara__c);

			return[SELECT ID
			FROM Camara__c
			WHERE Codigo_de_Serie__c = : clientSoldProduct.Numero_de_Serie_Camara__c].Id;
		} catch(Exception e) {
			System.debug('exception: ' + e.getMessage());
			throw e;
		}

	}

	//Jira 1607
	public static void assignPremioValues(List<Gestion__c> reqs) {
		System.debug('assignPremioValues()');
		try {
			Id RTId = Schema.SObjectType.Gestion__c.getRecordTypeInfosByName().get('Rechaza Transformacion').getRecordTypeId();
			//Id RIId = Schema.SObjectType.Gestion__c.getRecordTypeInfosByName().get('Reintegro_Extraordinario').getRecordTypeId();

			List<Id> policyIds = new List<Id> ();
			for (Gestion__c req : reqs) {
				if (req.RecordTypeId == RTId) {
					policyIds.add(req.Poliza__c);
				}
			}

			if (!policyIds.isEmpty()) {
				List<Poliza__c> requestPolicies = [SELECT Id, Premio__c
				                                   FROM Poliza__c
				                                   WHERE Id IN :policyIds];

				if (!requestPolicies.isEmpty()) {
					for (Gestion__c req : reqs) {
						for (Poliza__c requestPolicy : requestPolicies) {
							if (req.Poliza__c == requestPolicy.Id) {
								req.Premio_Plan_Nuevo__c = requestPolicy.Premio__c;
								req.Premio_Plan_Original__c = requestPolicy.Premio__c;
							}
						}
					}
				}
			}

		} catch(Exception e) {
			System.debug(e.getMessage());
		}

	}

	// Jira 1602
	public static Boolean validateMotivoDeBajaAndResultado(Gestion__c gestionBaja) {
		Boolean valid = true;
		if (!GestionarPolizaValidator.validateMotivoDeBajaSelected(gestionBaja)) {
			createApexPagesMessageTypeError('Seleccione un motivo de baja para continuar.');
			valid = false;
		}

		if (!GestionarPolizaValidator.validateResultadoSelected(gestionBaja)) {
			createApexPagesMessageTypeError('Seleccione un resultado para continuar.');
			valid = false;
		}

		return valid;
	}

	public static void deleteRecord(String recordId, String objectType) {
		if (objectType == 'case') {
			delete[select id from Case where id = : recordId];
		}

		if (objectType == 'task') {
			delete[select id from Task where id = : recordId];
		}
	}

	public static void deleteCases(List<Case> casesToDelete) { // Jira 1479
		delete casesToDelete;
	}

	/**
	 * @description Valida si una gestion de Baja para una poliza Sapienza esta correcta para guardarse. En Caso que no lo sea levanta un ApexPages.Message del tipo error.
	 *			   Es Valida si alguno de los campos para el medio de pago no esta completo.
	 * @param bajaRequestSapienza GestionarPolizaController.PolicyRequestCustomObject - La gestion a validar.
	 * @return True si es valida o false si es invalida
	 */
	public static boolean validateBajaIndividualSapienza(Gestion__c gestionBajaSapienza) {
		Boolean hasError = false;
		ApexPages.Message msg;
		if (hasInvalidResultadoDeBaja(gestionBajaSapienza)) {
			createApexPagesMessageTypeError('Seleccione un resultado para continuar.');
			hasError = true;
		}
		if (hasInvalidMediosDePago(gestionBajaSapienza)) {
			createApexPagesMessageTypeError('Los campos de medio de pago son obligatorios para esta gestion.');
			hasError = true;
		}

		return !hasError;
	}

	/**
	 * @description Genera un mensaje de error con el string pasado y lo agrega a la ApexPages
	 * @param messageError String - Es el mensaje de error que se quiere mostrar
	 */
	private static void createApexPagesMessageTypeError(String messageError) {
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, messageError));
	}

	private static boolean hasInvalidMediosDePago(Gestion__c gestion) {
		return isSeleccionar(gestion) || hasInvalidTarjeta(gestion) || hasInvalidCBU(gestion) || gestion.Medio_de_Pago__c == null;
	}

	private static boolean hasInvalidCBU(Gestion__c gestion) {
		return gestion.Medio_de_Pago__c == 'CBU' && String.isBlank(gestion.Cuenta_de_Pago__c);
	}

	private static boolean hasInvalidTarjeta(Gestion__c gestion) {
		return gestion.Medio_de_Pago__c == 'TARJETA DE CREDITO'
		&& (gestion.Origen_de_Pago__c == '--SELECCIONAR--'
		    || gestion.Origen_de_Pago__c == null
		    || String.isBlank(gestion.Cuenta_de_Pago__c));
	}

	private static boolean isSeleccionar(Gestion__c gestion) {
		return gestion.Medio_de_Pago__c == '--SELECCIONAR--';
	}

	private static boolean hasInvalidResultadoDeBaja(Gestion__c gestion) {
		return gestion.Resultado__c == '--NINGUNO--';
	}

	public static Boolean hasNotPreviousPolicyAndValidityLess90Days(Poliza__c aPolicy) {
		Boolean hasNotPreviousPolicy = aPolicy.Poliza_Anterior__c != null
		&& aPolicy.Poliza_Anterior__c <= 0;

		return hasNotPreviousPolicy && actualValidityLessThan90Days(aPolicy,0);
	}

	private static Boolean actualValidityLessThan90Days(Poliza__c aPolicy, Integer previousPolicyDays) {
		// return aPolicy.Desde__c != null && (previousPolicyDays+aPolicy.Desde__c.daysBetween(Date.today())) <= 90;
		return aPolicy.Desde__c != null && (previousPolicyDays+aPolicy.Desde__c.daysBetween(Datetime.now().date())) <= 90;
	}

	public static Boolean isBranch18Or19AndValidyLess90(Poliza__c aPolicy, Integer previousPolicyDays) {
		return isBranch18Or19(aPolicy) && actualValidityLessThan90Days(aPolicy, previousPolicyDays);
	}

	private static Boolean isBranch18Or19(Poliza__c aPolicy) {
		return '18'.equalsIgnoreCase(aPolicy.Ramo_IdBHSeg__c)
		|| '19'.equalsIgnoreCase(aPolicy.Ramo_IdBHSeg__c);
	}

	public static Boolean isNotFromChannel1009(Poliza__c aPolicy) {
		return !'1009 - On Line'.equalsIgnoreCase(aPolicy.Canal_1__c)
		&& !'1009'.equalsIgnoreCase(aPolicy.Canal_1_IdBHSeg__c);
	}

	public static Boolean isNotFromChannel1010(Poliza__c aPolicy) {
		return !'1010 - HOME BANKING'.equalsIgnoreCase(aPolicy.Canal_1__c)
		&& !'1010'.equalsIgnoreCase(aPolicy.Canal_1_IdBHSeg__c);
	}

	public static Boolean isBranch18Or19AndValidyBetween90and180(Poliza__c aPolicy, Integer previousPolicyDays) { // Jira 1479
		return isBranch18Or19(aPolicy)
		&& !actualValidityLessThan90Days(aPolicy, previousPolicyDays)
		&& actualValidityLessThan180Days(aPolicy, previousPolicyDays);
	}

	public static Boolean isBranch18Or19AndValidyGreaterOf180(Poliza__c aPolicy, Integer previousPolicyDays) { // Jira 1479
		Boolean greatherOf180Days = aPolicy.Desde__c != null && (previousPolicyDays + aPolicy.Desde__c.daysBetween(Date.today())) > 180;

		return isBranch18Or19(aPolicy) && greatherOf180Days;
	}


	public static Boolean validityGreater180Days(Poliza__c aPolicy) {
		Boolean greatherOf180Days = aPolicy.Desde__c != null
		&& aPolicy.Desde__c.daysBetween(Date.today()) > 180;

		Boolean hasPreviousPolicy = aPolicy.Poliza_Anterior__c != null
		&& aPolicy.Poliza_Anterior__c > 0;

		Boolean hasNotPreviousPolicy = aPolicy.Poliza_Anterior__c != null
		&& aPolicy.Poliza_Anterior__c <= 0;

		return hasPreviousPolicy || (hasNotPreviousPolicy && greatherOf180Days);
	}


	public static Boolean policyValidityBetween90and180(Poliza__c aPolicy) { // Jira 1479
		Boolean hasNotPreviousPolicy = aPolicy.Poliza_Anterior__c != null
		&& aPolicy.Poliza_Anterior__c <= 0;

		return hasNotPreviousPolicy
		&& !actualValidityLessThan90Days(aPolicy,0)
		&& actualValidityLessThan180Days(aPolicy,0);
	}

	private static Boolean actualValidityLessThan180Days(Poliza__c aPolicy, Integer previousPolicyDays) { // Jira 1479
		// return aPolicy.Desde__c != null && (previousPolicyDays+aPolicy.Desde__c.daysBetween(Date.today())) <= 180;
		return aPolicy.Desde__c != null && (previousPolicyDays+aPolicy.Desde__c.daysBetween(Datetime.now().date())) <= 180;
	}

	/** Retorna la cantidad de dias desde la fecha "Desde" a hoy de la poliza anterior a la recibida. Si el campo poliza anterior tiene el valor 0 se retornara 0 */
	public static Integer getFromDaysOfPreviousPolicy(Poliza__c policy){
		Integer days = 0;
		// E = Emision, indica que es una poliza de alta (Osea poliza por venta)
		if( policy.Poliza_anterior__c != null && policy.Poliza_anterior__c != 0 && ! 'E'.equalsIgnoreCase(policy.Tipo_Endoso_IdBHSeg__c)){
			Date fromDatePreviousPolicy = [
				SELECT Desde__c, Hasta__c
				FROM Poliza__c
				WHERE Ramo_idbhseg__c = :policy.Ramo_idbhseg__c
					AND Poliza__c = :policy.Poliza_anterior__c
					AND Cuenta__C = :policy.Cuenta__c
				LIMIT 1
			]?.Desde__c;

			if(fromDatePreviousPolicy != null){
				days = fromDatePreviousPolicy.daysBetween(System.today());
			}

		}

		return days;
	}

	public static String getStringValidity(Poliza__c poliza) {
		if(poliza.ramo_idbhseg__c == '18' || poliza.ramo_idbhseg__c == '19' ){ // Estoy hay que repensarlo
			Integer daysOfPreviousPolicy = getFromDaysOfPreviousPolicy(poliza);

			if (isBranch18Or19AndValidyLess90(poliza, daysOfPreviousPolicy)) {
				return 'Menor o Igual a 90 Dias';
			}

			if (isBranch18Or19AndValidyBetween90and180(poliza,daysOfPreviousPolicy)) {
				return 'Mayor a 90 Dias';
			}

			if (isBranch18Or19AndValidyGreaterOf180(poliza,daysOfPreviousPolicy)) {
				return 'Mayor a 180 Dias';
			}
		}

		if (hasNotPreviousPolicyAndValidityLess90Days(poliza)) {
			return 'Menor o Igual a 90 Dias';
		}

		if (policyValidityBetween90and180(poliza)) {
			return 'Mayor a 90 Dias';
		}

		if (validityGreater180Days(poliza)) {
			return 'Mayor a 180 Dias';
		}
		return '';
	}
}