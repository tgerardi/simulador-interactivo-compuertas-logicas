/**
 * @description       :
 * @author            : Victor M. Degano
 * @group             : Globant
 * @affected jiras    :
 * @last modified on  : 08-08-2023
 * @last modified by  : Victor M. Degano
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   08-08-2023   Victor M. Degano   Initial Version
 **/
public without sharing class AG_CampaingsADD {
    @TestVisible
    private static final string LEGAL_CANCELLATION = 'Resolución 271/2020-. BAJA DE SERVICIOS. Artículo 10 ter de la Ley N° 24.240';
    @TestVisible
    private static final string LEGAL_REVISION = 'Resolución 424/2020- BOTON DE ARREPENTIMIENTO. Artículos 34 de la Ley N° 24.240 y 1.110 del Código Civil y Comercial de la Nación.';
    @TestVisible
    private static final string INVALID_PHONE = 'No se encontró coincidencia con la característica ingresada.</br>Intente nuevamente o comuníquese al <strong style="color:#02b5d3;">0810-666-0066</strong> de <b>Lunes a Viernes de 8 a 20 horas</b>. ¡Gracias!';
    @TestVisible
    private static final String POLICY_WITH_REQUEST = 'La póliza seleccionada ya posee una gestión de {0} en curso. Dentro de las próximas 72hs hábiles estará confirmada.';
    @TestVisible
    private static final String POLICY_WITH_APPLICATION = 'Ya existe una solicitud en curso para esta póliza, en breve nos estaremos comunicando con vos para confirmarla.';
    @TestVisible
    private static final String DELETE_CONTACT_ERROR = '¡Disculpas! No pudimos procesar tu solicitud. Por favor comunicate al <strong style="color:#02b5d3;">0810-666-0066</strong> de <b>Lunes a Viernes de 8 a 20 horas</b>. ¡Gracias!';
    @TestVisible
    private static final String APPLICATION_ACCEPTED = 'En las próximas {0}hs. hábiles nos estaremos comunicando con vos para finalizar tu solicitud.';

    @InvocableMethod
    public static List<SolicitudCampaignResponse> addCampaignMember(List<List<String>> params) {
        List<SolicitudCampaignResponse> response;
        try {
            final List<String> ACTION_PARAMETERS = params[0];
            final String POLICY_ID = ACTION_PARAMETERS[2];
            final String PHONE3 = ACTION_PARAMETERS[3];
            final String AREA_CODE = ACTION_PARAMETERS[4];

            Poliza__c policy = getPolicy(POLICY_ID);
            String requestType = getRequestType(policy);
            String campaignType = getCampaignType(policy);

            if (!Validate.phoneNumberEnacom(AREA_CODE, PHONE3)) {
                return createResponse(requestType, INVALID_PHONE);
            }

            if (GestionHelper.hasConfirmedCancellationRequestForPolicy(POLICY_ID)) {
                return createResponse(requestType, String.format(POLICY_WITH_REQUEST, new List<String>{ requestType }));
            }
            return processApplication(policy, getCampaign(campaignType), ACTION_PARAMETERS, requestType);
        } catch (Exception e) {
            CreateApexLog.create(new Map<MapLogArgKey, Object>{ MapLogArgKey.EXCEPTIONINFO => e });
            response = createResponse('Arrepentimiento/Baja', DELETE_CONTACT_ERROR); // We use it for unexpected errors too
        }

        return response;
    }

    private static List<SolicitudCampaignResponse> processApplication(
        Poliza__c policy,
        Campaign campaign,
        final List<String> ACTION_PARAMETERS,
        String requestType
    ) {
        final Id CONTACT_ID = ACTION_PARAMETERS[0];
        final String OBSERVATIONS = ACTION_PARAMETERS[1];
        final String POLICY_ID = ACTION_PARAMETERS[2];
        final String PHONE_3 = '0' + ACTION_PARAMETERS[4] + '15' + ACTION_PARAMETERS[3];

        List<CampaignMember> campaignMembers = getCampaignMember(CONTACT_ID, campaign);

        String observationsToImpact = OBSERVATIONS + (' (' + requestType + ')'); //se le agrega entre () el tipo de gestion a las observations
        String policyId = POLICY_ID + '|';

        CampaignMember memberToApplicate = campaignMembers.isEmpty()
            ? new CampaignMember(
                CampaignId = campaign.Id,
                ContactId = CONTACT_ID,
                observaciones__c = observationsToImpact,
                Polizas_para_Baja__c = policyId
            )
            : campaignMembers[0];

        // existe el miembro y no tiene baja confirmada. puede haber o no solicitud
        if (!campaignMembers.isEmpty() && hasConfirmedOrPendingApplication(memberToApplicate, POLICY_ID)) {
            return createResponse(requestType, String.format(POLICY_WITH_APPLICATION, new List<String>{ requestType }));
        }

        if (!campaignMembers.isEmpty() && !deleteGenesysContact(campaign, campaignMembers[0].Id)) {
            return createResponse(requestType, DELETE_CONTACT_ERROR);
        }

        // Esto es por que PureCLoud sincroniza al haber un cambio en el campo y si ya esta en falso no  va a resincronizar.
        if (memberToApplicate.Id != null && !memberToApplicate.purecloud__Synced_to_PureCloud__c) {
            memberToApplicate.purecloud__Synced_to_PureCloud__c = true;
            update memberToApplicate;
        }
        System.debug(memberToApplicate);
        memberToApplicate.Datetime_Arrepentimientos__c = String.valueOf(System.now());
        memberToApplicate.purecloud__Synced_to_PureCloud__c = false;
        memberToApplicate.Telefono_3__c = PHONE_3;
        memberToApplicate.Confirmar_Baja__c = false;

        updateCampaignMemberAccount(CONTACT_ID, PHONE_3, requestType);

        upsert memberToApplicate;

        Seguimiento__c trackingApplication = new Seguimiento__c(
            observaciones__c = observationsToImpact,
            Contacto__c = CONTACT_ID,
            Poliza__c = policy.Id,
            Campania__c = campaign.Id,
            Seg__c = policy.Ramo_IdBHSeg__c + '|' + policy.Producto_IdBHSeg__c + '|' + policy.Poliza__c,
            Tipo__c = requestType,
            Estado__C = 'Pendiente'
        );
        insert trackingApplication;

        return successResponse(requestType);
    }

    private static Campaign getCampaign(String campaignType) {
        String campaignName = [SELECT Label FROM Campaign__mdt WHERE DeveloperName = :campaignType].Label;
        return [SELECT Id, purecloud__PureCloud_Contact_List_ID__c FROM Campaign WHERE Name = :campaignName];
    }

    private static List<CampaignMember> getCampaignMember(String contactId, Campaign campaign) {
        return [
            SELECT
                Id,
                observaciones__c,
                Polizas_para_Baja__c,
                purecloud__Synced_to_PureCloud__c,
                Telefono_3__c,
                Datetime_Arrepentimientos__c,
                CreatedDate,
                CampaignId
            FROM CampaignMember
            WHERE ContactId = :contactId AND CampaignId = :campaign.Id
            LIMIT 1
        ];
    }

    private static String getCampaignType(Poliza__c policy) {
        return PolicyHelper.isNewPolicyWithLessEqualsDaysThan(policy, 10)
            ? 'AG_Solicitud_Arrepentimiento'
            : 'AG_Solicitud_Baja';
    }

    private static String getRequestType(Poliza__c policy) {
        return PolicyHelper.isNewPolicyWithLessEqualsDaysThan(policy, 10) ? 'Arrepentimiento' : 'Baja';
    }

    private static Poliza__c getPolicy(String policyId) {
        return [
            SELECT id, Desde__c, Tipo_Endoso_IdBHSeg__c, Ramo_IdBHSeg__c, Producto_IdBHSeg__c, Poliza__c
            FROM Poliza__c
            WHERE Id = :policyId
        ];
    }

    private static List<SolicitudCampaignResponse> createResponse(String requestType, String message) {
        return new List<SolicitudCampaignResponse>{ new SolicitudCampaignResponse(requestType, message) };
    }

    private static Boolean hasConfirmedOrPendingApplication(CampaignMember existingCampaignMember, String policyId) {
        List<Seguimiento__c> pendingApplications = [
            SELECT id
            FROM Seguimiento__c
            WHERE Poliza__c = :policyId AND Estado__C = 'Pendiente' AND Tipo__c IN ('Arrepentimiento', 'Baja')
        ];

        return !pendingApplications.isEmpty();
    }

    private static void updateCampaignMemberAccount(String contactId, String phone_3, String requestType) {
        Account account = [
            SELECT Id, Solicitud_de_Baja_Activa__c, Solicitud_de_Arrepentimiento_Activa__c, Telefono_3__c
            FROM Account
            WHERE personContactId = :contactId
        ];

        switch on requestType {
            when 'Baja' {
                account.Solicitud_de_Baja_Activa__c = true;
            }
            when 'Arrepentimiento' {
                account.Solicitud_de_Arrepentimiento_Activa__c = true;
            }
        }

        account.Telefono_3__c = phone_3;
        update account;
    }

    private static Boolean isDesaxappia() {
        System.Domain sfDomain = DomainParser.parse(URL.getOrgDomainUrl());

        return 'desaxappia'.equalsIgnoreCase(sfDomain.getSandboxName());
    }

    public static Boolean deleteGenesysContact(Campaign campaign, final String CONTACT_ID) {
        if (
            EndpointResolver.isSandbox() &&
        // [SELECT IsSandbox FROM Organization LIMIT 1]
            // .IsSandbox && // Para desaintegr y homo
            //!isDesaxappia() &&
            !Test.isRunningTest()
        ) {
            return true;
        }

        GenesysLoginWebService wsLogin = new GenesysLoginWebService();
        if (!wsLogin.getAccessToken()) {
            return false;
        }

        GenesysDeleteContactsWebService deleteService = new GenesysDeleteContactsWebService();

        return deleteService.deleteContact(
                Test.isRunningTest()
                    ? CalloutResponseFactory.GENESYS_PURECLUD_ID
                    : campaign.purecloud__PureCloud_Contact_List_ID__c,
                CONTACT_ID,
                wsLogin.token
            ) || 'contact.not.found'.equalsIgnoreCase(deleteService.getCode());
    }

    private static List<SolicitudCampaignResponse> successResponse(String campaignType) {
        String horas;
        String legalMessage;

        switch on campaignType.toLowerCase() {
            when 'baja' {
                horas = '72';
                legalMessage = LEGAL_CANCELLATION;
            }
            when 'arrepentimiento' {
                horas = '24';
                legalMessage = LEGAL_REVISION;
            }
            when else {
                horas = '';
                legalMessage = '';
            }
        }

        return new List<SolicitudCampaignResponse>{
            new SolicitudCampaignResponse(
                campaignType,
                String.format(APPLICATION_ACCEPTED, new List<String>{ horas, legalMessage }),
                legalMessage,
                true
            )
        };
    }

    public class SolicitudCampaignResponse {
        @InvocableVariable
        public String campaignType;

        @InvocableVariable
        public String message;

        @InvocableVariable
        public String legalMessage;

        @InvocableVariable
        public Boolean success;

        public SolicitudCampaignResponse(String campaignType, String message, String legalMessage, Boolean success) {
            this.campaignType = campaignType;
            this.message = message;
            this.success = success;
            this.legalMessage = legalMessage;
        }

        public SolicitudCampaignResponse(String campaignType, String message) {
            this.campaignType = campaignType;
            this.message = message;
            this.success = false;
            this.legalMessage = '';
        }
    }
}