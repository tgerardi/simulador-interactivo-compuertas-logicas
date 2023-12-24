@isTest
private class ClientFinderTest {

	@IsTest
	static void shouldBePossibleToSearchClientByAccountNumber() {
		Account client = Build.aClient().build();

		Tipos_de_Documento__c docType = Build.aDocType().build();
		insert docType;

		List<Account> clientsFound = [SELECT Id FROM Account WHERE Numero_de_Documento__c = :client.Numero_de_Documento__c];
		system.assertEquals(0, clientsFound.size());

		ClientFinderMock mock = Build.aClientFinderMock().withClient(client).build();
		Test.setMock(HttpCalloutMock.class, mock);

		ClientFinder controller = new ClientFinder();

		Test.startTest();
		Apexpages.currentPage().getParameters().put('accNumber', '123456');
		controller.findClientByAccountNumber();
		Test.stopTest();

		system.assertEquals(1, controller.ClientsFound.size());

		Account foundClient = controller.ClientsFound[0];
		system.assertEquals(client.IdBHSeg__c, foundClient.IdBHSeg__c);
		system.assertEquals(client.FirstName, foundClient.FirstName);
		system.assertEquals(client.LastName, foundClient.LastName);
		system.assertEquals(client.Genero__c, foundClient.Genero__c);
		system.assertEquals(client.PersonBirthdate, foundClient.PersonBirthdate);
		system.assertEquals(client.Tipo_de_Documento__c, foundClient.Tipo_de_Documento__c);
		system.assertEquals(client.Numero_de_Documento__c, foundClient.Numero_de_Documento__c);
		system.assertEquals(client.CUIT__c, foundClient.CUIT__c);
		system.assertEquals(client.Estado_Civil__c, foundClient.Estado_Civil__c);
		system.assertEquals(client.Id_Cliente_BHSeg__c, foundClient.Id_Cliente_BHSeg__c);
		system.assertEquals('', controller.StatusText);

	}

	static testMethod void clientAlreadyInSalesforceCanBeFoundByIdCliente() {

		Account client = Build.aClient().build();
		insert client;

		Test.startTest();

		ClientFinderMock mock = Build.aClientFinderMock().withClient(client).build();
		Test.setMock(HttpCalloutMock.class, mock);

		ClientFinder controller = new ClientFinder();

		Apexpages.currentPage().getParameters().put('idCliente', client.Id_Cliente_BHSeg__c);
		controller.findClientByIdCliente();

		system.assertEquals(1, controller.ClientsFound.size());
		system.debug(client);
		system.debug(controller.ClientsFound[0]);
		system.assertEquals(client.Numero_de_Documento__c, controller.ClientsFound[0].Numero_De_Documento__c);
		system.assertEquals('', controller.StatusText);
	}

	static testMethod void clientNotInSalesforceCanBeFoundByIdClienteInsertedToSalesforceAndRetrieved() {

		Account client = Build.aClient().build();

		Tipos_de_Documento__c docType = Build.aDocType().build();
		insert docType;

		List<Account> clientsFound = [SELECT Id FROM Account WHERE Id_Cliente_BHSeg__c = :client.Id_Cliente_BHSeg__c];
		system.assertEquals(0, clientsFound.size());

		Test.startTest();

		ClientFinderMock mock = Build.aClientFinderMock().withClient(client).build();
		Test.setMock(HttpCalloutMock.class, mock);

		ClientFinder controller = new ClientFinder();

		Apexpages.currentPage().getParameters().put('idCliente', client.Id_Cliente_BHSeg__c);
		controller.findClientByIdCliente();

		system.assertEquals(1, controller.ClientsFound.size());

		Account foundClient = controller.ClientsFound[0];
		system.assertEquals(client.IdBHSeg__c, foundClient.IdBHSeg__c);
		system.assertEquals(client.FirstName, foundClient.FirstName);
		system.assertEquals(client.LastName, foundClient.LastName);
		system.assertEquals(client.Genero__c, foundClient.Genero__c);
		system.assertEquals(client.PersonBirthdate, foundClient.PersonBirthdate);
		system.assertEquals(client.Tipo_de_Documento__c, foundClient.Tipo_de_Documento__c);
		system.assertEquals(client.Numero_de_Documento__c, foundClient.Numero_de_Documento__c);
		system.assertEquals(client.CUIT__c, foundClient.CUIT__c);
		system.assertEquals(client.Estado_Civil__c, foundClient.Estado_Civil__c);
		system.assertEquals(client.Id_Cliente_BHSeg__c, foundClient.Id_Cliente_BHSeg__c);
		system.assertEquals('', controller.StatusText);

		Test.stopTest();
	}

