Account client = new Account(            
    IdBHSeg__c = '183262',
    FirstName = 'MARTIN GABRIEL',
    LastName = 'NASCARELLA',
    Genero__c = 'Masculino',
    PersonBirthdate = date.valueOf('1975-02-26'),
    Tipo_de_Documento__c = 'D.N.I.',
    CUIT__c = '20243233616',
    Id_Cliente_BHSeg__c = '170514',
    Numero_de_Documento__c = '24323361'
);

User u = new User(
    Alias = 'standt',
    Email = 'testHipo@testHipo.com',
    EmailEncodingKey = 'UTF-8',
    LastName = 'testHipo',
    LanguageLocaleKey = 'en_US',
    LocaleSidKey = 'en_US',
    ProfileId = p.Id,
    TimeZoneSidKey = 'America/Los_Angeles',
    UserName = 'testHipo@testHipo.com'
);

INSERT new MessagingSession(
    Asunto__c = 'BAJA',
    Camino_Tomado__c = 'Otras_Consultas',
    MessagingChannelId = new MessagingChannelId(),
    LeadId = new Lead(),
    CaseId = new Caso(),
    ChannelKey = 'whatsapp:+5491123646994',
    Contactar_Agente__c = true,
    EndUserContactId = new Contact(),
    CreatedById = u.Id,
    Cuenta__c = client.Id,
    EndUserAccountId = client.Id,
    PreviewDetails = 'whatsapp:+5493435207260 | Hipotecario Seguros WA | WhatsApp',
    Status = 'Ended',
    CreatedDate = '2023-10-04T12:31:30.000+0000',
    LastModifiedDate = '2023-10-04T12:42:24.000+0000',
    EndTime = '2023-10-04T12:42:24.000+0000',
    AcceptTime = '2023-10-04T12:34:50.000+0000',
    StartTime = '2023-10-04T12:31:29.000+0000',
    ChannelName = 'Hipotecario Seguros WA',
    AgentMessageCount = 5,
    EndUserMessageCount = 6,
    ChannelType = 'WhatsApp',
    LastModifiedById = u.Id,
    AgentType = 'BotToAgent'
);