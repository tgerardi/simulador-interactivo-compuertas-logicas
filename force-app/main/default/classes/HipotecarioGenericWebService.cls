public inherited sharing virtual class HipotecarioGenericWebService {
    //*}========================================================================================================{*//
    //*}===========================================[STATIC VARIABLES]==========================================={*//
    //*}========================================================================================================{*//
    private static final Map<String, Object> CONFIG_VALUES = new Map<String, Object>{
        'requestBody' => '',
        'paramName' => 'requestXml',
        'endpointName' => '',
        'idProcess' => '0',
        'shouldChangeOperator' => false,
        'Content-Type' => 'application/x-www-form-urlencoded',
        'idSession' => '1234',
        'channel' => 'SEG',
        'user' => 'B30044',
        'userChannel' => '',
        'branch' => '0',
        'subChannelOne' => 'Libertad',
        'subChannelTwo' => '',
        'primitiveChannel' => '',
        'branchTas' => '0',
        'operator' => 'B30044',
        'userIP' => ''
    };

    //*}======================================================================================================={*//
    //*}==============================================[VARIABLES]=============================================={*//
    //*}======================================================================================================={*//
    private final Boolean shouldChangeOperator { get; set; }
    protected String requestMethod { get; set; }
    private final String endpointName { get; set; }
    private final String requestBody { get; set; }
    private final String paramName { get; set; }
    private final String idProcess { get; set; }

    public WSResult serviceResponse { get; set; }

    //*}======================================================================================================={*//
    //*}==============================================[CLASS METHODS]=========================================={*//
    //*}======================================================================================================={*//
    public static HipotecarioGenericWebService sendRequest(String requestMethod) {
        return HipotecarioGenericWebService.doCall(
            requestMethod,
            (String) CONFIG_VALUES.get('requestBody'),
            (String) CONFIG_VALUES.get('paramName'),
            (String) CONFIG_VALUES.get('endpointName'),
            (String) CONFIG_VALUES.get('idProcess'),
            (Boolean) CONFIG_VALUES.get('shouldChangeOperator')
        );
    }

    public static HipotecarioGenericWebService sendRequest(String requestMethod, String requestBody) {
        return HipotecarioGenericWebService.doCall(
            requestMethod,
            requestBody,
            (String) CONFIG_VALUES.get('paramName'),
            (String) CONFIG_VALUES.get('endpointName'),
            (String) CONFIG_VALUES.get('idProcess'),
            (Boolean) CONFIG_VALUES.get('shouldChangeOperator')
        );
    }

    public static HipotecarioGenericWebService sendRequest(
        String requestMethod,
        String requestBody,
        Boolean shouldChangeOperator
    ) {
        return HipotecarioGenericWebService.doCall(
            requestMethod,
            requestBody,
            (String) CONFIG_VALUES.get('paramName'),
            (String) CONFIG_VALUES.get('endpointName'),
            (String) CONFIG_VALUES.get('idProcess'),
            shouldChangeOperator
        );
    }

    public static HipotecarioGenericWebService sendRequest(
        String requestMethod,
        String requestBody,
        String paramName,
        String endpointName
    ) {
        return HipotecarioGenericWebService.doCall(
            requestMethod,
            requestBody,
            paramName,
            endpointName,
            (String) CONFIG_VALUES.get('idProcess'),
            (Boolean) CONFIG_VALUES.get('shouldChangeOperator')
        );
    }

    public static HipotecarioGenericWebService sendRequest(
        String requestMethod,
        String requestBody,
        String paramName,
        String endpointName,
        String idProcess
    ) {
        return HipotecarioGenericWebService.doCall(
            requestMethod,
            requestBody,
            paramName,
            endpointName,
            idProcess,
            (Boolean) CONFIG_VALUES.get('shouldChangeOperator')
        );
    }

    public static HipotecarioGenericWebService sendRequest(
        String requestMethod,
        String requestBody,
        String paramName,
        String endpointName,
        String idProcess,
        Boolean shouldChangeOperator
    ) {
        return HipotecarioGenericWebService.doCall(
            requestMethod,
            requestBody,
            paramName,
            endpointName,
            idProcess,
            shouldChangeOperator
        );
    }

    private static HipotecarioGenericWebService doCall(
        String requestMethod,
        String requestBody,
        String paramName,
        String endpointName,
        String idProcess,
        Boolean shouldChangeOperator
    ) {
        HipotecarioGenericWebService service = new HipotecarioGenericWebService(
            requestMethod,
            requestBody,
            paramName,
            endpointName,
            idProcess,
            shouldChangeOperator
        );
        service.doCall();
        return service;
    }

    //*}======================================================================================================={*//
    //*}==============================================[INSTANCE METHODS]======================================={*//
    //*}======================================================================================================={*//
    private HipotecarioGenericWebService(
        String requestMethod,
        String requestBody,
        String paramName,
        String endpointName,
        String idProcess,
        Boolean shouldChangeOperator
    ) {
        this.requestMethod = requestMethod;
        this.requestBody = requestBody;
        this.paramName = paramName;
        this.endpointName = endpointName;
        this.idProcess = idProcess;
        this.shouldChangeOperator = shouldChangeOperator;
    }

    public HipotecarioGenericWebService(String requestMethod) {
        this(
            requestMethod,
            (String) CONFIG_VALUES.get('requestBody'),
            (String) CONFIG_VALUES.get('paramName'),
            (String) CONFIG_VALUES.get('endpointName'),
            (String) CONFIG_VALUES.get('idProcess'),
            (Boolean) CONFIG_VALUES.get('shouldChangeOperator')
        );
    }

    public void doCall() {
        try {
            String bodyString = this.makeBody();

            RestWS restServicesCaller = new RestWS(
                this.getEndpoint(),
                'POST',
                null,
                this.getBody(bodyString),
                this.getHeaders(bodyString)
            );
            this.serviceResponse = restServicesCaller.invoke(this.serviceResponse);
        } catch (Exception executionException) {
            this.serviceResponse.hasError = true;
            this.serviceResponse.resultException = executionException;
            this.serviceResponse.message = executionException.getMessage();
        }
    }

    private WSParameter getBody(String bodyString) {
        return new WSParameter('body', this.paramName + '=' + bodyString, true, false);
    }

    private WSParameter[] getHeaders(String bodyString) {
        return new List<WSParameter>{
            new WSParameter('Content-Type', (String) CONFIG_VALUES.get('Content-Type'), true, false),
            new WSParameter('Content-Length', String.valueOf(bodyString.length()), true, false) /*,
             new WSParameter('Host', endpoint.Host__c, true, false)*/ //Obs: test if host is auto populated in named credentials
        };
    }

    @TestVisible
    private String getEndpoint() {
        String socketPlusPath = '/BHSWebService/BHSSonicService.asmx/ConsultaSonic';

        // if ([SELECT isSandbox FROM Organization LIMIT 1].isSandbox) {
        //     return 'callout:Hipotecario_Homologacion' + socketPlusPath;
        // } else {
        //     return 'callout:Hipotecario_Produccion' + socketPlusPath;
        // }
        return EndpointResolver.getEndpoint('callout:Hipotecario_Homologacion', 'callout:Hipotecario_Produccion') +
            socketPlusPath;
    }

    private String makeBody() {
        XmlStreamWriter writer = new XmlStreamWriter();
        writer.writeStartElement(null, requestMethod, null);

        // HEADER
        writer.writeStartElement(null, 'header', null);
        this.writeNode(writer, 'idSession', (String) CONFIG_VALUES.get('idSession'));
        this.writeNode(
            writer,
            'idProcess',
            this.idProcess != null ? this.idProcess : (String) CONFIG_VALUES.get('idProcess')
        );
        this.writeNode(writer, 'startTime', Datetime.now().format('yyyy-MM-ddHH:mm:ss'));
        this.writeNode(writer, 'channel', (String) CONFIG_VALUES.get('channel'));
        this.writeNode(writer, 'user', (String) CONFIG_VALUES.get('user'));
        this.writeNode(writer, 'userChannel', (String) CONFIG_VALUES.get('userChannel'));
        this.writeNode(writer, 'branch', (String) CONFIG_VALUES.get('branch'));
        this.writeNode(writer, 'subChannelOne', (String) CONFIG_VALUES.get('subChannelOne'));
        this.writeNode(writer, 'subChannelTwo', (String) CONFIG_VALUES.get('subChannelTwo'));
        this.writeNode(writer, 'primitiveChannel', (String) CONFIG_VALUES.get('primitiveChannel'));
        this.writeNode(writer, 'branchTas', (String) CONFIG_VALUES.get('branchTas'));
        this.writeNode(writer, 'operator', this.shouldChangeOperator ? (String) CONFIG_VALUES.get('operator') : '');
        this.writeNode(writer, 'userIP', (String) CONFIG_VALUES.get('userIP'));
        writer.writeEndElement();

        // BODY
        this.writeNode(writer, 'body', '@@BODY@@');
        writer.writeEndElement();

        String requestStr = writer.getXmlString();
        writer.close();

        return requestStr.replace(
            '@@BODY@@',
            String.isNotBlank(requestBody) ? requestBody : this.createBodyString().unescapeXML()
        );
    }
    // Todo: vale la pena crear una clase xml writer?
    private void writeNode(XmlStreamWriter writer, String tagName, String value) {
        writer.writeStartElement(null, tagName, null);
        writer.writeCharacters(value);
        writer.writeEndElement();
    }

    public virtual String createBodyString() {
        /*WILL BE OVERRIDE WITH THE SUBCLASS*/
        Exceptions.throwNotImplementedException('createBodyString()', this);
        return '';
    }

    public void createApexLog() {
        if(this.serviceResponse.hasError){
            CreateApexLog.create(
                new Map<MapLogArgKey, Object>{
                    MapLogArgKey.EXCEPTIONINFO => this.serviceResponse.resultException,
                    MapLogArgKey.REQUESTINFO => this.serviceResponse.request,
                    MapLogArgKey.RESPONSEINFO => this.serviceResponse.response
                }
            );
        }
    }
}