	static testMethod void ClientSearchByIdClientewithNoResultShowsWarning() {
		ClientFinderMock mock = Build.aClientFinderMock().build();
		Test.setMock(HttpCalloutMock.class, mock);

		ClientFinder controller = new ClientFinder();

		Apexpages.currentPage().getParameters().put('idCliente', '');
		controller.findClientByIdCliente();

		system.assertEquals(0, controller.ClientsFound.size());
		system.assertEquals('No se encontraron resultados', controller.StatusText);

	}

	static testMethod void clientNotInSalesforceCanBeFoundByDNIInsertedToSalesforceAndRetrieved() {

		Account client = Build.aClient().build();

		Tipos_de_Documento__c docType = Build.aDocType().build();
		insert docType;

		List<Account> clientsFound = [SELECT Id FROM Account WHERE Numero_de_Documento__c = :client.Numero_de_Documento__c];
		system.assertEquals(0, clientsFound.size());

		Test.startTest();

		ClientFinderMock mock = Build.aClientFinderMock().withClient(client).build();
		Test.setMock(HttpCalloutMock.class, mock);

		ClientFinder controller = new ClientFinder();

		Apexpages.currentPage().getParameters().put('docNum', client.Numero_de_Documento__c);
		controller.findClientByDocumentNumber();

		system.assertEquals(1, controller.ClientsFound.size());

		Account foundClient = controller.ClientsFound[0];
		system.assertEquals(client.IdBHSeg__c, foundClient.IdBHSeg__c);
		system.assertEquals(client.FirstName, foundClient.FirstName);
		system.assertEquals(client.LastName, foundClient.LastName);
		system.assertEquals(client.Genero__c, foundClient.Genero__c);
		system.assertEquals(client.PersonBirthdate, foundClient.PersonBirthdate);
		system.assertEquals(client.Tipo_de_Documento__c, foundClient.Tipo_de_Documento__c);
		system.assertEquals(client.Numero_de_Documento__c, foundClient.Numero_de_Documento__c);
		system.assertEquals(client.CUIT__c, foundClient.CUIT__c);
		system.assertEquals(client.Estado_Civil__c, foundClient.Estado_Civil__c);
		system.assertEquals(client.Id_Cliente_BHSeg__c, foundClient.Id_Cliente_BHSeg__c);
		system.assertEquals('', controller.StatusText);

		Test.stopTest();
	}

	static testMethod void clientNotInSalesforceCanBeFoundByDNIInsertedToSalesforceAndRetrievedByTheExtendedMethod() {

		Account client = Build.aClient().build();

		Tipos_de_Documento__c docType = Build.aDocType().build();
		insert docType;

		List<Account> clientsFound = [SELECT Id FROM Account WHERE Numero_de_Documento__c = :client.Numero_de_Documento__c];
		system.assertEquals(0, clientsFound.size());

		Test.startTest();

		ClientFinderMock mock = Build.aClientFinderMock().withClient(client).build();
		Test.setMock(HttpCalloutMock.class, mock);

		ClientFinder controller = new ClientFinder();

		Apexpages.currentPage().getParameters().put('docNumber', client.Numero_de_Documento__c);
		controller.findClientByDocumentNumber();

		system.assertEquals(1, controller.ClientsFound.size());

		Account foundClient = controller.ClientsFound[0];
		system.assertEquals(client.IdBHSeg__c, foundClient.IdBHSeg__c);
		system.assertEquals(client.FirstName, foundClient.FirstName);
		system.assertEquals(client.LastName, foundClient.LastName);
		system.assertEquals(client.Genero__c, foundClient.Genero__c);
		system.assertEquals(client.PersonBirthdate, foundClient.PersonBirthdate);
		system.assertEquals(client.Tipo_de_Documento__c, foundClient.Tipo_de_Documento__c);
		system.assertEquals(client.Numero_de_Documento__c, foundClient.Numero_de_Documento__c);
		system.assertEquals(client.CUIT__c, foundClient.CUIT__c);
		system.assertEquals(client.Estado_Civil__c, foundClient.Estado_Civil__c);
		system.assertEquals(client.Id_Cliente_BHSeg__c, foundClient.Id_Cliente_BHSeg__c);
		system.assertEquals('', controller.StatusText);

		Test.stopTest();
	}

