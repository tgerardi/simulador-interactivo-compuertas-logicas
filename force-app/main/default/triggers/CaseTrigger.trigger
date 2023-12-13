trigger CaseTrigger on Case(before insert,
                            before update,
                            after insert,
                            after update) {
	//Variable e if corresponde al jira 1402
	public boolean updateClaimCaseSubject = (Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore;
	if (updateClaimCaseSubject) {
		List<Case> claimCasesWithClosingText = new List<Case> ();
		for (Case newCase : Trigger.new) {

			if (newCase.Reason == 'Siniestros') {
				if (String.isNotBlank(newCase.Texto_de_Cierre__c)) {
					claimCasesWithClosingText.add(newCase);
				}
			}
		}

		if (!claimCasesWithClosingText.isEmpty()) {
			for (Case claimCase : claimCasesWithClosingText) {
				claimCase.Subject = 'Riesgo no cubierto';
			}
		}
	}

	public boolean allowedUserToSendRequest() {

		if(UserInfo.getName() == 'Automated Process') {
			return true;
		} else {
			return String.isNotBlank([
				SELECT Active_Directory_Username__c
				FROM User
				WHERE Id = :UserInfo.getUserId()
			].Active_Directory_Username__c);
		}
		
	}

    // Jira 1375 Se agrega el chequeo de IsFuture e IsQueueable para evitar generar gestiones de cambio de emal por el proceso automatico de asignacion de cuentas
	Boolean sendChangeEmailRequest = (
		!System.isFuture() 
        && !System.isQueueable() 
        && (Trigger.isAfter && Trigger.isUpdate) 
		&& allowedUserToSendRequest()
	);
	
	if (sendChangeEmailRequest) {

		List<Case> casesThatFiresTheRequest = new List<Case> ();

		for (Case thisCase : Trigger.new) {

			Case oldCase = Trigger.oldMap.get(thisCase.id);

			//if in this transaction an account is being assigned to the case, should generate a request.
			if (oldCase.AccountId == null && thisCase.AccountId != null) {
				casesThatFiresTheRequest.add(thisCase);
			}

		}

		if (!casesThatFiresTheRequest.isEmpty()) {
			String rt = [SELECT id FROM RecordType WHERE DeveloperName = 'Cambio_Emails'].id;
			List<String> accIds = new List<String> ();
			Map<String, String> accountIdAndCaseId = new Map<String, String> ();
			for (Case thisCase : casesThatFiresTheRequest) {
				accIds.add(thisCase.AccountId);
				accountIdAndCaseId.put(thisCase.AccountId, thisCase.id);
			}

			system.debug('la lista de ids de cuentas: ' + accIds);

			if (!accIds.isEmpty()) {

				List<Account> clients = [SELECT PersonEmail, Email_Secundario__c FROM Account WHERE id IN :accIds];
				if (clients.size() > 0) {

					Map<String, List<String>> accIdAndEmails = new Map<String, List<String>> ();
					List<String> clientEmails;

					for (Account client : clients) {
						if (accIdAndEmails.get(client.id) == null) {
							clientEmails = new List<String> ();
							clientEmails.add(client.PersonEmail);
							clientEmails.add(client.Email_Secundario__c);
							accIdAndEmails.put(client.id, clientEmails);
						}
					}

					if (!accIdAndEmails.isEmpty()) {
						Gestion__c req;
						List<Gestion__c> requestsToInsert = new List<Gestion__c> ();

						for (String accId : accIdAndEmails.keySet()) {
							req = new Gestion__c();
							req.RecordTypeId = rt;
							req.Cuenta__c = accId;
							req.Caso__c = accountIdAndCaseId.get(accId);
							if (String.isNotBlank(accIdAndEmails.get(accId) [0])) { req.Email__c = accIdAndEmails.get(accId) [0]; }
							if (String.isNotBlank(accIdAndEmails.get(accId) [1])) { req.Email_Secundario__c = accIdAndEmails.get(accId) [1]; }
							req.Estado_Email__c = '1';
							req.Estado_Email_Alternativo__c = '1';
							req.Estado_Comunicacion_Rector__c = 'Para Enviar';
							requestsToInsert.add(req);
						}

						System.debug('requestsToInsert');
						System.debug(requestsToInsert);

						if (!requestsToInsert.isEmpty()) {
							Insert requestsToInsert;
						}
					}

				}
			}
		}
	}


	//---------------------------------------------------------------------------------------------------------------
	// ASIGNO ULTIMA LLAMADA A CASO ABIERTO
	//---------------------------------------------------------------------------------------------------------------
	Boolean setLastCallToCase = trigger.isInsert && trigger.isAfter;
	if (setLastCallToCase) {

		List<String> accountCasesIds = new List<String> ();

		List<String> webCaseId = new List<String> ();

		for (Case newCase : Trigger.new) {
			accountCasesIds.add(newCase.AccountId);
			webCaseId.add(newCase.Id);

		}

		List<Task> unasignedsCall = [SELECT Id, WhatId, Description, Createddate, AccountId FROM Task
		                             WHERE
		                             WhatId = null AND
		                             AccountId IN :accountCasesIds AND
		                             Type = 'Llamada' AND
                                     CreatedDate = TODAY
		                             ORDER BY CreatedDate DESC
		                            ];
		unasignedsCall.sort();

		for (Case newCase : Trigger.new) {
			boolean finish = false;
			for (Task unasignedCall : unasignedsCall) {

				if ((newCase.AccountId == unasignedCall.AccountId) && (!finish)) {
					Integer differenceInMillis = Datetime.now().millisecond() -
					unasignedCall.CreatedDate.millisecond();

					Decimal differenceInMinutes = differenceInMillis / 60000;

					if (differenceInMinutes <= 10 && unasignedCall.WhatId == null) {
						unasignedCall.WhatId = newCase.Id;
						unasignedCall.Status = 'Completed';
						update unasignedCall;
						finish = true;
					}
				}
			}

		}

		//Jira 1360
		//El isRunning esta puesto para evitar romper los test del OpportunityCreator ya que se testeo aparte
		if (!webCaseId.isEmpty() && !Test.isRunningTest()) {
			System.debug('Before opp creator');
			OpportunityCreator.searchForRetentionOpportunities(webCaseId);
			System.debug('After opp creator');
		}

        if(! Test.isRunningTest()){ // Jira 1375 
			CaseTriggerHelper.associateCasesToAccounts(trigger.new);
        }
	}
	//---------------------------------------------------------------------------------------------------------------
	//ASIGNO ENTITLEMENTS ACTIVOS A UN NUEVO CASO
	//---------------------------------------------------------------------------------------------------------------
	Boolean setEntitlements = trigger.isInsert && trigger.isBefore;
	if (setEntitlements) {
		//get all accountIds
		List<Id> accounts = new List<Id> ();
		for (Case newCase : Trigger.new) {
			if (newCase.AccountId != null) {
				accounts.add(newCase.AccountId);
			}
		}
		//build a map with Account ID and Entitlements
		Map<Id, Entitlement> accountEntitlements = new Map<Id, Entitlement> ();
		for (Entitlement entitlement :[SELECT Id, Name, AccountId FROM Entitlement
		     WHERE AccountId IN :accounts]) {
			accountEntitlements.put(entitlement.AccountId, entitlement);
		}
		// update all the cases with the proper entitlement
		for (Case newCase : Trigger.new) {
			if (newCase.AccountId != null && accountEntitlements.get(newCase.AccountId) != null) {
				newCase.EntitlementId = accountEntitlements.get(newCase.AccountId).Id;
			}
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	//CIERRO MILESTONES CUANDO SE CIERRA EL CASO
	//--------------------------------------------------------------------------------------------------------------
	Boolean closeMilestones = Trigger.isAfter && Trigger.isUpdate;
	if (closeMilestones) {
		Map<Id, Case> casesToCloseMilestones = new Map<Id, Case> ();
		for (Case theCase : Trigger.new) {
			Case oldCase = Trigger.oldMap.get(theCase.Id);

			//select milestone to closed based on case being closed (when close case -> close close milestones)
			if (theCase.IsClosed && !oldCase.IsClosed) {
				casesToCloseMilestones.put(theCase.Id, theCase);
			}
		}

		// complete all opened milestones, discarding the current entitlement ones
		List<CaseMilestone> milestonesToUpdate = new List<CaseMilestone> ();
		for (CaseMilestone milestone :[SELECT Id, CreatedDate, CompletionDate,
		     MilestoneTypeId, CaseId
		     FROM CaseMilestone
		     WHERE CaseId IN :casesToCloseMilestones.keySet()
		     AND CompletionDate = NULL
		     ]) {
			// some unwanted CaseMilestones are being created, so since we can't  
			//    manually delete them, we do not assign completion date to them, so
			//    they are automatically deleted
			Long diffInSeconds = (DateTime.now().getTime() - milestone.CreatedDate.getTime()) / 1000;
			if (diffInSeconds > 5) {
				milestone.CompletionDate = DateTime.now();
				milestonesToUpdate.add(milestone);
			}
		}
		update milestonesToUpdate;
	}
	//---------------------------------------------------------------------------------------------------------------
	//CIERRO MILESTONES CUANDO SE CAMBIA EL CAMPO DERIVADO A
	//--------------------------------------------------------------------------------------------------------------
	Boolean closeMilestonesDerivado = Trigger.isAfter && Trigger.isUpdate;
	if (closeMilestonesDerivado) {
		Map<Id, Case> casesToCloseMilestones = new Map<Id, Case> ();
		for (Case theCase : Trigger.new) {
			Case oldCase = Trigger.oldMap.get(theCase.Id);

			//select milestone to closed based field DERIVADO A being changed
			if (theCase.derivado_a__c != oldcase.derivado_a__c && !theCase.isClosed) {
				casesToCloseMilestones.put(theCase.Id, theCase);
			}
		}

		// complete all opened milestones where name starts with DERIVADO, discarding the current entitlement ones
		List<CaseMilestone> milestonesToUpdate = new List<CaseMilestone> ();
		for (CaseMilestone milestone :[SELECT Id, CreatedDate, CompletionDate,
		     MilestoneTypeId, CaseId
		     FROM CaseMilestone
		     WHERE CaseId IN :casesToCloseMilestones.keySet()
		     AND CompletionDate = NULL
		     AND milestoneType.name LIKE 'Derivado%'
		     ]) {
			// some unwanted CaseMilestones are being created, so since we can't  
			//    manually delete them, we do not assign completion date to them, so
			//    they are automatically deleted
			Long diffInSeconds = (DateTime.now().getTime() - milestone.CreatedDate.getTime()) / 1000;
			if (diffInSeconds > 5) {
				milestone.CompletionDate = DateTime.now();
				milestonesToUpdate.add(milestone);
			}
		}
		update milestonesToUpdate;
	}
	//---------------------------------------------------------------------------------------------------------------
	//Cuando creo un caso con origen twitter o facebook lo asigno la cuenta Social Media
	//--------------------------------------------------------------------------------------------------------------    
	Boolean asignarACuentaSocial = trigger.isBefore;
	List<Account> socialAccount = [SELECT Id FROM Account WHERE Name LIKE '%Social%'];
	if (asignarACuentaSocial && socialAccount.size() > 0) {
		for (Case c : Trigger.new) {
			if (c.Origin == 'Twitter' || c.Origin == 'Facebook') {
				c.AccountId = socialAccount[0].Id;
			}
		}
	}
	//---------------------------------------------------------------------------------------------------------------
	//Cuando creo un caso con el origen 'Correo electronico' o 'Web' y tiene un caso asociado copio valores del asociado. 
	//-------------------------------------------------------------------------------------------------------------- 

	Boolean setAsociatedCase = Trigger.isBefore && Trigger.isUpdate;

	if (setAsociatedCase) {
		RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Casos Mails'];
		// Busco todos los casos que cumplen con la regla (origen, recordType y tener caso padre)
		List<String> casesIds = new List<String> ();
		for (Case c : trigger.new) {
			if (c.Caso_Asociado__c != null &&
			(c.origin == 'Correo Electrónico' || c.origin == 'Correo Electr�nico' || c.origin == 'Web') &&
			    c.RecordTypeId == rt.id) {
				casesIds.add(c.Caso_Asociado__c);
			}
		}

		// Busco los campos en los casos padres
		List<Case> parentCases = [SELECT id, resultado__c, Resultado_2__c, reason FROM Case
		                          WHERE id IN :casesIds];
		// Asigno el valor de los casos padres a sus hijos (related)
		for (Case c : trigger.new) {
			if (c.Caso_Asociado__c != null &&
			(c.origin == 'Correo Electrónico' || c.origin == 'Web') &&
			    c.RecordTypeId == rt.id) {
				for (Case parentCase : parentCases) {
					if (parentCase.Id == c.Caso_Asociado__c) {
						c.resultado__c = parentCase.resultado__c;
						c.resultado_2__c = parentCase.resultado_2__c;
						c.reason = parentCase.reason;
					}
				}
			}
		}
	}

	// Start EV-259
	if(Trigger.isBefore){
		if(Trigger.isInsert){

			List<Case> casesToCheckSpam = new List<Case>();
			for(Case aCase : Trigger.new){
				if(aCase.origin == 'Correo Electrónico' || aCase.origin == 'Correo Electr�nico' 
					|| aCase.origin == 'Web'){
						casesToCheckSpam.add(aCase);
					}
			}
			CaseTriggerHelper.checkCasesForSpamEmail(casesToCheckSpam);
			
		}
	}
	// End EV-259


}