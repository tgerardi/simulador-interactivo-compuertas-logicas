/**
 * @description Clase que se encarga de consumir el servicio expuesto por core "getGeneroPolizaElectronica" el cual retorna el frente de poliza en base64.
 */
public class WebServiceDownloadPolicyPDF extends HipotecarioGenericWebService {
    private String ramo;
    private String poliza;
    private String certificado;
    private String endoso;
    private String cuit;
    private String policyBase64PDF;

    public WebServiceDownloadPolicyPDF() {
        super(RectorMethods.GET_GENERO_POLIZA_ELECTRONICA);
        this.ramo = '';
        this.poliza = '';
        this.certificado = '';
        this.endoso = '';
        this.cuit = '';
        this.serviceResponse = new Response(RectorMethods.GET_GENERO_POLIZA_ELECTRONICA);
        this.policyBase64PDF = '';
    }

    /**
     * @description Realiza el llamado a Rector para traer el base64.
     * Recibe codigo de ramo, numero de poliza, certificado y el endoso.
     */
    public Boolean downloadPDF(String ramo, String polNum, String cert, String endoso, String cuit) {
        return this.downloadPDF(ramo, polNum, cert, endoso, cuit, '0');
    }

    /**
     * @description Realiza el llamado a Rector para traer el base64.
     * Recibe codigo de ramo, numero de poliza, certificado, el endoso y el id de proceso.
     */
    private Boolean downloadPDF(String ramo, String polNum, String cert, String endoso, String cuit, String idProcess) {
        this.ramo = ramo;
        this.poliza = polNum;
        this.certificado = cert;
        this.endoso = endoso;
        this.cuit = cuit;
        this.doCall();

        return !this.serviceResponse.hasError;
    }

    public String getPolicyData() {
        return ((Response) this.serviceResponse).policyBase64PDF; //policyBase64PDF;
    }

    public void generateLog(Boolean asyncCreation) {
        final Map<MapLogArgKey, Object> ARGS = new Map<MapLogArgKey, Object>{
            MapLogArgKey.CLASSINFO => 'WebServiceDownloadPolicyPDF',
            MapLogArgKey.REQUEST_METHOD => RectorMethods.GET_GENERO_POLIZA_ELECTRONICA,
            MapLogArgKey.REQUESTINFO => this.serviceResponse.request,
            MapLogArgKey.RESPONSEINFO => this.serviceResponse.response
        };

        ARGS.put(asyncCreation ? MapLogArgKey.ASYNC_APEX_LOG : MapLogArgKey.SYNC_APEX_LOG, true);

        if (this.serviceResponse.resultException != null) {
            ARGS.put(MapLogArgKey.EXCEPTIONINFO, this.serviceResponse.resultException);
        }
        CreateApexLog.create(ARGS);
    }

    public override String createBodyString() {
        return String.format(
            '<ramo>{0}</ramo>' +
            '<poliza>{1}</poliza>' +
            '<certificado>{2}</certificado>' +
            '<endoso>{3}</endoso>' +
            '<cuit>{4}</cuit>',
            new List<String>{ this.ramo, this.poliza, this.certificado, this.endoso, this.cuit }
        );
    }

    public inherited sharing class Response extends HipotecarioResult {
        public String policyBase64PDF { get; private set; }

        public Response(String method) {
            super(method+'Request');
            this.policyBase64PDF = '';
        }

        public override void processGoodResponse(HttpResponse response) {
            this.hasError = false;

            try {
                this.policyBase64PDF = XMLParser.getNode(
                        response.getBody().unescapeXml(),
                        this.calledService + '/body/polizaElectronica/archivo'
                    )
                    ?.getText();
            } catch (Exception processResponseException) {
                System.debug(
                    LoggingLevel.ERROR,
                    'Ocurrio un error al procesar la respuesta: ' + processResponseException.getMessage()
                );
                this.hasError = true;
                this.resultException = processResponseException;
                this.message = processResponseException.getMessage();
            }
        }

        public override void processErrorResponse(HttpResponse response) {
            this.hasError = true;
            final String body = response.getBody().unescapeXml();
            final String resultString = XMLParser.getNode(body, this.calledService + '/header/resultString')?.getText();
            final String resultCode = XMLParser.getNode(body, this.calledService + '/header/resultCode')?.getText();

            this.message =
                (String.isNotBlank(resultCode) ? 'Codigo: ' + resultCode + '. ' : '') +
                (String.isNotBlank(resultString) ? resultString : '');
            this.message = String.isNotBlank(this.message) ? this.message : 'Ocurrio un error inesperado';
        }
    }
}