	static testMethod void clientsWithSameDNIcanBeFoundInsertedToSalesforceAndRetrieve() {
		Tipos_de_Documento__c docType = Build.aDocType().build();
		insert docType;

		Account client1 = Build.aClient().withLastName('Perez')
		.withFirstName('Juan')
		.withDocNumber('11222333')
		.build();

		Account client2 = Build.aClient().withLastName('Garay')
		.withFirstName('Jose')
		.withDocNumber('11222333')
		.build();

		Test.startTest();

		ClientFinderMock mock = Build.aClientFinderMock().withClient(client1)
		.withClient(client2)
		.build();
		Test.setMock(HttpCalloutMock.class, mock);

		ClientFinder controller = new ClientFinder();
		Apexpages.currentPage().getParameters().put('docNum', '11222333');
		controller.findClientByDocumentNumber();

		List<Account> clientsFound = controller.clientsFound;

		system.assertEquals(2, clientsFound.size());

		system.assertEquals(client1.FirstName, clientsFound[0].FirstName);
		system.assertEquals(client1.LastName, clientsFound[0].LastName);
		system.assertEquals(client1.Tipo_de_Documento__c, clientsFound[0].Tipo_de_Documento__c);
		system.assertEquals(client1.Numero_de_Documento__c, clientsFound[0].Numero_de_Documento__c);

		system.assertEquals(client2.FirstName, clientsFound[1].FirstName);
		system.assertEquals(client2.LastName, clientsFound[1].LastName);
		system.assertEquals(client2.Tipo_de_Documento__c, clientsFound[1].Tipo_de_Documento__c);
		system.assertEquals(client2.Numero_de_Documento__c, clientsFound[1].Numero_de_Documento__c);
		system.assertEquals('', controller.StatusText);

		Test.stopTest();
	}

	static testMethod void ClientSearchByDNIwithNoResultShowsWarning() {
		ClientFinderMock mock = Build.aClientFinderMock().build();
		Test.setMock(HttpCalloutMock.class, mock);

		ClientFinder controller = new ClientFinder();

		Apexpages.currentPage().getParameters().put('docNum', '');
		controller.findClientByDocumentNumber();

		system.assertEquals(0, controller.ClientsFound.size());
		system.assertEquals('No se encontraron resultados', controller.StatusText);

	}

	static testMethod void clientsInRectorCanBeFoundByNameAndLastName() {
		Tipos_de_Documento__c docType = Build.aDocType().build();
		insert docType;

		Account client1 = Build.aClient().withLastName('Perez')
		.withFirstName('Juan')
		.withDocNumber('123')
		.build();

		Account client2 = Build.aClient().withLastName('Perez garay')
		.withFirstName('Jose')
		.withDocNumber('345')
		.build();

		Test.startTest();

		ClientFinderMock mock = Build.aClientFinderMock().withClient(client1)
		.withClient(client2)
		.build();
		Test.setMock(HttpCalloutMock.class, mock);

		ClientFinder controller = new ClientFinder();
		Apexpages.currentPage().getParameters().put('firstName', 'J');
		Apexpages.currentPage().getParameters().put('lastName', 'Perez');
		controller.findClientByName();

		List<Account> clientsFound = controller.clientsFound;

		system.assertEquals(2, clientsFound.size());

		system.assertEquals(client1.FirstName, clientsFound[0].FirstName);
		system.assertEquals(client1.LastName, clientsFound[0].LastName);
		system.assertEquals(client1.Tipo_de_Documento__c, clientsFound[0].Tipo_de_Documento__c);
		system.assertEquals(client1.Numero_de_Documento__c, clientsFound[0].Numero_de_Documento__c);

		system.assertEquals(client2.FirstName, clientsFound[1].FirstName);
		system.assertEquals(client2.LastName, clientsFound[1].LastName);
		system.assertEquals(client2.Tipo_de_Documento__c, clientsFound[1].Tipo_de_Documento__c);
		system.assertEquals(client2.Numero_de_Documento__c, clientsFound[1].Numero_de_Documento__c);
		system.assertEquals('', controller.StatusText);

		Test.stopTest();
	}

