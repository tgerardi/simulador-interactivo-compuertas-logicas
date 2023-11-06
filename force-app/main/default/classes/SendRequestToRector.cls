/**
 * @description       :
 * @author            : Agustin Ignacio Martinez Bisagno
 * @group             : Xappia
 * @last modified on  : 03-19-2021
 * @last modified by  : agustin.martinez@xappia.com
 * Modifications Log
 * Ver   Date         Author                        Modification
 * 1.0   01-28-2021   agustin.martinez@xappia.com   Initial Version
 **/
global class SendRequestToRector {
    public static String upperCasedActiveDirectory;

    /*-----------------------------------------------------------------------------------*/
    /*-----------------------------[PRODUCTO VENDIDO INICIO]-----------------------------*/
    /*-----------------------------------------------------------------------------------*/

    @Future(callout=true)
    global static void sendSellFuture(String reqId) {
        sendSell(reqId);
    }

    @AuraEnabled
    global static String sendRequest(String recordId, String apiName) {
        Boolean hasError = false;
        String result = 'Successful';
        Boolean resultSendClaim = false;
        Integer numero = -1;
        try {
            switch on apiName.toLowerCase() {
                when 'gestion__c' {
                    sendRequest(recordId);
                    numero = [SELECT Numero__c FROM Gestion__C WHERE Id = :recordId]?.Numero__c?.intValue();
                }
                when 'producto_vendido__c' {
                    sendSell(recordId);
                    numero = [SELECT Numero__c FROM Producto_Vendido__c WHERE Id = :recordId]?.Numero__c?.intValue();
                }
                when 'claim' {
                    resultSendClaim = sendClaim(recordId);
                    if(resultSendClaim){
                        numero = [SELECT Numerador__c FROM Claim WHERE Id = :recordId]?.Numerador__c?.intValue();
                    }
                }
                when else {
                    System.debug(LoggingLevel.INFO, 'No Method For Object: ' + apiName);
                    Exceptions.throwAuraHandledException('Objeto no habilitado para el reenvio.');
                }
            }
        } catch (Exception aHandledException) {
            Exceptions.throwAuraHandledException(aHandledException.getMessage());
        }
        hasError = numero == null || numero <= 0;
        if(apiName.toLowerCase() == 'claim'){
            result = hasError ? 'No se pudo enviar: faltan campos obligatorios' : result;
        }else{
            result = hasError ? 'No se pudo enviar' : result;
        }
        

        JSONGenerator responseJson = JSON.createGenerator(false);
        responseJson.writeStartObject();
        responseJson.writeBooleanField('hasError', hasError);
        responseJson.writeStringField('message', result);
        responseJson.writeNumberField('number', hasError ? -1 : numero);
        responseJson.writeEndObject();

        return responseJson.getAsString();
    } 
    
    global static void sendSell(String reqId) {
        System.debug('reqId: ' + reqId);
        Producto_Vendido__c prod = QueryUtils.getSoldProductForSendToRector(reqId);

        prod.Intentos_de_Envio__C += 1;
        try {
            generateAndSendSale(prod);
        } catch (Exception e) {
            prod.Intentos_de_Envio_Fallidos__c += 1;
            prod.Estado_Comunicacion_Rector__c = 'Fallida';
        }

        update prod;
    }

    public static void generateAndSendSale(Producto_Vendido__c prod) {
        String test = '';
        prod.Observacion__c = '';
        if ('No_Venta'.equalsIgnoreCase(prod.RecordType.DeveloperName)) {
            test = 'primer';
            SendRequestToRector.sendNoVenta(GenerateRequestToSend.sendNoVenta(prod), prod);
        } else if (String.isNotBlank(prod.Source__c) && prod.Source__c.equalsIgnoreCase('Portal-ventas')) {
            test = 'segundo';
            SendRequestToRector.sendVentaWeb(GenerateRequestToSend.sendVentaWeb(prod), prod);
        } else {
            test = 'tercero';
            SendRequestToRector.sendVenta(GenerateRequestToSend.sendVenta(prod), prod);
        }
    }

    //TODO. podria deprecarse, ademas es el mismo metodo que sendVenta
    public static void sendNoVenta(Request requestToSend, Producto_Vendido__c prod) {
        System.debug('sendNoVenta()');

        RequestSender sender = new RequestSender();
        String reqNum = sender.sendRequest(requestToSend);
        System.debug('NUMERO DE GESTION: ' + reqNum);
        processSendResult(reqNum, prod);

        // update prod;
    }

    public static void sendVenta(Request requestToSend, Producto_Vendido__c prod) {
        System.debug('sendVenta()');

        RequestSender sender = new RequestSender();
        String reqNum = sender.sendRequest(requestToSend);
        System.debug('NUMERO DE GESTION: ' + reqNum);
        processSendResult(reqNum, prod);

        // update prod;
    }

    // //Venta Portal web //Todo a deprecar/borrar
    // public static void sendVentaPortalWeb(Request requestToSend, Producto_Vendido__c prod) {
    //     System.debug('sendVentaPortalWeb()');

    //     RequestSender sender = new RequestSender();
    //     String reqNum = sender.sendRequestPortalWeb(requestToSend);
    //     System.debug('NUMERO DE GESTION: ' + reqNum);
    //     processSendResult(reqNum, prod);

    //     // update prod;
    // }

    public static void sendVentaWeb(RectorRequestType requestToSend, Producto_Vendido__c soldProduct) {
        System.debug('sendVentaWeb()');

        RequestSender sender = new RequestSender();
        String reqNum = sender.sendRequestVentaWeb(requestToSend);
        System.debug('NUMERO DE GESTION: ' + reqNum);
        processSendResult(reqNum, soldProduct);

        // update soldProduct;
    }

    public static void processSendResult(String result, Producto_vendido__c request) {
        System.debug('result');
        System.debug(result);

        if (String.isNotBlank(result) && !'0'.equalsIgnoreCase(result)) {
            request.Numero__c = Decimal.valueOf(result.replace('.', ''));
            request.Estado_Comunicacion_Rector__c = 'Enviada';
        } else {
            request.Intentos_de_Envio_Fallidos__c += 1;
            request.Estado_Comunicacion_Rector__c = 'Fallida';
        }
    }

    /*----------------------------------------------------------------------------------*/
    /*------------------------------[PRODUCTO VENDIDO FIN]------------------------------*/
    /*----------------------------------------------------------------------------------*/

    /*----------------------------------------------------------------------------------*/
    /*---------------------------------[SINIESTRO INICIO]---------------------------------*/
    /*----------------------------------------------------------------------------------*/

    //Claim
    global static Boolean sendClaim(String reqId) {
        System.debug('reqId: ' + reqId);
        Boolean result = false;
        Claim claim = [SELECT Id, Account.CUIT__c, Affected_Trade_Code__c, Policy_Number__c, Certificado__c, Endoso__c, Numerador__c, 
            	Date_ocurrencia__c, Date_denuncia__c, Hora_de_ocurrencia__c, Domicilio_de_Ocurrencia__c, Localidad_de_ocurrencia__c, 
 				Provincia_de_ocurrencia__c, IncidentSitePostalCode, Claim_Reason_Code__c, Claim_Peril_Code__c, Coverage_Code__c, 
            	Descipcion_del_siniestro__c, Descripcion_danios__c, EstimatedAmount, Tipo_de_documento_notificante__c, 
				Numero_documento_notificante__c, Apellido_y_nombre_notificante__c, Relacion_notificante__c, Telefono_notificante__c, 
            	Domicilio_notificante__c, Email_notificante__c, Codigo_Analista__c, Intentos_de_Reenvio__c
            FROM Claim
            WHERE Id = :reqId
        ];
        if(claim.Intentos_de_Reenvio__c == null) {claim.Intentos_de_Reenvio__c = 1;} else {claim.Intentos_de_Reenvio__c += 1;}
        String claimId = reqId;
        String cuil = 'No Contiene';
        String ramo = '';
        String poliza = ''; 
        String certificado = '';
        String endoso = '';
        String numSiniestro = ''; 
        String fechaOcurrencia = ''; 
        String fechaDenuncia = '';
        String horaOcurrencia = ''; 
        String domicilioOcurrencia = ''; 
        String localidadOcurrencia = ''; 
        String provinciaOcurrencia = ''; 
        String codPostalOcurrencia = ''; 
        String codCausaSiniestro = '';
        String codRiesgoSiniestro = ''; 
        String codCobertura = '';
        String descripcionSiniestro = ''; 
        String descripcionDanos = '';
        String importeEstimadoDanos = ''; 
        String tipoDocNotificante = '';
        String numDocNotificante = ''; 
        String apeNomNotificante = '';
        String relacionNotificanteAsegurado = ''; 
        String telefonoNotificante = '';
        String domicilioNotificante = ''; 
        String mailNotificante = '';
        String analistaAsignado = '';
        String camposObligatorios = '';
        if(claim.Account.CUIT__c != null || claim.Account.CUIT__c != ''){cuil = String.valueOf(claim.Account.CUIT__c);} else {camposObligatorios = camposObligatorios + 'Cuit del cliente, ';}
        if(claim.Affected_Trade_Code__c != null){ramo = String.valueOf(claim.Affected_Trade_Code__c);} else {camposObligatorios = camposObligatorios + 'Ramo, ';}
        if(claim.Policy_Number__c != null){poliza = String.valueOf(claim.Policy_Number__c);} else {camposObligatorios = camposObligatorios + 'Número de póliza, ';}
        if(claim.Certificado__c != null){certificado = String.valueOf(claim.Certificado__c);} else {camposObligatorios = camposObligatorios + 'Certificado, ';}
        if(claim.Endoso__c != null){endoso = String.valueOf(claim.Endoso__c);} else {camposObligatorios = camposObligatorios + 'Endoso, ';}
        if(claim.Numerador__c != null){numSiniestro = String.valueOf(claim.Numerador__c);} else {camposObligatorios = camposObligatorios + 'Numerador siniestro, ';}
        if(claim.Date_ocurrencia__c != null){fechaOcurrencia = claim.Date_ocurrencia__c;} else {camposObligatorios = camposObligatorios + 'Fecha de ocurrencia, ';}
        if(claim.Date_denuncia__c != null){fechaDenuncia = claim.Date_denuncia__c;} else {camposObligatorios = camposObligatorios + 'Fecha de denuncia, ';}
        if(claim.Hora_de_ocurrencia__c != null){horaOcurrencia = claim.Hora_de_ocurrencia__c;} else {camposObligatorios = camposObligatorios + 'Hora de ocurrencia, ';}
        if(claim.Domicilio_de_Ocurrencia__c != null){domicilioOcurrencia = claim.Domicilio_de_Ocurrencia__c;} else {camposObligatorios = camposObligatorios + 'Domicilio de ocurrencia, ';}
        if(claim.Localidad_de_ocurrencia__c != null){localidadOcurrencia = claim.Localidad_de_ocurrencia__c;} else {camposObligatorios = camposObligatorios + 'Localidad de ocurrencia, ';}
        if(claim.Provincia_de_ocurrencia__c != null){provinciaOcurrencia = claim.Provincia_de_ocurrencia__c;} else {camposObligatorios = camposObligatorios + 'Provincia de ocurrencia, ';}
        if(claim.IncidentSitePostalCode != null){codPostalOcurrencia = claim.IncidentSitePostalCode;} else {camposObligatorios = camposObligatorios + 'Código postal, ';}
        if(claim.Claim_Reason_Code__c != null){codCausaSiniestro = claim.Claim_Reason_Code__c;} else {camposObligatorios = camposObligatorios + 'Código causa, ';}
        if(claim.Claim_Peril_Code__c != null){codRiesgoSiniestro = claim.Claim_Peril_Code__c;} else {camposObligatorios = camposObligatorios + 'Código riesgo, ';}
        if(claim.Coverage_Code__c != null){codCobertura = claim.Coverage_Code__c;} else {camposObligatorios = camposObligatorios + 'Código de cobertura, ';}
        if(claim.Descipcion_del_siniestro__c != null){descripcionSiniestro = claim.Descipcion_del_siniestro__c;} else {camposObligatorios = camposObligatorios + 'Descripción del siniestro, ';}
        if(claim.Descripcion_danios__c != null){descripcionDanos = claim.Descripcion_danios__c;} else {camposObligatorios = camposObligatorios + 'Descripcion de los daños, ';}
        if(claim.EstimatedAmount != null){importeEstimadoDanos = String.valueOf(claim.EstimatedAmount);}
        if(claim.Tipo_de_documento_notificante__c != null){tipoDocNotificante = claim.Tipo_de_documento_notificante__c;} else {camposObligatorios = camposObligatorios + 'Tipo de documento notificante, ';}
        if(claim.Numero_documento_notificante__c != null){numDocNotificante = String.valueOf(claim.Numero_documento_notificante__c);} else {camposObligatorios = camposObligatorios + 'Numero documento notificante, ';}
        if(claim.Apellido_y_nombre_notificante__c != null){apeNomNotificante = claim.Apellido_y_nombre_notificante__c;} else {camposObligatorios = camposObligatorios + 'Nombre y apellido notificante, ';}
        if(claim.Relacion_notificante__c != null){relacionNotificanteAsegurado = claim.Relacion_notificante__c;} else {camposObligatorios = camposObligatorios + 'Relación notificante, ';}
        if(claim.Telefono_notificante__c != null){telefonoNotificante = String.valueOf(claim.Telefono_notificante__c);} else {camposObligatorios = camposObligatorios + 'Teléfono notificante, ';}
        if(claim.Domicilio_notificante__c != null){domicilioNotificante = claim.Domicilio_notificante__c;} else {camposObligatorios = camposObligatorios + 'Domicilio notificante, ';}
        if(claim.Email_notificante__c != null){mailNotificante = claim.Email_notificante__c;} else {camposObligatorios = camposObligatorios + 'Email notificante, ';}
        if(claim.Codigo_Analista__c != null){analistaAsignado = claim.Codigo_Analista__c;} else {camposObligatorios = camposObligatorios + 'Código de analista, ';}
        try {
            if(camposObligatorios == ''){
                sendClaimFuture(claimId,cuil,ramo,poliza,certificado,endoso,numSiniestro,fechaOcurrencia,fechaDenuncia,horaOcurrencia,domicilioOcurrencia,localidadOcurrencia,
                                     provinciaOcurrencia,codPostalOcurrencia,codCausaSiniestro,codRiesgoSiniestro,codCobertura,descripcionSiniestro,descripcionDanos,
                                     importeEstimadoDanos,tipoDocNotificante,numDocNotificante,apeNomNotificante,relacionNotificanteAsegurado,telefonoNotificante,
                                     domicilioNotificante,mailNotificante,analistaAsignado);
                claim.Campos_obligatorios__c = camposObligatorios;
                result = true;
            } else {
                claim.Campos_obligatorios__c = camposObligatorios;
                claim.Estado_Rector__c = 'Fallado';
                claim.Error_Rector__c = 'Faltan campos obligatorios para el reenvío';
            }
            
        } catch (Exception e) {
            claim.Estado_Rector__c = 'Fallado';
        }

        update claim;
        return result;
    }
    
    @future(callout=true)
    public static void sendClaimFuture(String claimId, String cuilCliente, String ramo, String poliza, String certificado, String endoso, String numSiniestro, String fechaOcurrencia, 
                                             String fechaDenuncia, String horaOcurrencia, String domicilioOcurrencia, String localidadOcurrencia, String provinciaOcurrencia, 
                                             String codPostalOcurrencia, String codCausaSiniestro, String codRiesgoSiniestro, String codCobertura, String descripcionSiniestro, 
                                             String descripcionDanos, String importeEstimadoDanos, String tipoDocNotificante, String numDocNotificante, String apeNomNotificante, 
                                             String relacionNotificanteAsegurado, String telefonoNotificante, String domicilioNotificante, String mailNotificante, String analistaAsignado) {
        Boolean result = true;
        system.debug('DENTRO DEL METODO FUTURO');
        system.debug('VARIABLES: '+ claimId + ' ; '+ cuilCliente + ' ; '+ ramo + ' ; '+ poliza + ' ; '+ certificado + ' ; '+ endoso + ' ; '+ numSiniestro + ' ; '+ fechaOcurrencia + ' ; '
                    + fechaDenuncia + ' ; '+ horaOcurrencia + ' ; '+ domicilioOcurrencia + ' ; '+ localidadOcurrencia + ' ; '+ provinciaOcurrencia + ' ; '+ codPostalOcurrencia + ' ; '
                     + codCausaSiniestro  + ' ; '+ codRiesgoSiniestro + ' ; '+ codCobertura + ' ; '+ descripcionSiniestro + ' ; '+ descripcionDanos + ' ; '+ importeEstimadoDanos + ' ; '
                     + tipoDocNotificante + ' ; '+ numDocNotificante + ' ; '+ apeNomNotificante + ' ; '+ relacionNotificanteAsegurado + ' ; '+ telefonoNotificante + ' ; '
                     + domicilioNotificante + ' ; '+ mailNotificante + ' ; '+ analistaAsignado);
    	WebServiceInsertSiniestro service = new WebServiceInsertSiniestro();
    	List<Claim> claim = [SELECT id, Numerador__c, Error_Rector__c,Estado_Rector__c 
                                         FROM Claim 
                                         WHERE Id = :claimId ORDER BY CreatedDate Desc LIMIT 1];
        
        result = service.insertSiniestro(cuilCliente, ramo, poliza, certificado,endoso,numSiniestro,fechaOcurrencia,fechaDenuncia,horaOcurrencia,domicilioOcurrencia,
                    localidadOcurrencia,provinciaOcurrencia,codPostalOcurrencia,codCausaSiniestro,codRiesgoSiniestro,codCobertura,descripcionSiniestro,descripcionDanos,
                    importeEstimadoDanos,tipoDocNotificante,numDocNotificante,apeNomNotificante,relacionNotificanteAsegurado,telefonoNotificante,domicilioNotificante,
                    mailNotificante,analistaAsignado);
        system.debug('LUEGO DE LLAMAR AL SERVICIO ESTE ES EL RESULTADO: ' + result);
        if (!result) {
            claim[0].Estado_Rector__c = 'Fallado';
            claim[0].Error_Rector__c = 'Error de conexión con Rector';
            update claim;
        } else {
            List<Object> response = new List<Object>();
            if(service.resultadoAltaSiniestro() == '0'){
                claim[0].Estado_Rector__c = 'Enviado';
            }else{
                claim[0].Estado_Rector__c = 'Fallado';
            }
            claim[0].Error_Rector__c = service.descripcionErrorAltaSiniestro();
            update claim;
        }
    }
    
    /*----------------------------------------------------------------------------------*/
    /*---------------------------------[SINIESTRO FIN]---------------------------------*/
    /*----------------------------------------------------------------------------------*/
    
    
    /*----------------------------------------------------------------------------------*/
    /*---------------------------------[GESTION INICIO]---------------------------------*/
    /*----------------------------------------------------------------------------------*/

    //Gestion__c
    @Future(callout=true)
    global static void sendRequestFuture(String reqId) {
        sendRequest(reqId);
    }

    global static void sendRequest(String reqId) {
        System.debug('sendRequest()');

        //prevent test errors for thats cases what delete de request before the test ends.
        if (Test.isRunningTest()) {
            //if there's no request inserted, return
            if (0 == [SELECT COUNT() FROM Gestion__c]) {
                return;
            }
        }

        List<Gestion__c> requestsFounded = QueryUtils.getRequestForSendToRector(reqId);
        if (!requestsFounded.isEmpty()) {
            Gestion__c req = requestsFounded[0];

            Request requestToSend = generateRequest(req);
            if (requestToSend != null) {
                fixChannelAndUser(req, requestToSend);

                RequestSender sender = new RequestSender();
                Boolean calloutError = false;
                String reqNum = '';
                req.Intentos_de_Envio__c += 1;
                try {
                    System.debug('requestToSend2');
                    System.debug(requestToSend);
                    reqNum = sender.sendRequest(requestToSend, req.idProces__c);
                    System.debug('reqNum: ' + reqNum);
                } catch (Exception e) {
                    calloutError = true;

                    Gestion_Duplicada__c gestionFallida = new Gestion_Duplicada__c();
                    gestionFallida.error__c = e.getMessage();
                    gestionFallida.numero__c = reqNum;
                    insert gestionFallida;
                }

                Boolean checkBasicRequestExistance = processSendRequestResult(req, reqNum, calloutError);

                /* * before update the request we should check if there's a basic request inserted with the number that we will put in the actual request. if there's, we should delete it to prevent duplicat;ed request error */
                if (checkBasicRequestExistance) {
                    checkIfThereIsBasicRequestInserted(reqNum, req.Cuenta__c);
                }

                System.debug('Numero de Gestion: ' + reqNum);
                try {
                    CMDP_Prestamo__c cmdpToUpdate = updateCMDPRecord(req);
                    if (cmdpToUpdate != null) {
                        update cmdpToUpdate;
                    }

                    update req;
                } catch (Exception e) {
                    try {
                        update req;
                    } catch (Exception ex) {
                        Gestion_Duplicada__c gestionFallida = new Gestion_Duplicada__c();
                        gestionFallida.error__c = ex.getMessage();
                        gestionFallida.numero__c = reqNum;
                        insert gestionFallida;
                    }
                }
            }
        }
    }

    public static Boolean processSendRequestResult(Gestion__c req, String reqNum, Boolean calloutError) {
        if (!calloutError && String.isNotBlank(reqNum) && !'0'.endsWithIgnoreCase(reqNum)) {
            req.Numero__c = Decimal.valueOf(reqNum.replace('.', ''));
            req.Estado_Comunicacion_Rector__c = 'Enviada';
            req.Is_API_Update__c = true;
            return true;
        } else {
            req.Intentos_de_Envio_Fallidos__c += 1;
            req.Estado_Comunicacion_Rector__c = 'Fallida';
            return false;
        }
    }

    // TODO: Esto lo tiene que hacer el generateRequestToSend
    public static void fixChannelAndUser(Gestion__c req, Request requestToSend) {
        if (String.isBlank(requestToSend.usuario)) {
            if (isAutomatedProcessUser(req.CreatedBy)) {
                requestToSend.usuario = getActiveDirectory();
            } else if (String.isNotBlank(req.CreatedBy.Active_Directory_Username__c)) {
                requestToSend.usuario = req.CreatedBy.Active_Directory_Username__c;
            }
        }

        /*
        if (String.isNotBlank(req.CreatedBy.Active_Directory_Username__c) && String.isBlank(requestToSend.usuario)) {
            requestToSend.usuario = req.CreatedBy.Active_Directory_Username__c;
        }
        */

        if (String.isNotBlank(req.CreatedBy.Canal1__c) && String.isBlank(requestToSend.canal1)) {
            requestToSend.canal1 = req.CreatedBy.Canal1__c;
        }

        if (String.isBlank(requestToSend.canal1)) {
            requestToSend.canal1 = '-1';
        }

        requestToSend.canal2 = req.CreatedBy.Canal2__c;
        if (String.isBlank(requestToSend.canal2)) {
            requestToSend.canal2 = '-1';
        }

        if (String.isBlank(requestToSend.canal4)) {
            requestToSend.canal4 = req.CreatedBy.Canal4__c;
            if (String.isBlank(requestToSend.canal4)) {
                requestToSend.canal4 = requestToSend.usuario;
            }
        }

        if (!Test.isRunningTest()) {
            /*
            if (String.isNotBlank(req.CreatedBy.Active_Directory_Username__c) && String.isBlank(requestToSend.usuario)) {
                System.debug(
                    'req[0].CreatedBy.Active_Directory_Username__c: ' + req.CreatedBy.Active_Directory_Username__c
                );
                upperCasedActiveDirectory = req.CreatedBy.Active_Directory_Username__c.toUpperCase();
            } 
            */

            if (String.isBlank(requestToSend.usuario)) {
                if (isAutomatedProcessUser(req.CreatedBy)) {
                    requestToSend.usuario = getActiveDirectory();
                } else if (String.isNotBlank(req.CreatedBy.Active_Directory_Username__c)) {
                    upperCasedActiveDirectory = req.CreatedBy.Active_Directory_Username__c.toUpperCase();
                }
            } else {
                upperCasedActiveDirectory = requestToSend.usuario.toUpperCase();
            }
        }

        //force uppercased active directory to prevent sending errors
        requestToSend.usuario = upperCasedActiveDirectory;
    }

    // TODO: Esto lo tiene que hacer el generateRequestToSend
    public static Request generateRequest(Gestion__c req) {
        System.debug('[Gestion enviada del tipo]: ' + req.RecordType.DeveloperName);
        Request requestToSend;

        switch on req.RecordType.DeveloperName {
            when 'Cambio_Emails' {
                requestToSend = GenerateRequestToSend.sendMailUpdateRequest(req);
            }
            when 'Cambio_Telefonos' {
                requestToSend = GenerateRequestToSend.sendPhoneUpdateRequest(req);
            }
            when 'Baja' {
                //baja prima unica:
                //if there's a baja prima unica we should replace the request
                if ('Baja Prima Unica'.equalsIgnoreCase(req.Motivo_Baja__c)) {
                    requestToSend = GenerateRequestToSend.sendBajaPrimaUnicaRequest(req);
                } else if ('Baja Individual Sapienza'.equalsIgnoreCase(req.Motivo_Baja__c)) {
                    requestToSend = GenerateRequestToSend.sendSapienzaRequest(req);
                } else {
                    requestToSend = GenerateRequestToSend.sendCancellationRequest(req);
                }
            }
            when 'Actualizacion_Nombre_Apellido' {
                requestToSend = GenerateRequestToSend.sendNameUpdateRequest(req);
            }
            when 'Cambio_Medio_Pago' {
                if (req.CMDP_Con_Bonificacion__c || req.Aplica_Bonificacion__c) {
                    requestToSend = GenerateRequestToSend.sendMeansOfPaymentUpdateRequestWithBonification(
                        req,
                        req.Aplica_Bonificacion__c
                    );
                } else {
                    requestToSend = GenerateRequestToSend.sendMeansOfPaymentUpdateRequest(req);
                }
            }
            when 'Cambio_Plan' {
                requestToSend = GenerateRequestToSend.sendPlanChangeRequest(req);
            }
            when 'Declaracion_Siniestro' {
                requestToSend = GenerateRequestToSend.sendClaimRequest(req);
            }
            when 'Cambio_Beneficiarios' {
                requestToSend = GenerateRequestToSend.sendBeneficiaryChangeRequest(req);
            }
            when 'Cambio_de_Domicilio' {
                requestToSend = GenerateRequestToSend.sendAddressUpdateRequest(req);
            }
            when 'Cambio_de_Domicilio_Bien_Asegurado' {
                requestToSend = GenerateRequestToSend.sendInsGoodAddressUpdateRequest(req);
            }
            when 'Retencion' {
                requestToSend = GenerateRequestToSend.sendRetRequest(req);
            }
            when 'Rechaza_Transformacion' {
                requestToSend = GenerateRequestToSend.sendRejectTransformationRequest(req);
            }
            when 'Reintegro_Extraordinario' {
                requestToSend = GenerateRequestToSend.sendExtraordinaryReinstatementRequest(req);
            }
            when 'Multi_Asistencia' {
                requestToSend = GenerateRequestToSend.sendMultiAssistanceServiceRequest(req);
            }
            // when 'Megaservicio' { // Deprecado EV-1484
            //     requestToSend = GenerateRequestToSend.sendMegaservicioRequest(req);
            // }
            when 'Ciberseguridad' {
                requestToSend = GenerateRequestToSend.sendCiberseguridadRequest(req);
            }
            when 'Telemedicina' {
                requestToSend = GenerateRequestToSend.sendTelemedicinaRequest(req);
            }
            when else {
                requestToSend = null;
            }
        }

        return requestToSend;
    }

    /*-----------------------------------------------------------------------------------*/
    /*-----------------------------------[GESTION FIN]-----------------------------------*/
    /*-----------------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------------------*/
    /*--------------------------------[AUTOGESTION INICIO]--------------------------------*/
    /*------------------------------------------------------------------------------------*/

    // * OBS: metodo usado solo en Autogestion
    public static String sendRequestNotFuture(String reqId) {
        System.debug('sendRequestNotFuture()');
        List<Gestion__c> req = [
            SELECT
                RecordType.DeveloperName,
                Cuenta__r.CUIT__c,
                Resultado_IdBHSeg__c,
                Observaciones__c,
                Poliza__r.Ramo_IdBHSeg__c,
                Poliza__r.Certificado__c,
                Poliza__r.Poliza__c,
                Poliza__r.Producto_IdBHSeg__c,
                Poliza__r.Plan_IdBHSeg__c,
                Resultado__c,
                idProces__c,
                Poliza__c,
                CreatedBy.Canal1__c,
                CreatedBy.Canal2__c,
                CreatedBy.Canal4__c,
                CreatedBy.Active_Directory_Username__c,
                Cuenta__r.FirstName,
                Cuenta__r.LastName,
                Cuenta__r.PersonEmail,
                Cuenta__r.Numero_de_Documento__c,
                Cuenta__r.Tipo_de_Documento__c,
                Cuenta__r.PersonBirthDate,
                Cuenta__r.Phone,
                Numero__c,
                Email__c,
                Email_Secundario__c,
                Telefono__c,
                Telefono_Celular__c,
                Telefono_Particular__c,
                Motivo_Baja__c,
                Motivo_Baja_IdBHSeg__c,
                Reintegro__c,
                Numero_Fax__c,
                Fecha_Registro_Fax__c,
                Nombre_Original__c,
                Nombre_Modificado__c,
                Apellido_Original__c,
                Apellido_Modificado__c,
                Medio_de_Pago__c,
                Origen_de_Pago__c,
                Cuenta_de_Pago__c,
                Plan_Original__c,
                Nuevo_Plan__c,
                Tipo_Retencion__c,
                Ramo_IdBHSeg__c,
                Tipo_Siniestro__c,
                Codigo_Causa__c,
                Codigo_Riesgo__c,
                Tipo_de_Siniestro__c,
                Fecha_y_Hora_de_Ocurrencia__c,
                Causa_Siniestro__c,
                Localidad_y_Provincia_de_ocurrencia__c,
                Localidad_y_Provincia_de_ocurrencia__r.Localidad__c,
                Localidad_y_Provincia_de_ocurrencia__r.Provincia__c,
                Localidad_y_Provincia_de_ocurrencia__r.Codigo__c,
                Localidad_y_Provincia_de_ocurrencia__r.Provincia_IdBHSeg__c,
                Codigo_de_Riesgo__c,
                Lugar_de_Ocurrencia__c,
                Descripcion__c,
                Detalle__c,
                Importe__c,
                Tipo_de_Documento_Notificante__c,
                Numero_de_Documento_Notificante__c,
                Nombre_Notificante__c,
                Relacion_Notificante__c,
                Email_Notificante__c,
                Telefono_Notificante__c,
                Domicilio_Notificante__c,
                Calle__c,
                Altura__c,
                Piso__c,
                Departamento__c,
                Codigo_Postal__c,
                Localidad_y_Provincia__r.Localidad__c,
                Localidad_y_Provincia__r.Provincia__c,
                Localidad_y_Provincia__r.Codigo__c,
                Localidad_y_Provincia__r.Provincia_IdBHSeg__c,
                Monto_Reintegro__c,
                Estado_Email__c,
                Estado_Email_Alternativo__c,
                sumaAseg01__c,
                sumaAseg02__c,
                sumaAseg03__c,
                sumaAseg04__c,
                sumaAseg05__c,
                sumaAseg06__c,
                sumaAseg07__c,
                sumaAseg08__c,
                sumaAseg09__c,
                sumaAseg10__c,
                sumaAseg11__c,
                sumaAseg12__c,
                sumaAseg13__c,
                sumaAseg14__c,
                sumaAseg15__c,
                sumaAseg16__c,
                sumaAseg17__c,
                sumaAseg18__c,
                sumaAseg19__c,
                sumaAseg01Dest__c,
                sumaAseg02Dest__c,
                sumaAseg03Dest__c,
                sumaAseg04Dest__c,
                sumaAseg05Dest__c,
                sumaAseg06Dest__c,
                sumaAseg07Dest__c,
                sumaAseg08Dest__c,
                sumaAseg09Dest__c,
                sumaAseg10Dest__c,
                sumaAseg11Dest__c,
                sumaAseg12Dest__c,
                sumaAseg13Dest__c,
                sumaAseg14Dest__c,
                sumaAseg15Dest__c,
                sumaAseg16Dest__c,
                sumaAseg17Dest__c,
                sumaAseg18Dest__c,
                sumaAseg19Dest__c,
                combinatoriaDestino__c,
                combinatoriaOrigen__c,
                LastModifiedBy.Active_Directory_Username__c,
                Intentos_de_Envio__c,
                Intentos_de_Envio_Fallidos__c
            FROM Gestion__c
            WHERE id = :reqId
        ];

        //prevent test errors
        if (Test.isRunningTest()) {
            //if there's no request inserted, return
            if (0 == [SELECT COUNT() FROM Gestion__c]) {
                return '';
            }
            req[0].Telefono_Celular__c = '(054-011  ) (15 ) 6529-6078 INT';
            req[0].Telefono__c = '(054-011  ) (15 ) 6529-6078 INT';
        }

        String requestType = req[0].RecordType.DeveloperName;

        system.debug('[Gestion enviada del tipo]: ' + requestType);
        Request requestToSend;

        if (requestType == 'Cambio_Emails') {
            requestToSend = GenerateRequestToSend.sendMailUpdateRequest(req[0]);
        } else if (requestType == 'Cambio_Telefonos') {
            //METODO GENERADO PARA AUTOGESTION

            Map<String, String> typeAndNumberPhoneMap = new Map<String, String>();
            if (req[0].Telefono_Celular__c != null)
                typeAndNumberPhoneMap.put('telefonoCelular', req[0].Telefono_Celular__c);

            if (req[0].Telefono__c != null)
                typeAndNumberPhoneMap.put('telefonoParticular', req[0].Telefono__c);

            requestToSend = GenerateRequestToSend.sendPhoneUpdateRequestAG(
                req[0].Cuenta__r.CUIT__c,
                typeAndNumberPhoneMap
            );
        }

        if (requestToSend != null) {
            if (!Test.isRunningTest()) {
                // system.debug('req[0].CreatedBy.Active_Directory_Username__c: ' + req[0].CreatedBy.Active_Directory_Username__c);
                upperCasedActiveDirectory = !isAutomatedProcessUser(req[0].CreatedBy)
                    ? req[0].CreatedBy.Active_Directory_Username__c.toUpperCase()
                    : getActiveDirectory();
                // upperCasedActiveDirectory = req[0].CreatedBy.Active_Directory_Username__c.toUpperCase();
            }

            //force uppercased active directory to prevent sending errors
            requestToSend.usuario = upperCasedActiveDirectory;
            System.debug('requestToSend: ' + requestToSend);
            RequestSender sender = new RequestSender();
            String reqNum = '';
            boolean calloutError = false;

            req[0].Intentos_de_Envio__c += 1;
            try {
                //hacer un llamado sin el idProces
                //reqNum = sender.sendRequest(requestToSend, req[0].idProces__c);
                reqNum = sender.sendRequestAG(requestToSend, '0');
                System.debug('reqNum: ' + reqNum);
            } catch (Exception e) {
                calloutError = true;

                Gestion_Duplicada__c gestionFallida = new Gestion_Duplicada__c();
                gestionFallida.error__c = e.getMessage();
                gestionFallida.numero__c = reqNum;
                //Insert gestionFallida;
            }

            if (String.isNotBlank(reqNum) && !calloutError) {
                if (reqNum != '0') {
                    req[0].Numero__c = Decimal.valueOf(reqNum.replace('.', ''));
                    req[0].Estado_Comunicacion_Rector__c = 'enviada';
                    req[0].Is_API_Update__c = true;
                } else {
                    req[0].Estado_Comunicacion_Rector__c = 'result-cero';
                    req[0].Intentos_de_Envio_Fallidos__c += 1;
                }
            } else {
                req[0].Intentos_de_Envio_Fallidos__c += 1;
                req[0].Estado_Comunicacion_Rector__c = 'callout-error';
            }

            System.debug('Numero de Gestion: ' + reqNum);

            updateRequestFuture(reqId, req[0].Estado_Comunicacion_Rector__c, reqNum);
            //Update req;
            System.debug(req[0].Estado_Comunicacion_Rector__c);
            return req[0].Estado_Comunicacion_Rector__c;
        }

        return 'request-empty';
    }

    //done
    //se debeeria pasar un map de parametros mas adelante para emails y telefonos
    // * OBS: metodo usado solo en Autogestion
    public static String sendRequestNotFuture(
        String cuit,
        String aDirectory,
        String requestType,
        String phoneNumber,
        String celPhoneNumber,
        String clientEmail
    ) {
        //METODO GENERADO PARA AUTOGESTION
        String upperCasedActiveDirectory;
        Request requestToSend;
        Map<String, String> typeAndNumberPhoneMap = new Map<String, String>();
        if (celPhoneNumber != null)
            typeAndNumberPhoneMap.put('telefonoCelular', celPhoneNumber);

        if (phoneNumber != null)
            typeAndNumberPhoneMap.put('telefonoParticular', phoneNumber);

        System.debug('typeAndNumberPhoneMap: ' + typeAndNumberPhoneMap);

        if (requestType == 'Cambio_Telefonos') {
            requestToSend = GenerateRequestToSend.sendPhoneUpdateRequestAG(cuit, typeAndNumberPhoneMap);
        } else if (requestType == 'Cambio_Emails') {
            requestToSend = GenerateRequestToSend.sendMailUpdateRequestAG(cuit, clientEmail);
        }

        if (requestToSend != null) {
            if (!Test.isRunningTest()) {
                system.debug('aDirectory: ' + aDirectory);
                upperCasedActiveDirectory = aDirectory.toUpperCase();
            }

            //force uppercased active directory to prevent sending errors
            requestToSend.usuario = upperCasedActiveDirectory;
            System.debug('requestToSend: ' + requestToSend);
            RequestSender sender = new RequestSender();
            String reqNum = '';
            boolean calloutError = false;

            try {
                //hacer un llamado sin el idProces
                //reqNum = sender.sendRequest(requestToSend, req[0].idProces__c);
                reqNum = sender.sendRequestAG(requestToSend, '0');
                System.debug('reqNum: ' + reqNum);
            } catch (Exception e) {
                calloutError = true;
            }

            if (String.isNotBlank(reqNum) && !calloutError) {
                if (reqNum != '0') {
                    return reqNum.replace('.', '');
                } else {
                    return 'result-cero';
                }
            } else {
                return 'callout-error';
            }
        }

        return 'request-empty';
    }

    // * OBS: metodo usado solo en Autogestion
    @Future
    global static void updateRequestFuture(String reqId, String status, String gestionNumber) {
        List<Gestion__c> req = [
            SELECT
                RecordType.DeveloperName,
                Cuenta__r.CUIT__c,
                Resultado_IdBHSeg__c,
                Observaciones__c,
                Poliza__r.Ramo_IdBHSeg__c,
                Poliza__r.Certificado__c,
                Poliza__r.Poliza__c,
                Poliza__r.Producto_IdBHSeg__c,
                Poliza__r.Plan_IdBHSeg__c,
                Resultado__c,
                idProces__c,
                Poliza__c,
                CreatedBy.Canal1__c,
                CreatedBy.Canal2__c,
                CreatedBy.Canal4__c,
                CreatedBy.Active_Directory_Username__c,
                Cuenta__r.FirstName,
                Cuenta__r.LastName,
                Cuenta__r.PersonEmail,
                Cuenta__r.Numero_de_Documento__c,
                Cuenta__r.Tipo_de_Documento__c,
                Cuenta__r.PersonBirthDate,
                Cuenta__r.Phone,
                Numero__c,
                Email__c,
                Email_Secundario__c,
                Telefono__c,
                Telefono_Celular__c,
                Telefono_Particular__c,
                Motivo_Baja__c,
                Motivo_Baja_IdBHSeg__c,
                Reintegro__c,
                Numero_Fax__c,
                Fecha_Registro_Fax__c,
                Nombre_Original__c,
                Nombre_Modificado__c,
                Apellido_Original__c,
                Apellido_Modificado__c,
                Medio_de_Pago__c,
                Origen_de_Pago__c,
                Cuenta_de_Pago__c,
                Plan_Original__c,
                Nuevo_Plan__c,
                Tipo_Retencion__c,
                Ramo_IdBHSeg__c,
                Tipo_Siniestro__c,
                Codigo_Causa__c,
                Codigo_Riesgo__c,
                Tipo_de_Siniestro__c,
                Fecha_y_Hora_de_Ocurrencia__c,
                Causa_Siniestro__c,
                Localidad_y_Provincia_de_ocurrencia__c,
                Localidad_y_Provincia_de_ocurrencia__r.Localidad__c,
                Localidad_y_Provincia_de_ocurrencia__r.Provincia__c,
                Localidad_y_Provincia_de_ocurrencia__r.Codigo__c,
                Localidad_y_Provincia_de_ocurrencia__r.Provincia_IdBHSeg__c,
                Codigo_de_Riesgo__c,
                Lugar_de_Ocurrencia__c,
                Descripcion__c,
                Detalle__c,
                Importe__c,
                Tipo_de_Documento_Notificante__c,
                Numero_de_Documento_Notificante__c,
                Nombre_Notificante__c,
                Relacion_Notificante__c,
                Email_Notificante__c,
                Telefono_Notificante__c,
                Domicilio_Notificante__c,
                Calle__c,
                Altura__c,
                Piso__c,
                Departamento__c,
                Codigo_Postal__c,
                Localidad_y_Provincia__r.Localidad__c,
                Localidad_y_Provincia__r.Provincia__c,
                Localidad_y_Provincia__r.Codigo__c,
                Localidad_y_Provincia__r.Provincia_IdBHSeg__c,
                Monto_Reintegro__c,
                Estado_Email__c,
                Estado_Email_Alternativo__c,
                sumaAseg01__c,
                sumaAseg02__c,
                sumaAseg03__c,
                sumaAseg04__c,
                sumaAseg05__c,
                sumaAseg06__c,
                sumaAseg07__c,
                sumaAseg08__c,
                sumaAseg09__c,
                sumaAseg10__c,
                sumaAseg11__c,
                sumaAseg12__c,
                sumaAseg13__c,
                sumaAseg14__c,
                sumaAseg15__c,
                sumaAseg16__c,
                sumaAseg17__c,
                sumaAseg18__c,
                sumaAseg19__c,
                sumaAseg01Dest__c,
                sumaAseg02Dest__c,
                sumaAseg03Dest__c,
                sumaAseg04Dest__c,
                sumaAseg05Dest__c,
                sumaAseg06Dest__c,
                sumaAseg07Dest__c,
                sumaAseg08Dest__c,
                sumaAseg09Dest__c,
                sumaAseg10Dest__c,
                sumaAseg11Dest__c,
                sumaAseg12Dest__c,
                sumaAseg13Dest__c,
                sumaAseg14Dest__c,
                sumaAseg15Dest__c,
                sumaAseg16Dest__c,
                sumaAseg17Dest__c,
                sumaAseg18Dest__c,
                sumaAseg19Dest__c,
                combinatoriaDestino__c,
                combinatoriaOrigen__c,
                LastModifiedBy.Active_Directory_Username__c,
                Intentos_de_Envio__c,
                Intentos_de_Envio_Fallidos__c
            FROM Gestion__c
            WHERE id = :reqId
        ];
        if (Test.isRunningTest()){
            gestionNumber = '1.0';
        }        
        req[0].Numero__c = Decimal.valueOf(gestionNumber.replace('.', ''));
        req[0].Estado_Comunicacion_Rector__c = status;
        req[0].Is_API_Update__c = true;
        req[0].Intentos_de_Envio__c += 1;
        if (req[0].Numero__c == 0) {
            req[0].Intentos_de_Envio_Fallidos__c += 1;
        }
        try {
            update req;
        } catch (Exception e) {
            checkIfThereIsBasicRequestInserted(gestionNumber, req[0].Cuenta__c);

            try {
                update req;
            } catch (Exception ex) {
                Gestion_Duplicada__c gestionFallida = new Gestion_Duplicada__c();
                gestionFallida.error__c = ex.getMessage();
                gestionFallida.numero__c = gestionNumber;
                insert gestionFallida;
            }
        }
    }

    /*-------------------------------------------------------------------------------------*/
    /*----------------------------------[AUTOGESTION FIN]----------------------------------*/
    /*-------------------------------------------------------------------------------------*/

    //Aux Methods {
    public static CMDP_Prestamo__c updateCMDPRecord(Gestion__c req) {
        System.debug('updateCMDPRecord()');
        CMDP_Prestamo__c cmdpToUpdate;

        if (req.CMDP_Con_Bonificacion__c && String.isNotBlank(req.Estado_Comunicacion_Rector__c)) {
            String cmdpStatus;
            Boolean doUpdate;

            switch on req.Estado_Comunicacion_Rector__c {
                when 'Fallida' {
                    cmdpStatus = 'Fallido';
                    doUpdate = true;
                }
                when 'Enviada' {
                    cmdpStatus = 'Enviado';
                    doUpdate = true;
                }
                when else {
                    cmdpStatus = '';
                    doUpdate = false;
                }
            }

            if (doUpdate) {
                List<CMDP_Prestamo__c> prestamo = [
                    SELECT Id, Estado_Gestion__c
                    FROM CMDP_Prestamo__c
                    WHERE Gestion__c = :req.Id
                ];
                if (prestamo.size() == 1) {
                    cmdpToUpdate = prestamo[0];
                    cmdpToUpdate.Estado_Gestion__c = cmdpStatus;
                }
            }
        }
        return cmdpToUpdate;
    }

    public static void checkIfThereIsBasicRequestInserted(String requestNumber, String clientId) {
        Decimal numero = Decimal.valueOf(requestNumber.replace('.', ''));
        String rt = [SELECT id FROM Recordtype WHERE DeveloperName = 'Basica'].id;

        List<Gestion__c> basicRequests = [
            SELECT id
            FROM Gestion__c
            WHERE
                Numero__c = :numero
                AND Cuenta__c = :clientId
                AND Estado_Comunicacion_Rector__c = 'Creada en Rector'
                AND RecordTypeId = :rt
        ];
        if (basicRequests.size() == 1) {
            delete basicRequests[0];
        }
    }

    public static Gestion__c getValuesFromCmdp(Gestion__c req) {
        CMDP_Prestamo__c cmdp = [
            SELECT Id, premio_actual__c
            FROM CMDP_Prestamo__c
            WHERE id_cliente_bhseg__c = :req.Cuenta__r.Id_Cliente_BHSeg__c
        ];

        req.mtPremioRef__c = String.valueOf(cmdp.premio_actual__c);
        req.mtBonifRef__c = String.valueOf((25 * Integer.valueOf(cmdp.premio_actual__c)) / 100);

        return req;
    }

    public static String getUpperCasedActiveDirectory() {
        if (String.isNotBlank(GenerateRequestToSend.getUpperCasedActiveDirectory())) {
            return GenerateRequestToSend.getUpperCasedActiveDirectory();
        }

        return upperCasedActiveDirectory;
    }

    private static String getActiveDirectory() {
        return ([SELECT Observaciones__c FROM Rector_Request_Parametry__mdt WHERE DeveloperName = 'Active_Directory']
        .Observaciones__c);
    }

    private static Boolean isAutomatedProcessUser(User user) {
        return (user == null ? false : (user.Name == 'Automated Process'));
    }
}