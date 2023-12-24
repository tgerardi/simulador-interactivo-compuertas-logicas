/**
 * @description       :
 * @author            : Agustin Ignacio Martinez Bisagno
 * @group             : Xappia
 * @last modified on  : 10-15-2021
 * @last modified by  : agustin.martinez@globant.com
 **/
global without sharing class WebServiceGetProductosClientes extends HipotecarioGenericWebService {
    List<Poliza__c> products;
    List<Poliza__c> documents;
    String status;
    Integer statusCode;

    public Boolean getProductData(String personId) {
        products = new List<Poliza__c>();
        String requestStr =
            '<idcliente>' +
            personId +
            '</idcliente>' +
            //Clavadas
            '<fecvigdde>30/07/2007</fecvigdde>' +
            '<fecvighta>31/12/2030</fecvighta>' +
            //0 es ver por Poliza/certificado
            //1 ver por endoso
            '<detalle>0</detalle>' +
            //Clavados
            '<ramo>0</ramo>' +
            '<poliza>0</poliza>' +
            '<certificado>0</certificado>' +
            //0 descheckeado
            //1 checkeado
            '<vigente>0</vigente>' +
            //productor
            '<productor>0</productor>';

        HttpResponse response = WebServicesRequest.sendRequest('getProductosClientes', requestStr);

        statusCode = response.getStatusCode();
        status = response.getStatus();

        if (statusCode != 200) {
            return false;
        }

        system.debug(response.getBody().unescapeXml());

        Dom.Document doc = new Dom.Document();
        doc.load(response.getBody().unescapeXml());

        Dom.XMLNode root = doc.getRootElement();
        Dom.XMLNode service = root.getChildElement('getProductosClientes', 'http://tempuri.org/');
        if (service == null) {
            statusCode = 0;
            status = root.getText();
            return false;
        }
        Dom.XMLNode body = service.getChildElement('body', 'http://tempuri.org/');
        if (body == null) {
            return true;
        }
        Dom.XMLNode container = body.getChildElement('productos', 'http://tempuri.org/');

        if (container != null) {
            for (Dom.XMLNode child : container.getChildElements()) {
                // Read data from XML
                Poliza__c policy = new Poliza__c();

                policy.Estado__c = child.getChildElement('estado', 'http://tempuri.org/').getText();
                policy.Motivo_Endoso__c = child.getChildElement('dmotiv', 'http://tempuri.org/').getText();
                policy.Plan__c = child.getChildElement('dplan', 'http://tempuri.org/').getText();
                policy.Plan_IdBHSeg__c = child.getChildElement('PLAN', 'http://tempuri.org/').getText();
                policy.Producto_IdBHSeg__c = child.getChildElement('cprod', 'http://tempuri.org/').getText();
                policy.Producto__c = child.getChildElement('dprod', 'http://tempuri.org/').getText();
                policy.Ramo__c = child.getChildElement('dramo', 'http://tempuri.org/').getText();
                policy.Ramo_IdBHSeg__c = child.getChildElement('cramo', 'http://tempuri.org/').getText();
                policy.Empresa__c = child.getChildElement('dempresa', 'http://tempuri.org/').getText();
                policy.Tipo_Poliza__c = child.getChildElement('tipoPoliza', 'http://tempuri.org/').getText();

                if (child.getChildElement('tieneBeneficiario', 'http://tempuri.org/') != null) {
                    policy.Alerta_Designacion_de_Beneficiarios__c = child.getChildElement(
                                'tieneBeneficiario',
                                'http://tempuri.org/'
                            )
                            .getText() == 'F'
                        ? true
                        : false;
                }
                String mandatory = child.getChildElement('obligatorio', 'http://tempuri.org/').getText();
                if (mandatory == 'SI') {
                    policy.Optativa__c = false;
                } else if (mandatory == 'NO') {
                    policy.Optativa__c = true;
                }

                try {
                    policy.Endoso__c = Decimal.valueOf(
                        child.getChildElement('endoso', 'http://tempuri.org/').getText()
                    );
                } catch (System.TypeException ex) {
                }

                try {
                    policy.Certificado__c = Decimal.valueOf(
                        child.getChildElement('certif', 'http://tempuri.org/').getText()
                    );
                } catch (System.TypeException ex) {
                }

                try {
                    policy.Poliza__c = Decimal.valueOf(
                        child.getChildElement('poliza', 'http://tempuri.org/').getText()
                    );
                } catch (System.TypeException ex) {
                }

                try {
                    policy.Emision__c = Date.parse(
                        child.getChildElement('fe__emision', 'http://tempuri.org/').getText()
                    );
                } catch (System.TypeException ex) {
                }

                try {
                    policy.Desde__c = Date.parse(child.getChildElement('fe__vdesde', 'http://tempuri.org/').getText());
                } catch (System.TypeException ex) {
                }

                try {
                    policy.Hasta__c = Date.parse(child.getChildElement('fe__vhasta', 'http://tempuri.org/').getText());
                } catch (System.TypeException ex) {
                }

                try {
                    policy.Poliza_Anterior__c = Decimal.valueOf(
                        child.getChildElement('pol__ant', 'http://tempuri.org/').getText()
                    );
                } catch (System.TypeException ex) {
                }

                try {
                    policy.Premio__c = Decimal.valueOf(
                        child.getChildElement('premio', 'http://tempuri.org/').getText()
                    );
                } catch (System.TypeException ex) {
                }

                try {
                    policy.Suma_Asegurada__c = Decimal.valueOf(
                        child.getChildElement('suma__aseg', 'http://tempuri.org/').getText()
                    );
                } catch (System.TypeException ex) {
                }

                if (child.getChildElement('desc__medio__pago', 'http://tempuri.org/') != null) {
                    try {
                        policy.Medio_de_Pago__c = child.getChildElement('desc__medio__pago', 'http://tempuri.org/')
                            .getText();
                    } catch (System.TypeException ex) {
                    }
                }

                if (child.getChildElement('cod__medio__pago', 'http://tempuri.org/') != null) {
                    try {
                        policy.Medio_de_Pago_IdBHSeg__c = child.getChildElement(
                                'cod__medio__pago',
                                'http://tempuri.org/'
                            )
                            .getText();
                    } catch (System.TypeException ex) {
                    }
                }

                if (child.getChildElement('desc__origen__pago', 'http://tempuri.org/') != null) {
                    try {
                        policy.Origen_de_Pago__c = child.getChildElement('desc__origen__pago', 'http://tempuri.org/')
                            .getText();
                    } catch (System.TypeException ex) {
                    }
                }

                if (child.getChildElement('cod__origen__pago', 'http://tempuri.org/') != null) {
                    try {
                        policy.Origen_de_Pago_IdBHSeg__c = child.getChildElement(
                                'cod__origen__pago',
                                'http://tempuri.org/'
                            )
                            .getText();
                    } catch (System.TypeException ex) {
                    }
                }

                if (child.getChildElement('nro__cuenta__pago', 'http://tempuri.org/') != null) {
                    try {
                        policy.Cuenta_Pago__c = child.getChildElement('nro__cuenta__pago', 'http://tempuri.org/')
                            .getText();
                    } catch (System.TypeException ex) {
                    }
                }

                policy.Certificado_Id_BHSeg__c =
                    policy.Ramo_IdBHSeg__c +
                    '|' +
                    policy.Poliza__c.toPlainString() +
                    '|' +
                    policy.Certificado__c.toPlainString();

                if (child.getChildElement('nombreComercialProducto', 'http://tempuri.org/') != null) {
                    policy.Descripcion_Producto__c = child.getChildElement(
                            'nombreComercialProducto',
                            'http://tempuri.org/'
                        )
                        .getText();
                }
                policy.Productor_IdBHSeg__c = child.getChildElement('tomador', 'http://tempuri.org/').getText();
                Dom.XMLNode esAutogestion = child.getChildElement('esAutogestion', 'http://tempuri.org/');
                if (esAutogestion != null) {
                    policy.Autogestion__c = 'S'.equalsIgnoreCase(esAutogestion.getText());
                }

                policy.Asistencias_Extras__c = '';
                if (
                    'T'
                        .equalsIgnoreCase(
                            child.getChildElement('tieneAsistenciaINEBA', 'http://tempuri.org/')?.getText()
                        )
                ) {
                    policy.Asistencias_Extras__c = 'Telemedicina';
                }

                products.add(policy);
            }
        }

        return true;
    }

    public List<Poliza__c> getProducts() {
        return products;
    }

    public Integer getProductsCount() {
        return products.size();
    }

    public String getStatus() {
        return status;
    }

    public Integer getStatusCode() {
        return statusCode;
    }

    /** NEW LOGIC **/
    private final static Map<String, String> POLICY_TYPE = new Map<String, String>{
        'I' => 'Individual',
        'C' => 'Colectiva'
    };
    // ESTO DEBERIA SER UNA PARAMETRIA (Una CS personalizada que se va cargando si no encuenra el productor en la cs?¿)
    private final static Map<String, String> PRODUCER_CODE = new Map<String, String>{
        '414' => 'BANCO HIPOTECARIO',
        '416' => 'PROMER',
        '417' => 'BANCO DE CREDITO Y SECURITIZACION S.A.',
        '418' => 'BUSCONI',
        '419' => 'INSTITUTO PROVINCIAL LA PAMPA',
        '496' => 'BANCO HIPOTECARIO - CARDIF',
        '497' => 'TARSHOP S.A.',
        '499' => 'ASOCIACION GREMIAL DE EMPLEADOS DE COMERCIO - AGEC',
        '505' => 'PROCREAR-BCO.HIPOTECARIO S.A. FIDU.',
        '506' => 'PRICOOP COOP.DE CREDITO, CONSUMO, VIVIENDA Y SERV.SOC LTDA',
        '507' => 'COORDINAR COOP DE VIVIENDA, CREDITO, CONSUMO Y SERV SOC LTDA',
        '508' => 'Libertad S.A.',
        '509' => 'BHN SEGUROS GENERALES SA',
        '510' => 'AGL CAPITAL S.A',
        '511' => 'RADIO SAPIENZA S.A.',
        '516' => 'CRESUD S.A.C.I.F. Y A.',
        '531' => 'BHN VIDA S.A.',
        '532' => 'PARDO S.A.',
        '533' => 'DIAPIN S.A.',
        '534' => 'COMPARAENCASA S.A.',
        '536' => 'FOTA PRODUCTORES Y ASESORES DE SEGUROS SRL',
        '538' => 'MAP SOCIEDAD DE AVALES S.A'
    };

    private final static String NAMESPACE = 'http://tempuri.org/';

    private String salesforcePersonId { get; set; }
    private String personId { get; set; }
    private String vigenciaDesde { get; set; }
    private String vigenciaHasta { get; set; }
    private String detalle { get; set; } // 0 = ver por Poliza/Certificado || 1 = ver por endoso
    private String ramo { get; set; } // 0 = todas los ramos
    private String poliza { get; set; } // 0 = todas las polizas
    private String certificado { get; set; } // 0 = todos los certificados
    private String vigente { get; set; } // 0 = descheckeado || 1 = checkeado
    private String productor { get; set; } // 0 = todos los productores

    public WebServiceGetProductosClientes() {
        super(RectorMethods.GET_PRODUCTOS_CLIENTES);
        System.debug('WebServiceGetProductosClientes');
        this.serviceResponse = new GetProductosCLientesResponse(RectorMethods.GET_PRODUCTOS_CLIENTES);
        this.personId = '';
        this.salesforcePersonId = '';

        /* VALORES FIJOS, SETEARLOS NO CAMBIAN NADA */
        this.vigenciaDesde = '30/07/2007';
        this.vigenciaHasta = '31/12/2030';
        this.certificado = '0';
        this.productor = '0';
        this.detalle = '0';
        this.vigente = '0';
        this.poliza = '0';
        this.ramo = '0';
    }

    public Boolean getClientProductsByIdClienteBhSeg(String clientIdBhSeg) {
        this.personId = clientIdBhSeg;
        ((GetProductosClientesResponse) this.serviceResponse).clientIdBhSeg = this.personId;
        ((GetProductosClientesResponse) this.serviceResponse).clientIdSalesforce = this.salesforcePersonId;

        this.doCall();

        return !this.serviceResponse.hasError;
    }

    public override String createBodyString() {
        String params = '<idcliente>{0}</idcliente><fecvigdde>{1}</fecvigdde><fecvighta>{2}</fecvighta><detalle>{3}</detalle><ramo>{4}</ramo><poliza>{5}</poliza><certificado>{6}</certificado><vigente>{7}</vigente><productor>{8}</productor>';
        List<String> values = new List<String>{
            this.personId,
            this.vigenciaDesde,
            this.vigenciaHasta,
            this.detalle,
            this.ramo,
            this.poliza,
            this.certificado,
            this.vigente,
            this.productor
        };

        return String.format(params, values);
    }

    public void setClientId(String clientId) {
        this.salesforcePersonId = clientId;
    }

    public List<Poliza__c> getPolicies() {
        return ((GetProductosClientesResponse) this.serviceResponse).clientProductsByIdBhSeg.values();
    }

    public List<InsurancePolicy> getInsurancePolicies() {
        return ((GetProductosClientesResponse) this.serviceResponse).clientInsurancePoliciesByIdBhSeg.values();
    }

    public Map<String, Producer> getProducersByIdBhSeg() {
        return ((GetProductosClientesResponse) this.serviceResponse).producersByIdBhSeg;
    }

    public without sharing class GetProductosClientesResponse extends HipotecarioResult {
        public String clientIdBhSeg { get; set; }
        public String clientIdSalesforce { get; set; }
        public final Map<String, Poliza__c> clientProductsByIdBhSeg { get; private set; }
        public final Map<String, InsurancePolicy> clientInsurancePoliciesByIdBhSeg { get; private set; }
        public final Map<String, Producer> producersByIdBhSeg { get; private set; }
        private final String ID_BHSEG_PATTERN = '{0}|{1}|{2}|{3}|{4}';
        private final String UNIVERSAL_ID_PATTERN = '{0}|{1}|{2}|{3}';
        // public final List<FinServ__PolicyPaymentMethod__c> clientPoliciesPaymentMethod { get; private set; }

        public GetProductosClientesResponse(String method) {
            super(method);
            this.clientProductsByIdBhSeg = new Map<String, Poliza__c>();
            this.clientInsurancePoliciesByIdBhSeg = new Map<String, InsurancePolicy>();
            this.producersByIdBhSeg = new Map<String, Producer>();
        }

        public override void processGoodResponse(HttpResponse response) {
            try {
                Dom.XMLNode productsNode = XMLParser.getNode(
                    response.getBody().unescapeXml(),
                    RectorMethods.GET_PRODUCTOS_CLIENTES + '/body/productos'
                );

                if (productsNode != null) {
                    for (Dom.XMLNode product : productsNode.getChildElements()) {
                        this.parsePoliza(product);
                        this.parseInsurancePolicy(product);
                    }
                }
            } catch (Exception processException) {
                this.hasError = true;
                this.resultException = processException;
                this.message = processException.getMessage();
            }
        }

        private void parseInsurancePolicy(Dom.XMLNode product) {
            InsurancePolicy policy = new InsurancePolicy();

            /** DATOS DEL PRODUCTO **/
            /** Esto podria ser de Product2 */
            policy.Ramo_IdBHSeg__c = product.getChildElement('cramo', NAMESPACE).getText();
            policy.Producto_IdBHSeg__c = product.getChildElement('cprod', NAMESPACE).getText();
            policy.Plan_IdBHSeg__c = product.getChildElement('PLAN', NAMESPACE).getText();
            policy.Ramo__c = product.getChildElement('dramo', NAMESPACE).getText();
            policy.Producto__c = product.getChildElement('dprod', NAMESPACE).getText();
            policy.Plan__c = product.getChildElement('dplan', NAMESPACE).getText();

            /** DATOS BASICO DE LA POLIZA **/
            //Número de poliza
            policy.ReferencePolicyNumber = product.getChildElement('poliza', NAMESPACE).getText();
            policy.Certificado__c = this.parseToDecimal(product.getChildElement('certif', NAMESPACE)?.getText());
            policy.Endoso__c = this.parseToDecimal(product.getChildElement('endoso', NAMESPACE)?.getText());
            policy.PolicyType = POLICY_TYPE.get(product.getChildElement('tipoPoliza', NAMESPACE).getText());
            policy.NameInsuredId = this.clientIdSalesforce;
            policy.Status = product.getChildElement('estado', NAMESPACE).getText();
            policy.Name = policy.Producto__c + ' (N°' + policy.ReferencePolicyNumber + ')';
            policy.PolicyDescription =
                product.getChildElement('nombreComercialProducto', NAMESPACE)?.getText() +
                ' (' +
                policy.Ramo__c +
                '-' +
                policy.Plan__c +
                '), del ramo ' +
                policy.Producto__c;

            policy.ChangeSubtype = product.getChildElement('dmotiv', NAMESPACE).getText(); // Descripcion del motivo del endoso

            /** FECHAS **/
            policy.EffectiveDate = DateTimeUtils.parseToDate(
                product.getChildElement('fe__vdesde', NAMESPACE)?.getText()
            );
            policy.ExpirationDate = DateTimeUtils.parseToDate(
                product.getChildElement('fe__vhasta', NAMESPACE)?.getText()
            );
            policy.Fecha_Emision__C = DateTimeUtils.parseToDate(
                product.getChildElement('fe__emision', NAMESPACE)?.getText()
            ); // * Fecha de la operacion de creacion del endoso en rector (Alta, Refacuracion, etc.)

            /** DATOS PREMIO/SUMAS **/
            policy.PremiumAmount = this.parseToDecimal(product.getChildElement('premio', NAMESPACE)?.getText());
            policy.TotalSumInsured = this.parseToDecimal(product.getChildElement('suma__aseg', NAMESPACE)?.getText());

            /** DATOS EXTRAS **/
            policy.Autogestion__c = 'S'
                .equalsIgnoreCase(product.getChildElement('esAutogestion', NAMESPACE)?.getText());
            policy.Asistencias_Extras__c = '';
            if ('T'.equalsIgnoreCase(product.getChildElement('tieneAsistenciaINEBA', NAMESPACE)?.getText())) {
                policy.Asistencias_Extras__c = 'Telemedicina';
            }
            policy.Alerta_Designacion_de_Beneficiarios__c = 'F'
                .equalsIgnoreCase(product.getChildElement('tieneBeneficiario', NAMESPACE)?.getText());
            policy.Obligatoria__c = 'SI'.equalsIgnoreCase(product.getChildElement('obligatorio', NAMESPACE)?.getText());
            policy.Optativa__c = !policy.Obligatoria__c;
            policy.Empresa__c = product.getChildElement('dempresa', NAMESPACE).getText(); // * OBS: No deberia ser la Entidad Legal?

            /** IDENTIFICADORES UNICOS **/
            /** UniversalPolicyNumber y SourceSystemIdentifier, ambos sirven para hacer upsert
             ** UniversalPolicyNumber: Pensado para un nivel mas a nivel cliente (Solo se contempla datos del producto, nro de poliza y id de cliente)
             ** SourceSystemIdentifier: Pensado para un nivel mas gral (Ademas de los campos contemplados en UniversalPolicyNumber, se contempla nro de certificado)
             */
            policy.UniversalPolicyNumber = String.format(
                UNIVERSAL_ID_PATTERN,
                new List<Object>{
                    policy.Ramo_IdBHSeg__c,
                    policy.Producto_IdBHSeg__c,
                    policy.ReferencePolicyNumber,
                    this.clientIdBhSeg
                }
            );
            policy.SourceSystemIdentifier = String.format(
                ID_BHSEG_PATTERN,
                new List<Object>{
                    policy.Ramo_IdBHSeg__c,
                    policy.Producto_IdBHSeg__c,
                    policy.ReferencePolicyNumber,
                    policy.Certificado__c,
                    this.clientIdBhSeg
                }
            );

            /** DATOS POLIZA ANTERIOR **/
            policy.Poliza_Anterior__c = this.parseToDecimal(product.getChildElement('pol__ant', NAMESPACE)?.getText());

            // * Deberia relacionarse luego de que se upsertean los clientes o buscarse desde del clientretriever
            // policy.PriorPolicy = policy.Poliza_Anterior__c <
            //     0 // * OBS: ¿QUE PASARIA SI SE MIGRA LA POLIZA A UN NUEVO PRODUCTO?
            //     ? null
            //     : new InsurancePolicy(
            //         UniversalPolicyNumber = String.format(
            //             UNIVERSAL_ID_PATTERN,
            //             new List<Object>{
            //                 policy.Ramo_IdBHSeg__c,
            //                 policy.Producto_IdBHSeg__c,
            //                 policy.Poliza_Anterior__c,
            //                 this.clientIdBhSeg
            //             }
            //         )
            //     );

            /* DATOS PRODUCTOR */
            String producerCode = product.getChildElement('tomador', NAMESPACE)?.getText();
            if (String.isNotBlank(producerCode) && PRODUCER_CODE.containsKey(producerCode)) {
                Producer producer = this.producersByIdBhSeg.containsKey(producerCode)
                    ? this.producersByIdBhSeg.get(producerCode)
                    : this.producersByIdBhSeg.put(
                          producerCode,
                          new Producer(Name = PRODUCER_CODE.get(producerCode), Id_BhSeg__C = producerCode)
                      );
                policy.producer = producer;
            }

            /* DATOS DE MEDIO DE PAGO */
            policy.Medio_de_Pago__c = product.getChildElement('desc__medio__pago', NAMESPACE)?.getText();
            policy.Medio_de_Pago_IdBHSeg__c = product.getChildElement('cod__medio__pago', NAMESPACE)?.getText();
            policy.Origen_de_Pago__c = product.getChildElement('desc__origen__pago', NAMESPACE)?.getText();
            policy.Origen_de_Pago_IdBHSeg__c = product.getChildElement('cod__origen__pago', NAMESPACE)?.getText();
            policy.Cuenta_Pago__c = product.getChildElement('nro__cuenta__pago', NAMESPACE)?.getText();

            /**
             * * OBS: Para poder hacer esto se necesita que el cliente tenga cuenta financiera
             */
            // FinServ__PolicyPaymentMethod__c paymentMethod = new FinServ__PolicyPaymentMethod__c();
            // paymentMethod.Medio_de_Pago__c = product.getChildElement('desc__medio__pago', NAMESPACE)?.getText();
            // paymentMethod.Medio_de_Pago_IdBHSeg__c = product.getChildElement('cod__medio__pago', NAMESPACE)?.getText();
            // paymentMethod.Origen_de_Pago__c = product.getChildElement('desc__origen__pago', NAMESPACE)?.getText();
            // paymentMethod.Origen_de_Pago_IdBHSeg__c = product.getChildElement('cod__origen__pago', NAMESPACE)?.getText();
            // paymentMethod.Cuenta_Pago__c = product.getChildElement('nro__cuenta__pago', NAMESPACE)?.getText();
            // paymentMethod.Name = paymentMethod.Medio_de_Pago__c + ' ' + paymentMethod.Origen_de_Pago__c;
            // paymentMethod.FinServ__PaymentPercentage__c = 100.00;
            // paymentMethod.FinServ__InsurancePolicy__r = policy;
            // paymentMethod.FinServ__IsPrimaryAccount__c = true;
            // this.clientPoliciesPaymentMethod.add(paymentMethod);

            this.clientInsurancePoliciesByIdBhSeg.put(policy.UniversalPolicyNumber, policy);
        }

        private void parsePoliza(Dom.XMLNode product) {
            Poliza__c policy = new Poliza__c();
            policy.Producto_IdBHSeg__c = product.getChildElement('cprod', NAMESPACE).getText();
            policy.Motivo_Endoso__c = product.getChildElement('dmotiv', NAMESPACE).getText(); // Es la descripcion del motivo en base a la transaccion
            policy.Plan_IdBHSeg__c = product.getChildElement('PLAN', NAMESPACE).getText();
            policy.Ramo_IdBHSeg__c = product.getChildElement('cramo', NAMESPACE).getText();
            policy.Producto__c = product.getChildElement('dprod', NAMESPACE).getText();
            policy.Empresa__c = product.getChildElement('dempresa', NAMESPACE).getText();
            policy.Estado__c = product.getChildElement('estado', NAMESPACE).getText();
            policy.Ramo__c = product.getChildElement('dramo', NAMESPACE).getText();
            policy.Plan__c = product.getChildElement('dplan', NAMESPACE).getText();
            policy.Tipo_Poliza__c = product.getChildElement('tipoPoliza', NAMESPACE).getText();
            policy.Cuenta__c = this.clientIdSalesforce;
            String mandatory = product.getChildElement('obligatorio', NAMESPACE).getText();
            policy.Optativa__c = !'SI'.equalsIgnoreCase(mandatory);

            policy.Endoso__c = this.parseToDecimal(product.getChildElement('endoso', NAMESPACE)?.getText());
            policy.Certificado__c = this.parseToDecimal(product.getChildElement('certif', NAMESPACE)?.getText());
            policy.Poliza__c = this.parseToDecimal(product.getChildElement('poliza', NAMESPACE)?.getText());

            policy.Emision__c = DateTimeUtils.parseToDate(product.getChildElement('fe__emision', NAMESPACE)?.getText());
            policy.Desde__c = DateTimeUtils.parseToDate(product.getChildElement('fe__vdesde', NAMESPACE)?.getText());
            policy.Hasta__c = DateTimeUtils.parseToDate(product.getChildElement('fe__vhasta', NAMESPACE)?.getText());

            policy.Poliza_Anterior__c = this.parseToDecimal(product.getChildElement('pol__ant', NAMESPACE)?.getText());
            policy.Premio__c = this.parseToDecimal(product.getChildElement('premio', NAMESPACE)?.getText());
            policy.Suma_Asegurada__c = this.parseToDecimal(product.getChildElement('suma__aseg', NAMESPACE)?.getText());

            policy.Medio_de_Pago__c = product.getChildElement('desc__medio__pago', NAMESPACE)?.getText();
            policy.Medio_de_Pago_IdBHSeg__c = product.getChildElement('cod__medio__pago', NAMESPACE)?.getText();
            policy.Origen_de_Pago__c = product.getChildElement('desc__origen__pago', NAMESPACE)?.getText();
            policy.Origen_de_Pago_IdBHSeg__c = product.getChildElement('cod__origen__pago', NAMESPACE)?.getText();
            policy.Cuenta_Pago__c = product.getChildElement('nro__cuenta__pago', NAMESPACE)?.getText();

            policy.Certificado_Id_BHSeg__c =
                policy.Ramo_IdBHSeg__c +
                '|' +
                policy.Poliza__c.toPlainString() +
                '|' +
                policy.Certificado__c.toPlainString() +
                '|' +
                policy.Cuenta__c;

            policy.Id_BhSeg__c = String.format(
                ID_BHSEG_PATTERN,
                new List<Object>{
                    policy.Ramo_IdBHSeg__c,
                    policy.Producto_IdBHSeg__c,
                    policy.Poliza__c.toPlainString(),
                    policy.Certificado__c.toPlainString(),
                    this.clientIdBhSeg
                }
            );

            policy.Descripcion_Producto__c = product.getChildElement('nombreComercialProducto', NAMESPACE)?.getText();
            policy.Productor_IdBHSeg__c = product.getChildElement('tomador', NAMESPACE)?.getText();
            policy.Autogestion__c = 'S'
                .equalsIgnoreCase(product.getChildElement('esAutogestion', NAMESPACE)?.getText());
            policy.Alerta_Designacion_de_Beneficiarios__c = 'F'
                .equalsIgnoreCase(product.getChildElement('tieneBeneficiario', NAMESPACE)?.getText());

            policy.Asistencias_Extras__c = '';
            if ('T'.equalsIgnoreCase(product.getChildElement('tieneAsistenciaINEBA', NAMESPACE)?.getText())) {
                policy.Asistencias_Extras__c = 'Telemedicina';
            }

            this.clientProductsByIdBhSeg.put(policy.Id_BhSeg__c, policy);
        }

        // TODO: habria que pasarlo a un DecimalUtils
        private Decimal parseToDecimal(String decimalValue) {
            Decimal parsedValue;

            try {
                parsedValue = String.isNotBlank(decimalValue) ? Decimal.valueOf(decimalValue) : null;
            } catch (System.TypeException typeConversionException) {
                System.debug('Valor a Parsear: ' + decimalValue + '\nError: ' + typeConversionException.getMessage());
                parsedValue = null;
            }

            return parsedValue;
        }

        // Todo: faltaria ver si vale la pena hacer algo
        public override void processErrorResponse(HttpResponse response) {
            this.hasError = true;
            this.message = 'La conexion no ha sido exitosa.';
        }
    }
}