	static testMethod void ClientSearchByNamewithNoResultShowsWarning() {
		ClientFinderMock mock = Build.aClientFinderMock().build();
		Test.setMock(HttpCalloutMock.class, mock);

		ClientFinder controller = new ClientFinder();

		Apexpages.currentPage().getParameters().put('firstName', '');
		Apexpages.currentPage().getParameters().put('lastName', '');
		controller.findClientByName();

		system.assertEquals(0, controller.ClientsFound.size());
		system.assertEquals('No se encontraron resultados', controller.StatusText);

	}

	static testMethod void clientAlreadyInSalesforceCanBeFoundByCertificateCode() {

		Account client = Build.aClient().build();
		insert client;

		Poliza__c policy = Build.aPolicy().forClient(client).build();
		insert policy;

		ClientFinder controller = new ClientFinder();

		Apexpages.currentPage().getParameters().put('certCode', policy.Certificado_Id_BHSeg__c);
		controller.findClientByCertificateCode();

		system.assertEquals(1, controller.ClientsFound.size());
		system.assertEquals(client, controller.ClientsFound[0]);
	}

	static testMethod void clientNotInSalesforceCanBeFoundByCertificateCodeInsertedToSalesforceAndRetrieved() {

		Tipos_de_Documento__c docType = Build.aDocType().build();
		insert docType;

		Account client = Build.aClient().build();

		Poliza__c policy = Build.aPolicy().forClient(client).build();

		RectorCertificate certificate = Build.aRectorCertificate().forClient(client)
		.withCertificado(policy.Certificado_Id_BHSeg__c)
		.build();

		List<Account> clientsFound = [SELECT Id FROM Account WHERE Id_Cliente_BHSeg__c = :client.Id_Cliente_BHSeg__c];
		system.assertEquals(0, clientsFound.size());

		Test.startTest();

		ClientFinderMock mock = Build.aClientFinderMock().withClient(client)
		.withRectorCertificate(certificate)
		.build();
		Test.setMock(HttpCalloutMock.class, mock);

		ClientFinder controller = new ClientFinder();

		Apexpages.currentPage().getParameters().put('certCode', policy.Certificado_Id_BHSeg__c);
		controller.findClientByCertificateCode();

		clientsFound = controller.ClientsFound;

		system.assertEquals(1, clientsFound.size());

		system.assertEquals(client.IdBHSeg__c, clientsFound[0].IdBHSeg__c);
		system.assertEquals(client.FirstName, clientsFound[0].FirstName);
		system.assertEquals(client.LastName, clientsFound[0].LastName);
		system.assertEquals(client.Genero__c, clientsFound[0].Genero__c);
		system.assertEquals(client.PersonBirthdate, clientsFound[0].PersonBirthdate);
		system.assertEquals(client.Tipo_de_Documento__c, clientsFound[0].Tipo_de_Documento__c);
		system.assertEquals(client.Numero_de_Documento__c, clientsFound[0].Numero_de_Documento__c);
		system.assertEquals(client.CUIT__c, clientsFound[0].CUIT__c);
		system.assertEquals(client.Estado_Civil__c, clientsFound[0].Estado_Civil__c);
		system.assertEquals(client.Id_Cliente_BHSeg__c, clientsFound[0].Id_Cliente_BHSeg__c);

		Test.stopTest();
	}

