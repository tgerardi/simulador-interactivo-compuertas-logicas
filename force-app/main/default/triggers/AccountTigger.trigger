trigger AccountTigger on Account(before update, after insert, before insert) {

	//scoring
	if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
		for (Account acc : Trigger.new) {


			/**
			 * REVISAR LOGICA: 
			 * El campo Scoring__c no se actualiza ya que el condicional acc.Scoring__c.contains(acc.Score__c)
			 * puede ser true aunque sean distintos.
			 * 
			 */


			//fill scoring field if it is empty
			if (String.isBlank(acc.Scoring__c)) {
				acc.Scoring__c = '<div style="color: red; font-size: 20px;"><b>null</b></div>';
			}

			//update scoring field
			if (String.isNotBlank(acc.score__c)) {

				if (!acc.Scoring__c.contains(acc.Score__c)) {
					String toDelete = acc.Scoring__c.subStringBetween('<b>', '</b>');
					if (String.isNotBlank(toDelete)) {
						acc.Scoring__c = acc.Scoring__c.replace(toDelete, acc.Score__c);
					}
				}
			}
		}
	}

	//jira 655
	boolean updatePersonEmailBecauseTheUserWereAlerted = trigger.isUpdate & trigger.isBefore;

	if (updatePersonEmailBecauseTheUserWereAlerted) {

		List<Alerta__c> clientAlerts = new List<Alerta__c> ();
		List<String> accIds = new List<String> ();

		Account oldAccount;
		Alerta__c alertToDelete;

		boolean hasEmailAlert = false;
		String newEmail = '';

		//first we must to check if the client already have an invalid email alert
		for (Account thisAcc : Trigger.new) {
			accIds.add(thisAcc.Id);
			newEmail = thisAcc.PersonEmail;
		}

		if (accIds.size() == 1) {
			clientAlerts = [SELECT Titulo__c FROM Alerta__c WHERE Cuenta__c = :accIds[0]];
		}

		for (Alerta__c thisAlert : clientAlerts) {
			if (thisAlert.Titulo__c == 'Error en Correo Electronico') {
				hasEmailAlert = true;
				alertToDelete = thisAlert;
			}
		}

		if (hasEmailAlert) {
			//then we take the oldmap of the record
			oldAccount = Trigger.oldMap.get(accIds[0]);
			if (String.isBlank(oldAccount.PersonEmail) && String.isNotBlank(newEmail)) {
				//if the personemail of the client was updated, remove the alert
				Delete alertToDelete;
			}
		}
	}

	Boolean addEntitlementToAccount = trigger.isAfter && trigger.isInsert;

	if (addEntitlementToAccount) {
		// create entitlements for each active process
		List<SlaProcess> entitlementProcesses = [SELECT Id, Name FROM SlaProcess WHERE IsActive = true];
		List<Entitlement> newEntitlements = new List<Entitlement> ();

		for (Account account : Trigger.new) {
			for (SlaProcess entitlementProcess : entitlementProcesses) {
				Entitlement entitlement = new Entitlement(Name = entitlementProcess.Name,
				                                          SlaProcessId = entitlementProcess.Id,
				                                          AccountId = account.Id,
				                                          StartDate = Date.today(),
				                                          EndDate = Date.today().addYears(100)
				);
				newEntitlements.add(entitlement);
			}
		}
		insert newEntitlements;
	}



	if (trigger.isBefore && trigger.isUpdate) {
		List<Gestion__c> requestToInsert = new List<Gestion__c> ();
		// pattern myPattern = pattern.compile('(\\(([0-9]{0,6})?(-[0-9]{0,5})?\\)\\(([0-9]{0,2})?\\)[0-9]{1,4}-[0-9]{1,4}(( )?(INT)( )?[0-9]{0,5})?)');
		for (Account newClient : Trigger.new) {

			if (!newClient.Is_API_Update__c && !newClient.CMDPUpdated__c)
			{
				Account oldClient = Trigger.oldMap.get(newClient.Id);

				String newPhone = '';
				String newPersonMobilePhone = '';
				String newPersonHomePhone = '';
				//boolean hasError = false;
				String errors;
				if (newClient.Phone != oldClient.Phone && newClient.Phone != null) {
					newPhone = newClient.Phone;

				/* Comentado, esta validacion no va mas (14/09/2020)
					matcher myMatcher = myPattern.matcher(newPhone);
					if (!myMatcher.matches()) {
						hasError = true;
						errors = errors + ' - El formato del campo Telefono no es correcto';
					}*/
				}

				if (newClient.PersonMobilePhone != oldClient.PersonMobilePhone && newClient.PersonMobilePhone != null) {
					newPersonMobilePhone = newClient.PersonMobilePhone;
					
				/* Comentado, esta validacion no va mas (14/09/2020)
					matcher myMatcher = myPattern.matcher(newPersonMobilePhone);
					if (!myMatcher.matches()) {
						hasError = true;
						errors = errors + ' - El formato del campo Celular no es correcto';
					}*/
				}

				if (newClient.PersonHomePhone != oldClient.PersonHomePhone && newClient.PersonHomePhone != null) {
					newPersonHomePhone = newClient.PersonHomePhone;
					
				/* Comentado, esta validacion no va mas (14/09/2020)
					matcher myMatcher = myPattern.matcher(newPersonHomePhone);
					if (!myMatcher.matches()) {
						hasError = true;
						errors = errors + ' - El formato del campo Telefono Particular no es correcto';
					}*/
				}

				//(54-11)()4347-1095 INT

				/* Comentado, esta validacion no va mas (14/09/2020)
					if (hasError) {
						errors = errors + ' por favor revisar la ayuda de los campos.';
						newClient.addError(errors);
					}
				*/

				if (!newClient.CMDPUpdated__c && (newPhone != '' ||
				                                  newPersonMobilePhone != '' ||
				                                  newPersonHomePhone != '')) {
					List<Case> clientCase = [SELECT Id FROM Case
					                         WHERE Account.Id = :newClient.Id
					                         AND isClosed = false
					                         ORDER BY CreatedDate DESC LIMIT 1];

					if (clientCase.size() == 0) {
						clientCase.add(new Case());
						clientCase[0].AccountId = newClient.Id;
						insert clientCase[0];
					}

					RecordType rt = [SELECT Id, DeveloperName FROM RecordType WHERE
					                 DeveloperName = 'Cambio_Telefonos' AND
					                 IsActive = TRUE];

					Gestion__c request = new Gestion__c(recordtypeId = rt.Id);

					request.Cuenta__c = newClient.Id;
					request.Telefono__c = newPhone;
					request.Telefono_Celular__c = newPersonMobilePhone;
					request.Telefono_Particular__c = newPersonHomePhone;
					request.Estado_Comunicacion_Rector__c = 'Para Enviar';
					request.Caso__c = clientCase[0].Id;
					request.Iniciada_por__c = UserInfo.getName();

					requestToInsert.add(request);

					newClient.Fecha_Ultima_Actualizacion_Contacto__c = Date.today();
					newClient.Fecha_ultima_verificacion__c = Date.today();
				}

				String newMail = '';
				String newAltMail = '';


				if (newClient.PersonEmail != oldClient.PersonEmail) {
					newMail = newClient.PersonEmail;
				}

				if (newClient.Email_Secundario__c != oldClient.Email_Secundario__c) {
					newAltMail = newClient.Email_Secundario__c;
				}


				if ((String.isNotBlank(newMail) || String.isNotBlank(newAltMail)) &&
				    !newClient.CMDPUpdated__c) {
					List<Case> clientCase = [SELECT Id FROM Case
					                         WHERE Account.Id = :newClient.Id
					                         AND isClosed = false
					                         ORDER BY CreatedDate DESC LIMIT 1];

					if (clientCase.size() == 0) {
						clientCase.add(new Case());
						clientCase[0].AccountId = newClient.Id;
						insert clientCase[0];
					}

					RecordType rt = [SELECT Id, DeveloperName FROM RecordType WHERE
					                 DeveloperName = 'Cambio_Emails' AND
					                 IsActive = TRUE];

					Gestion__c request = new Gestion__c(recordtypeId = rt.Id);

					request.Cuenta__c = newClient.Id;
					request.Email__c = newMail;
					request.Email_Secundario__c = newAltMail;
					request.Estado_Comunicacion_Rector__c = 'Para Enviar';
					request.Caso__c = clientCase[0].Id;
					request.Iniciada_por__c = UserInfo.getName();

					//771
					request.Estado_Email__c = '3';
					request.Estado_Email_Alternativo__c = '3';

					requestToInsert.add(request);

					newClient.Fecha_Ultima_Actualizacion_Contacto__c = Date.today();
					newClient.Fecha_ultima_verificacion__c = Date.today();
				}


				if (!newClient.CMDPUpdated__c 
					&& (newClient.FirstName != oldClient.FirstName 
						|| newClient.LastName != oldClient.LastName)) {
					List<Case> clientCase = [SELECT Id FROM Case
					                         WHERE Account.Id = :newClient.Id
					                         AND isClosed = false
					                         ORDER BY CreatedDate DESC LIMIT 1];

					if (clientCase.size() == 0) {
						//If we haven't a case we create a new one related to the client.
						clientCase.add(new Case());
						clientCase[0].AccountId = newClient.Id;
						insert clientCase[0];
					}

					RecordType rt = [SELECT Id, DeveloperName FROM RecordType WHERE
					                 DeveloperName = 'Actualizacion_Nombre_Apellido' AND
									 IsActive = TRUE];
									 
					List<Poliza__c> pols = [SELECT Id FROM Poliza__c WHERE Cuenta__c = :newClient.Id AND
					                        Estado__c LIKE 'VIGENTE'];

					Gestion__c request = new Gestion__c(recordtypeId = rt.Id);
					request.Cuenta__c = newClient.Id;
					request.Nombre_Original__c = oldClient.FirstName;
					request.Apellido_Original__c = oldClient.LastName;
					request.Nombre_Modificado__c = newClient.FirstName;
					request.Apellido_Modificado__c = newClient.LastName;
					request.Estado_Comunicacion_Rector__c = 'Para Enviar';
					request.Estado_MKT__c = 'Para Enviar';
					request.Caso__c = clientCase[0].Id;
					request.Iniciada_por__c = UserInfo.getName();
					
					if (pols.size() > 0) {
						request.Poliza__c = pols[0].Id;
					}
					else {
						newClient.addError('El cliente no tiene ninguna poliza vigente');
					}

					requestToInsert.add(request);
				}

			}
			newClient.Is_API_Update__c = false;
			newClient.CMDPUpdated__c = false;
		}


		insert requestToInsert;
	}

	/*
	if(Trigger.isAfter) {

		if(Trigger.isInsert) {
			AccountHelper.checkDuplicados(Trigger.new, true);
		} 
	}

	else if (Trigger.isBefore) {

		if (Trigger.isUpdate) {
			System.debug('entro');
			AccountHelper.checkDuplicados(Trigger.new, Trigger.oldMap);
		} 
	}
	*/
}