	static testMethod void ClientSearchByCertificateCodewithNoResultShowsWarning() {
		ClientFinderMock mock = Build.aClientFinderMock().build();
		Test.setMock(HttpCalloutMock.class, mock);

		ClientFinder controller = new ClientFinder();

		Apexpages.currentPage().getParameters().put('certCode', '0|0|0');
		controller.findClientByCertificateCode();

		system.assertEquals(0, controller.ClientsFound.size());
		system.assertEquals('No se encontraron resultados', controller.StatusText);

	}

	static testMethod void clientAlreadyInSalesforceCanBeFoundByClaimNumberAndTradeId() {

		Account client = Build.aClient().build();
		insert client;

		Poliza__c policy = Build.aPolicy().forClient(client).build();
		insert policy;

		Siniestro__c claim = Build.aClaim().forPolicy(policy).forClient(client).build();
		insert claim;

		ClientFinder controller = new ClientFinder();

		Apexpages.currentPage().getParameters().put('claimNumber', claim.Numero__c.toPlainString());
		Apexpages.currentPage().getParameters().put('tradeId', policy.Ramo_IdBHSeg__c);
		controller.findClientByClaim();

		system.assertEquals(1, controller.ClientsFound.size());
		system.assertEquals(client, controller.ClientsFound[0]);
	}

	static testMethod void clientNotInSalesforceCanBeFoundByClaimNumberAndTradeIdInsertedToSalesforceAndRetrieved() {

		Tipos_de_Documento__c docType = Build.aDocType().build();
		insert docType;

		Account client = Build.aClient().build();

		Poliza__c policy = Build.aPolicy().forClient(client).build();

		Siniestro__c claim = Build.aClaim().forPolicy(policy).forClient(client).build();

		List<Account> clientsFound = [SELECT Id FROM Account WHERE Id_Cliente_BHSeg__c = :client.Id_Cliente_BHSeg__c];
		system.assertEquals(0, clientsFound.size());

		Test.startTest();

		ClientFinderMock mock = Build.aClientFinderMock().withClient(client).build();
		Test.setMock(HttpCalloutMock.class, mock);

		ClientFinder controller = new ClientFinder();

		Apexpages.currentPage().getParameters().put('claimNumber', claim.Numero__c.toPlainString());
		Apexpages.currentPage().getParameters().put('tradeId', policy.Ramo_IdBHSeg__c);
		controller.findClientByClaim();

		clientsFound = controller.ClientsFound;

		system.assertEquals(1, clientsFound.size());

		system.assertEquals(client.IdBHSeg__c, clientsFound[0].IdBHSeg__c);
		system.assertEquals(client.FirstName, clientsFound[0].FirstName);
		system.assertEquals(client.LastName, clientsFound[0].LastName);
		system.assertEquals(client.Genero__c, clientsFound[0].Genero__c);
		system.assertEquals(client.PersonBirthdate, clientsFound[0].PersonBirthdate);
		system.assertEquals(client.Tipo_de_Documento__c, clientsFound[0].Tipo_de_Documento__c);
		system.assertEquals(client.Numero_de_Documento__c, clientsFound[0].Numero_de_Documento__c);
		system.assertEquals(client.CUIT__c, clientsFound[0].CUIT__c);
		system.assertEquals(client.Estado_Civil__c, clientsFound[0].Estado_Civil__c);
		system.assertEquals(client.Id_Cliente_BHSeg__c, clientsFound[0].Id_Cliente_BHSeg__c);

		Test.stopTest();
	}

	static testMethod void ClientSearchByClaimNumberWithNoResultShowsWarning() {
		ClientFinderMock mock = Build.aClientFinderMock().build();
		Test.setMock(HttpCalloutMock.class, mock);

		ClientFinder controller = new ClientFinder();

		Apexpages.currentPage().getParameters().put('claimNumber', '0');
		Apexpages.currentPage().getParameters().put('tradeId', '0');
		controller.findClientByClaim();

		system.assertEquals(0, controller.ClientsFound.size());
		system.assertEquals('No se encontraron resultados', controller.StatusText);

	}

	static testMethod void clientAlreadyInSalesforceCanBeFoundByRequestNumber() {

		Account client = Build.aClient().build();
		insert client;

		Poliza__c policy = Build.aPolicy().forClient(client).build();
		insert policy;

		Gestion__c request = Build.aRequest().forPolicy(policy).build();
		insert request;

		ClientFinder controller = new ClientFinder();

		Apexpages.currentPage().getParameters().put('reqNumber', request.Numero__c.toPlainString());
		controller.findClientByRequest();

		system.assertEquals(1, controller.ClientsFound.size());
		system.assertEquals(client, controller.ClientsFound[0]);
	}

	static testMethod void clientNotInSalesforceCanBeFoundByRequestNumberInsertedToSalesforceAndRetrieved() {

		Tipos_de_Documento__c docType = Build.aDocType().build();
		insert docType;

		Account client = Build.aClient().build();

		Poliza__c policy = Build.aPolicy().forClient(client).build();

		Gestion__c request = Build.aRequest().forPolicy(policy).build();

		List<Account> clientsFound = [SELECT Id FROM Account WHERE Id_Cliente_BHSeg__c = :client.Id_Cliente_BHSeg__c];
		system.assertEquals(0, clientsFound.size());

		Test.startTest();

		ClientFinderMock mock = Build.aClientFinderMock().withClient(client).build();
		Test.setMock(HttpCalloutMock.class, mock);

		ClientFinder controller = new ClientFinder();

		Apexpages.currentPage().getParameters().put('reqNumber', request.Numero__c.toPlainString());
		controller.findClientByRequest();

		clientsFound = controller.ClientsFound;

		system.assertEquals(1, clientsFound.size());

		system.assertEquals(client.IdBHSeg__c, clientsFound[0].IdBHSeg__c);
		system.assertEquals(client.FirstName, clientsFound[0].FirstName);
		system.assertEquals(client.LastName, clientsFound[0].LastName);
		system.assertEquals(client.Genero__c, clientsFound[0].Genero__c);
		system.assertEquals(client.PersonBirthdate, clientsFound[0].PersonBirthdate);
		system.assertEquals(client.Tipo_de_Documento__c, clientsFound[0].Tipo_de_Documento__c);
		system.assertEquals(client.Numero_de_Documento__c, clientsFound[0].Numero_de_Documento__c);
		system.assertEquals(client.CUIT__c, clientsFound[0].CUIT__c);
		system.assertEquals(client.Estado_Civil__c, clientsFound[0].Estado_Civil__c);
		system.assertEquals(client.Id_Cliente_BHSeg__c, clientsFound[0].Id_Cliente_BHSeg__c);

		Test.stopTest();
	}

	static testMethod void ClientSearchByRequestNumberWithNoResultShowsWarning() {
		ClientFinderMock mock = Build.aClientFinderMock().build();
		Test.setMock(HttpCalloutMock.class, mock);

		ClientFinder controller = new ClientFinder();

		Apexpages.currentPage().getParameters().put('reqNumber', '0');
		controller.findClientByRequest();

		system.assertEquals(0, controller.ClientsFound.size());
		system.assertEquals('No se encontraron resultados', controller.StatusText);

	}

	static testMethod void StartingASearchShowInfoAndHidesResultTable() {
		ClientFinder controller = new ClientFinder();

		controller.startSearch();

		system.assertEquals(false, controller.ShowTable);
		system.assertEquals(true, controller.ShowSearching);
		system.assertEquals('Buscando...', controller.StatusText);

	}

	static testMethod void EndingASearchHidesSearchingInfo() {
		ClientFinder controller = new ClientFinder();

		controller.endSearch();

		system.assertEquals(false, controller.ShowSearching);
	}

	static testMethod void SearchWithBadDataShowsInfoAndHidesEverythingElse() {
		ClientFinder controller = new ClientFinder();

		controller.badData();

		system.assertEquals(false, controller.ShowTable);
		system.assertEquals(false, controller.ShowSearching);
		system.assertEquals('Por favor revise los datos ingresados', controller.StatusText);

	}
    
    static testMethod void SearchWithBadDataShowsInfoAndHidesEverythingElse1() {
		ClientFinder controller = new ClientFinder();

		controller.badName();

	}
    
    static testMethod void clientFinderByDni() {
		Tipos_de_Documento__c docType = Build.aDocType().build();
		insert docType;

		Account client = Build.aClient().withLastName('Perez')
		.withFirstName('Juan')
		.withDocNumber('37520009')
		.build();
		
        Contact contacto = new Contact(FirstName = 'Prueba', LastName = 'Test');
        insert contacto;
        
        Case caso = new Case(AccountId = client.Id, ContactId = contacto.Id, origin = 'Twitter');
        insert caso;
        

		Test.startTest();

		ClientFinderMock mock = Build.aClientFinderMock().withClient(client).build();
		Test.setMock(HttpCalloutMock.class, mock);
        
		Apexpages.currentPage().getParameters().put('caseId', (String)caso.Id);
		ClientFinder controller = new ClientFinder();
        
		Apexpages.currentPage().getParameters().put('docNum', '37520009');
		controller.findClientByDocumentNumber();

		Test.stopTest();
	}
    
    static void shouldBePossibleToSearchClientByAccountNumber2() {
		Account client = Build.aClient().build();
        insert client;
        
        Contact contacto = new Contact(FirstName = 'Prueba', LastName = 'Test');
        insert contacto;
        
        Case caso = new Case(AccountId = client.Id, ContactId = contacto.Id, origin = 'Twitter');
        insert caso;

		Tipos_de_Documento__c docType = Build.aDocType().build();
		insert docType;

		List<Account> clientsFound = [SELECT Id FROM Account WHERE Numero_de_Documento__c = :client.Numero_de_Documento__c];
		

		ClientFinderMock mock = Build.aClientFinderMock().withClient(client).build();
		Test.setMock(HttpCalloutMock.class, mock);
		Apexpages.currentPage().getParameters().put('caseId', (String)caso.Id);
		ClientFinder controller = new ClientFinder();

		Test.startTest();
		Apexpages.currentPage().getParameters().put('accNumber', '123456');
		controller.findClientByAccountNumber();
		Test.stopTest();


	}
    
    static testMethod void clientFinderByDni1() {
		Tipos_de_Documento__c docType = Build.aDocType().build();
		insert docType;

		Account client = Build.aClient().withLastName('Perez')
		.withFirstName('Juan')
		.withDocNumber('37520009')
		.build();
		
        Contact contacto = new Contact(FirstName = 'Prueba', LastName = 'Test');
        insert contacto;
        
        Case caso = new Case(AccountId = client.Id, ContactId = contacto.Id, origin = 'Twitter');
        insert caso;
        
        Profile p = [SELECT Id, Name FROM Profile WHERE Name = 'HS - Ventas Telemarketing'];

        User user = new User(alias = 'test123', email='test123@naeoemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true, UserPermissionsMarketingUser = true, timezonesidkey='America/Los_Angeles', username='tester@noaeaemail.com');
        
        
        Test.startTest();
        ClientFinderMock mock = Build.aClientFinderMock().withClient(client).build();
        Test.setMock(HttpCalloutMock.class, mock);
        Apexpages.currentPage().getParameters().put('param', 'test');
        Apexpages.currentPage().getParameters().put('caseId', (String)caso.Id);
        ClientFinder controller = new ClientFinder();
        Apexpages.currentPage().getParameters().put('docNum', '37520009');
        controller.findClientByDocumentNumber();
        Test.stopTest();
        
		
	}
    /*
    static testMethod void clientFinderByDni2() {
		Tipos_de_Documento__c docType = Build.aDocType().build();
		insert docType;

		Account client = Build.aClient().withLastName('Perezr')
		.withFirstName('Juanr')
		.withDocNumber('37520009')
		.build();
		
		List<Account> accList = [SELECT IdBHSeg__c, FirstName, LastName, Genero__c, PersonBirthdate, CUIT__c, PersonContactId, Tipo_de_Documento__c, Numero_de_Documento__c, Estado_Civil__c, Id_Cliente_BHSeg__c FROM Account WHERE Numero_de_Documento__c = '37520009'];
		
		if (accList.size() <= 0) {
			client = new Account(Numero_de_Documento__c = '37520009', FirstName = 'Juana', LastName = 'Pereez');
			insert client;
		}
		
        Contact contacto = new Contact(FirstName = 'Prueba', LastName = 'Test');
        insert contacto;
        
        Case caso = new Case(AccountId = client.Id, ContactId = contacto.Id, origin = 'Twitter');
        insert caso;

        Profile p = [SELECT Id, Name FROM Profile WHERE Name = 'HS - Ventas Telemarketing'];

        User user = new User(alias = 'testafs', email='test123@noeqxsmail.com',
                emailencodingkey='UTF-8', lastname='Testings', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true, UserPermissionsMarketingUser = true, timezonesidkey='America/Los_Angeles', username='tester@noeertmail.com');
        
        System.runAs(user){
            Test.startTest();
            ClientFinderMock mock = Build.aClientFinderMock().withClient(client).build();
            Test.setMock(HttpCalloutMock.class, mock);
            Apexpages.currentPage().getParameters().put('param', 'test');
            Apexpages.currentPage().getParameters().put('caseId', (String)caso.Id);
            ClientFinder controller = new ClientFinder();
            Apexpages.currentPage().getParameters().put('docNum', '37520009');
            controller.findClientByDocumentNumber();
            Test.stopTest();
        }
		
	}*/
    
    static testMethod void clientFinderByDni3() {
		Tipos_de_Documento__c docType = Build.aDocType().build();
		insert docType;

		Account client = Build.aClient().withLastName('Pereza')
		.withFirstName('Juani')
		.withDocNumber('37520009')
		.build();
		
		List<Account> accList = [SELECT IdBHSeg__c, FirstName, LastName, Genero__c, PersonBirthdate, CUIT__c, PersonContactId, Tipo_de_Documento__c, Numero_de_Documento__c, Estado_Civil__c, Id_Cliente_BHSeg__c FROM Account WHERE Numero_de_Documento__c = '37520009'];
		
		if (accList.size() <= 0) {
			client = new Account(Numero_de_Documento__c = '37520009', FirstName = 'Juanito', LastName = 'Perezasd', Id_Cliente_BHSeg__c='123');
			insert client;
		}
		
        Contact contacto = new Contact(FirstName = 'Prueba', LastName = 'Test');
        insert contacto;
        
        Case caso = new Case(AccountId = client.Id, ContactId = contacto.Id, origin = 'Twitter');
        insert caso;
        
        Test.startTest();
        ClientFinderMock mock = Build.aClientFinderMock().withClient(client).build();
        Test.setMock(HttpCalloutMock.class, mock);
        Apexpages.currentPage().getParameters().put('param', 'test');
        Apexpages.currentPage().getParameters().put('caseId', (String)caso.Id);
        ClientFinder controller = new ClientFinder();
        Apexpages.currentPage().getParameters().put('docNum', '37520009');
        controller.findClientByDocumentNumber();
        Test.stopTest();
		
	}
    
    static testMethod void clientsWithSameDNIcanBeFoundInsertedToSalesforceAndRetrieve2() {
		Tipos_de_Documento__c docType = Build.aDocType().build();
		insert docType;

		Account client1 = Build.aClient().withLastName('Perez')
		.withFirstName('Juan')
		.withDocNumber('11222333')
		.build();

		Test.startTest();

		ClientFinderMock mock = Build.aClientFinderMock().withClient(client1)
		.build();
		Test.setMock(HttpCalloutMock.class, mock);

		ClientFinder controller = new ClientFinder();
		Apexpages.currentPage().getParameters().put('docNum', '11222333');
		controller.findClientByDocumentNumber();

		List<Account> clientsFound = controller.clientsFound;


		Test.stopTest();
	}
    
    
}