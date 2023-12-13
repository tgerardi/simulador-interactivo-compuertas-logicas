/**
 * @description       : 
 * @author            : Agustin Ignacio Martinez Bisagno
 * @group             : Xappia
 * @affected jiras    : EV-2041
 * @last modified on  : 12-13-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                        Modification
 * 1.0   02-17-2021   agustin.martinez@xappia.com   Initial Version
**/
public with sharing class SaleDataController {

    /*
    [}--------------------------------------------------------------------------------------{]
    [}--------------------------------{>SaleData Component<}--------------------------------{]
    [}--------------------------------------------------------------------------------------{]
    */

    @AuraEnabled
    public static String validateProductsToBeSold(String saleWrapper, String cartProducts, Boolean newClient, String step){
        SaleWrapper aSaleWrapper = (SaleWrapper) JSON.deserialize(saleWrapper, SaleWrapper.class);
        List<ProductsWrapper> soldProductCart = (List<ProductsWrapper>) JSON.deserialize(cartProducts, List<ProductsWrapper>.class);
        Map<String, Producto__c> productByRecordName = Producto__c.getAll();
        List<Poliza__c> clientPolicies = new List<Poliza__c>();
        List<Producto_Vendido__c> clientSoldProducts = new List<Producto_Vendido__c>();
        List<Gestion__c> clientIssueRequests = new List<Gestion__c>();
        //List<Gestion__c> clientCancellationRequests = new List<Gestion__c>();
        SaleDataControllerHelper helper = new SaleDataControllerHelper();

        /** Traemos Las gestiones, productos vendidos y polizas del cliente para las validaciones */
        if( !newClient ) {
            clientPolicies = QueryUtils.getClientVigentePoliciesForSalesValidation(aSaleWrapper.accountId);

            clientSoldProducts =
                QueryUtils.getClientSoldProductsInLast3DaysForSalesValidation(aSaleWrapper.documento, aSaleWrapper.accountId);

            clientIssueRequests =
                QueryUtils.getClientIssueRequestForSalesValidation(
                    aSaleWrapper.documento,
                    aSaleWrapper.accountId,
                    'Emision',
                    '73',
                    new List<String> {'PENDIENTE', 'RECHAZADO'},
                    'Rechazada',
                    'FINALIZADO'
                );

            /**
             * Validacion por bajas DEPRECADO debido a casos no contemplados 
             * en el proceso, dejar comentado un tiempo por si debe volver a revivirse.
             * 14/07/2021.
            clientCancellationRequests =
                QueryUtils.getClientCancellationRequestForSalesValidation(
                    aSaleWrapper.documento,
                    aSaleWrapper.accountId,
                    'Baja',
                    '49',
                    new List<String> {'FINALIZADO'}
                );
            **/
        }

        Producto__c product;
        Map<Boolean,List<String>> validationResponse = new Map<Boolean,List<String>>();
        for(ProductsWrapper eachProductToBeSold : soldProductCart){
            if(! eachProductToBeSold.isNoVenta){
                product = productByRecordName.get(eachProductToBeSold.productName);
                validationResponse = helper.validateProductToBeSold(
                                                                    newClient,
                                                                    product,
                                                                    eachProductToBeSold,
                                                                    aSaleWrapper,
                                                                    clientPolicies,
                                                                    clientSoldProducts,
                                                                    clientIssueRequests,
                                                                    //clientCancellationRequests,
                                                                    validationResponse,
                                                                    step
                                                                );
            }
        }

        Boolean hasError = false;
        List<String> messages = new List<String>();
        if(validationResponse.containsKey(true)){
            hasError = true;
            messages = validationResponse.get(true);
        }

        return generateValidationResponseJsonString(hasError, messages, true);
    }

    
    @AuraEnabled
    public static String validateEditedProductAgainstProductCart(String currentProductJson, String cartProductsJson){
        List<ProductsWrapper> soldProductCart = (List<ProductsWrapper>) JSON.deserialize(cartProductsJson, List<ProductsWrapper>.class);
        ProductsWrapper currentProduct = (ProductsWrapper) JSON.deserialize(currentProductJson, ProductsWrapper.class);

        return validateProductAgainstProductCart(currentProduct, soldProductCart);
    }

    @AuraEnabled
    public static String validateNewProductAgainstProductCart(String currentProductJson, String cartProductsJson){
        List<ProductsWrapper> soldProductCart = (List<ProductsWrapper>) JSON.deserialize(cartProductsJson, List<ProductsWrapper>.class);
        ProductsWrapper currentProduct = (ProductsWrapper) JSON.deserialize(currentProductJson, ProductsWrapper.class);
        return validateProductAgainstProductCart(currentProduct, soldProductCart);
    }

    private static String validateProductAgainstProductCart(ProductsWrapper currentProduct, List<ProductsWrapper> cartProducts){
        SaleDataControllerHelper helper = new SaleDataControllerHelper();

        Map<Boolean,List<String>> validationResponse = new Map<Boolean,List<String>>();
        if(! currentProduct.isNoVenta){
            for(ProductsWrapper eachProductToBeSold : cartProducts){
                if(!eachProductToBeSold.isNoVenta && currentProduct.index != eachProductToBeSold.index){
                    validationResponse = helper.validateProductAgainstProductCart(currentProduct,eachProductToBeSold,validationResponse);

                    if(validationResponse.containsKey(true)){
                        break;
                    }
                }
            }
        }
        Boolean hasError = false;
        List<String> messages = new List<String>();
        if(validationResponse.containsKey(true)){
            hasError = true;
            messages = validationResponse.get(true);
        }

        return generateValidationResponseJsonString(hasError, messages, true);
    }

    @AuraEnabled
    public static String validarCupon(String cupon){
        String estado = 'Cupón Invalido';
        Map<String, Discount_coupons__c> cds = Discount_coupons__c.getAll();
        if(!String.isBlank(cupon)){
            for(Discount_coupons__c cd : cds.values()) {
                if(cd.Codigo__c == cupon && cd.Activo__c == true){
                    estado = 'Cupón Valido';
                }
               
            }
        }
        
        return estado;
    }

    @AuraEnabled
    public static List<Servicio__c> validateContractedTelemedicinaService(String accountId){
        return QueryUtils.getTelemedicinaService(accountId);
    }

    @AuraEnabled
    public static List<String> searchSponsors(String userId){

        List<String> options = new List<String>();

        options.addAll(QueryUtils.getUserSponsors(userId).split('[;]'));

        return options;

    }

    @AuraEnabled
    public static Map<String,String> searchProductsBySponsor(String sponsor, String cartProducts){

        List<ProductsWrapper> soldProductCart = (List<ProductsWrapper>) JSON.deserialize(cartProducts, List<ProductsWrapper>.class);

        List<String> ramoSlashDescriprionList = new List<String>();

        for(ProductsWrapper eachWrapper : soldProductCart){
            ramoSlashDescriprionList.add(eachWrapper.ramoDescription+'|'+eachWrapper.ramoCode);
        }

        User currentUser = QueryUtils.getUserChannels(UserInfo.getUserId());

        if(currentUser.Profile.Name.equalsIgnoreCase('Administrador del Sistema')){
            currentUser.Canal1__c = '';
            currentUser.Canal2__c = '';
        }

        return SaleDataControllerHelper.getProductOptions(
            QueryUtils.getActiveProducts(sponsor, currentUser), 
            sponsor,
            ramoSlashDescriprionList,
            currentUser
        );
    }

    @AuraEnabled
    public static Map<String, Promotion__c> searchProductsOffers(String sponsor, String tradeCode, String productCode){

        Map<String, Promotion__c> result = new Map<String, Promotion__c>();

        for(Promotion__c promotion : Promotion__c.getAll().Values()){
            if(promotion.Sponsor__c == sponsor
                && promotion.Trade_Code__c == tradeCode
                && promotion.Product_Code__c == productCode
                && promotion.Active__c){
                    result.put(promotion.Offer__c, promotion);
            }
        }

        return result;
    }

    @AuraEnabled
    public static Map<String, Bases__c> searchProductsBases(String sponsor, String tradeCode, String productCode){

        Map<String, Bases__c> result = new Map<String, Bases__c>();

        for(Bases__c base : Bases__c.getAll().Values()){
            if(base.Sponsor__c == sponsor
                && base.Trade_Code__c == tradeCode
                && base.Product_Code__c == productCode
                ){
                result.put(base.Base__c, base);
            }
        }

        return result;
    }

    /*@AuraEnabled
    public static List<String> searchCombosBySponsorAndProduct(String sponsor, String ramoCode, String ramoDescription){

        List< String> options = new List<String>();

        User currentUser = QueryUtils.getUserChannels(UserInfo.getUserId());

        for(Producto__c prod : QueryUtils.getCombosProductos(sponsor, ramoCode, ramoDescription, currentUser)){  
            options.add(
                '$' + prod.Premio__c + ' | ' + prod.Combo__c
            );
        }

        return options;

    }*/

    @AuraEnabled
    public static Map<String, String> searchExtraProductData(String sponsor, String ramoCode, String ramoDescription/*, String combo*/){

        Producto__c product = QueryUtils.getExtraProductData(sponsor, ramoCode, ramoDescription/*, combo*/);

        Map<String, String> values = new Map<String, String>{
            'productName' => product.Name,
            'productCode' => product.Producto_IdBHSeg__c/*,
            'planNumber' => product.Plan_IdBHSeg__c != null ? product.Plan_IdBHSeg__c : '',
            'premio' =>  product.Premio__c != null ? String.valueOf(product.Premio__c) : '',
            'sumaAsegurada' => product.Suma_Asegurada__c != null ? String.valueOf(product.Suma_Asegurada__c) : ''*/
        };

        return values;
    }

    /*
    [}--------------------------------------------------------------------------------------{]
    [}--------------------------------{>SaleData Component<}--------------------------------{]
    [}--------------------------------------------------------------------------------------{]
    */

    /*
    [}--------------------------------------------------------------------------------------{]
    [}--------------------------------{>HP Component<}--------------------------------------{]
    [}--------------------------------------------------------------------------------------{]
    */

    /**
     * !Deprecated VD-18
    @AuraEnabled
    public static Poliza__c searchExistingPolicy(String accountId){

        List<Poliza__c> policies = QueryUtils.getExistingPolicy(accountId);

        if(policies.isEmpty()){
            return null;
        }

        return policies[0];

    }**/

    @AuraEnabled
    public static Map<String, String> searchEnlatados(String profile, String sponsor, String sponsorCode, String ramoCode, String productCode, Integer age, String tipoDeUso, String coveragesCodes){
        
        Map<String, String> options = new Map<String, String>();
        List<String> sponsors = new List<String>();

        if(String.isNotBlank(sponsorCode)){
            sponsors.addAll(
                Utils.searchSponsorAbreviationsByCode(sponsorCode)
            );
        }else{
            sponsors.add(sponsor);
        }

        for(Enlatado__c option : QueryUtils.getEnlatados(sponsors, ramoCode, productCode, age, searchRestrictedCanned(profile, sponsors, ramoCode, productCode, tipoDeUso, coveragesCodes),tipoDeUso)){

            options.put('$'+ Integer.valueOf(option.Premio__c) +' | '+ option.Name, JSON.serialize(new Map<String,String>{
                'id'          => option.Id,
                'codigo'      => option.Codigo_Enlatado__c,
                'ambientes'   => option.Ambiente__c,
                'combo'       => option.Combo__c,
                'ramoCode'    => option.Id_Enlatado__c.split('-')[0],
                'productCode' => option.Id_Enlatado__c.split('-')[1],
                'asistencia'  => option.Asistencia__c,
                'premio'      => String.valueOf(option.Premio__c)
            }));
        }

        return options;
    }

    private static List<String> searchRestrictedCanned(String profile, List<String> sponsorCode, String ramoCode, String productCode, String tipoDeUso, String coveragesCodes){

        List<String> restrictedCanneds = new List<String>();

        List<String> moreRestrictedCanneds = new List<String>();

        for(Filtros_de_Enlatado__c filter : Filtros_de_Enlatado__c.getAll().Values()){

            if (sponsorCode.contains(filter.Sponsor__c) 
                && filter.Codigo_Ramo__c == ramoCode 
                && filter.Codigo_Producto__c == productCode 
                && tipoDeUso == filter.Tipo_de_Uso__c){

                switch on tipoDeUso {
                    when 'Venta' {
                        /**
                         * Para venta se aplican los siguientes filtros:
                         * -Descripcion de producto
                         * -Profile
                        **/
                        if (filter.Profile__c == profile){
                            moreRestrictedCanneds.add(filter.Codigo_Enlatado__c);
                        } /*else {
                            if(String.isBlank(filter.Profile__c)){
                                restrictedCanneds.add(filter.Codigo_Enlatado__c);
                            }
                        }*/
                    }
                    when 'Retencion' {
                        /**
                         * Para retencion se aplican los siguientes filtros:
                         * -Codigos de coberturas
                        **/
                        if(filter.Coberturas__c == coveragesCodes){
                            moreRestrictedCanneds.add(filter.Codigo_Enlatado__c);
                        } else {
                            if(filter.Coberturas__c == null){
                                restrictedCanneds.add(filter.Codigo_Enlatado__c);
                            }
                        }
                    }
                    when else {
                        //Do Nothing.
                    }
                }

            }
        }

        if (!moreRestrictedCanneds.isEmpty()) {
            return moreRestrictedCanneds;
        }else{
            return restrictedCanneds;
        }
    }

    //!Alerta: Modificado en la division de hogares.
    @AuraEnabled
    public static Map<String, String> searchEnlatadoCoberturasAndAddons(String enlatadoId, String ramoCode, /*String ramoDescription,*/ String productCode, String sponsor, String addonsIds){

        Map<String, String> values = new Map<String, String>();

        Enlatado__c enlatado = QueryUtils.getEnlatado(enlatadoId);

        values.put('enlatado', JSON.serialize(new Map<String, String>{
            '$'+ Integer.valueOf(enlatado.Premio__c) +' | '+ enlatado.Name => JSON.serialize(new Map<String,String>{
                'id'          => enlatado.Id,
                'codigo'      => enlatado.Codigo_Enlatado__c,
                'ambientes'   => enlatado.Ambiente__c,
                'combo'       => enlatado.Combo__c,
                'asistencia'  => enlatado.Asistencia__c,
                'ramoCode'    => enlatado.Id_Enlatado__c.split('-')[0],
                'productCode' => enlatado.Id_Enlatado__c.split('-')[1],
                'premio'      => String.valueOf(enlatado.Premio__c)
            })
        }));

        //!Alerta: Modificado en la division de hogares.
        List<Cotizador.SumaCoberturaCotizadorWrapper> coberturas = searchCoveragesByEnlatadoToSell(enlatado.Codigo_Enlatado__c, ramoCode, /*ramoDescription,*/ productCode, sponsor);

        if(!String.isBlank(addonsIds)){
            coberturas = addAddonsSelected(coberturas, addonsIds);
        }

        values.put('coberturas', JSON.serialize(coberturas));

        return values;
    }  

    //!Alerta: Modificado en la division de hogares.
    @AuraEnabled
    public static List<Cotizador.SumaCoberturaCotizadorWrapper> searchCoveragesByEnlatadoToSell(String enlatadoCode, String ramoCode,/* String ramoDescription,*/ String productCode, String sponsor){

        List<Cotizador.SumaCoberturaCotizadorWrapper> options = new List<Cotizador.SumaCoberturaCotizadorWrapper>();

        List<Cotizador.SumaCoberturaCotizadorWrapper> optionsAddons = new List<Cotizador.SumaCoberturaCotizadorWrapper>();

        List<Cobertura_Enlatado__c> coberturasEnlatado = QueryUtils.getEnlatadosCoverages(enlatadoCode, ramoCode, productCode, sponsor);

        Map<String, Cobertura_de_Producto__c> coberturasBase = mapProductCoverages(QueryUtils.getCoberturas(ramoCode, productCode, getCodigosCoberturas(coberturasEnlatado)));

        Map<String, Limite_de_Cobertura__c> limites = mapProductCoveragesLimits(QueryUtils.getLimitesEnlatado(ramoCode, productCode, getCodigosCoberturas(coberturasEnlatado)));

        //!Alerta: Modificado en la division de hogares.
        Map<String, List<Cotizador.AddonOptionWrapper>> addons = searchAddons(ramoCode, /*ramoDescription,*/ productCode);
        system.debug('@@@@@: '+ addons);

        Map<String, Cotizador.SumaCoberturaCotizadorWrapper> newOptions = new Map<String, Cotizador.SumaCoberturaCotizadorWrapper>();

        Cotizador.SumaCoberturaCotizadorWrapper option;

        system.debug('@@@@@: '+ coberturasEnlatado);
        for(Integer i = 0; i < coberturasEnlatado.size(); i++){
            option = new Cotizador.SumaCoberturaCotizadorWrapper();

            //Coverage Fields
            option.codigoCobertura = coberturasEnlatado[i].Name;
            option.cotizacionActual = coberturasEnlatado[i].Monto_Cobertura__c;
            option.cotizacionInicial = coberturasEnlatado[i].Monto_Cobertura__c;
            option.cotizacionAjustada = coberturasEnlatado[i].Monto_Cobertura__c;
            option.descripcionLarga = coberturasBase.get(coberturasEnlatado[i].Name).Descripcion_Larga__c.toUpperCase();
            option.descripcionCorta = coberturasBase.get(coberturasEnlatado[i].Name).Descripcion_Corta__c.toUpperCase();

            if(!limites.isEmpty()){
                option.tasasCobertura = limites.get(coberturasEnlatado[i].Name).Tasa_Cobertura__c;
                option.limiteMinimo = Integer.valueOf(limites.get(coberturasEnlatado[i].Name).Limite_Min__c);
                option.limiteMaximo = Integer.valueOf(limites.get(coberturasEnlatado[i].Name).Limite_Max__c);
            }

            //Editable Coverage Fields
            option.editable = coberturasEnlatado[i].Cobertura_Editable__c;
            if(coberturasEnlatado[i].Cobertura_Editable__c && String.isNotBlank(coberturasEnlatado[i].Opciones_de_Suma__c)){
                option.coverageOptions = coberturasEnlatado[i].Opciones_de_Suma__c.split(',');
            }

            //Add-On Fields
            if(coberturasBase.get(coberturasEnlatado[i].Name).Add_On__c && coberturasEnlatado[i].Monto_Cobertura__c == 0){
                if(addons.containsKey(coberturasEnlatado[i].Name)){
                    option.addonOptions = addons.get(coberturasEnlatado[i].Name);
                }
                option.isAddon = true;
                optionsAddons.add(option);
            }else{
                //options.add(option);
                newOptions.put(coberturasEnlatado[i].Name, option);
            }
        }

        if(ramoCode == '2'){
            options = ordenarSumas(newOptions);
        }else{
            options = newOptions.values();
        }

        options.addAll(optionsAddons);

        return options;

    }

    private static Map<String, Cobertura_de_Producto__c> mapProductCoverages(List<Cobertura_de_Producto__c> coverages){

        Map<String, Cobertura_de_Producto__c> result = new Map<String, Cobertura_de_Producto__c>();

        for(Cobertura_de_Producto__c coverage : coverages){
            result.put(coverage.Codigo_Cobertura__c, coverage);
        }

        return result;

    }

    private static Map<String, Limite_de_Cobertura__c> mapProductCoveragesLimits(List<Limite_de_Cobertura__c> limits){

        Map<String, Limite_de_Cobertura__c> result = new Map<String, Limite_de_Cobertura__c>();

        for(Limite_de_Cobertura__c lim : limits){
            result.put(lim.Codigo_Cobertura__c, lim);
        }

        return result;

    }

    private static List<Cotizador.SumaCoberturaCotizadorWrapper> ordenarSumas(Map<String, Cotizador.SumaCoberturaCotizadorWrapper> wrappers){
        List<Cotizador.SumaCoberturaCotizadorWrapper> options = new List<Cotizador.SumaCoberturaCotizadorWrapper>();

        if(wrappers.containsKey('031')){
            options.add(wrappers.get('031'));
        }
        if(wrappers.containsKey('041')){
            options.add(wrappers.get('041'));
        }
        if(wrappers.containsKey('061')){
            options.add(wrappers.get('061'));
        }
        if(wrappers.containsKey('032')){
            options.add(wrappers.get('032'));
        }
        if(wrappers.containsKey('060')){
            options.add(wrappers.get('060'));
        }
        if(wrappers.containsKey('035')){
            options.add(wrappers.get('035'));
        }
        if(wrappers.containsKey('036')){
            options.add(wrappers.get('036'));
        }
        if(wrappers.containsKey('037')){
            options.add(wrappers.get('037'));
        }
        if(wrappers.containsKey('058')){
            options.add(wrappers.get('058'));
        }
        if(wrappers.containsKey('029')){
            options.add(wrappers.get('029'));
        }
        if(wrappers.containsKey('038')){
            options.add(wrappers.get('038'));
        }
        if(wrappers.containsKey('062')){
            options.add(wrappers.get('062'));
        }
        if(wrappers.containsKey('053')){
            options.add(wrappers.get('053'));
        }
        if(wrappers.containsKey('033')){
            options.add(wrappers.get('033'));
        }
        if(wrappers.containsKey('063')){
            options.add(wrappers.get('063'));
        }
        if(wrappers.containsKey('034')){
            options.add(wrappers.get('034'));
        }
        if(wrappers.containsKey('054')){
            options.add(wrappers.get('054'));
        }
        if(wrappers.containsKey('040')){
            options.add(wrappers.get('040'));
        }
        if(wrappers.containsKey('055')){
            options.add(wrappers.get('055'));
        }
        return options;

    }

    @AuraEnabled
    public static Decimal calcularPremiosWithAddons(List<Cotizador.SumaCoberturaCotizadorWrapper> coverages, String ramoCode, String productCode){
        return CotizadorController.calcularPremioMensualParaVenta(coverages, productCode, ramoCode);
    }

    @AuraEnabled
    public static Cotizador.CotizadorResult calcularSellos(CotizadorController.CotizadorControllerRequest request){
        return CotizadorController.obtenerDatosDePremio(request);
    }


    /*
    [}--------------------------------------------------------------------------------------{]
    [}--------------------------------{>HP Component<}--------------------------------------{]
    [}--------------------------------------------------------------------------------------{]
    */

    @AuraEnabled // METODO COTIZADOR ENLATADO
    public static List<Cotizador.SumaCoberturaCotizadorWrapper> getInitialWrappers(Poliza__c aPolicy){
        Combinatoria originalAmounts = CotizadorController.getPolicyCombinatoria(aPolicy);

        Map<String, Cobertura_De_Producto__c> coveragesByCode =
            CotizadorController.getCoveragesByCodeForProduct(aPolicy.Ramo_idBHSeg__c, aPolicy.Producto_IdBHSeg__c);

        return buildWrapperForCanned(aPolicy, originalAmounts, coveragesByCode);
    }

    private static List<Cotizador.SumaCoberturaCotizadorWrapper> buildWrapperForCanned(Poliza__c aPolicy, Combinatoria originalAmounts, Map<String, Cobertura_De_Producto__c> coveragesByCode){
        switch on aPolicy.Ramo_idBHSeg__c {
            when '09', '9' {
                if(aPolicy.Producto__c.containsIgnoreCase('Movilidad')){
                    //Movilidad
                    return new  List<Cotizador.SumaCoberturaCotizadorWrapper>{
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura01, '018'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura02, '019'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura03, '020'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura04, '021'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura05, '022'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura06, '023'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura07, '024'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura08, '025')
                    };
                } else {
                    //ATM (01 a 05) - BM (06 a 16)
                    return new  List<Cotizador.SumaCoberturaCotizadorWrapper>{
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura01, '001'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura02, '002'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura03, '011'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura04, '012'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura05, '003'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura06, '004'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura07, '005'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura08, '006'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura09, '007'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura10, '008'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura11, '009'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura12, '010'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura13, '013'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura14, '014'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura15, '015'),
                        CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura16, '016')
                    };
                }
            }
            when '17' {
                //Compra Protegida (002 a 004) - Robo Contenido (005-006)
                return new  List<Cotizador.SumaCoberturaCotizadorWrapper>{
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura01, '002'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura02, '003'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura03, '004'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura04, '005'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura05, '006') 
                };
            }
            when '18' {
                //Accidentes Personales
                return new  List<Cotizador.SumaCoberturaCotizadorWrapper>{
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura01, '001'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura02, '002'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura03, '003'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura04, '004'),
                    //CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCoberturaX, '005'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura05, '006'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura06, '008'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura07, '009'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura08, '010')
                };
            }
            when '20' {
                //Salud Colectiva
                return new  List<Cotizador.SumaCoberturaCotizadorWrapper>{
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura01, '001'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura02, '002'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura03, '003'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura04, '004'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura05, '005'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura06, '006'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura07, '007'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura08, '008'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura09, '009'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura10, '010'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura11, '011'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura12, '012'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura13, '013'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura14, '014'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura15, '015'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura16, '016'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura17, '017'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura18, '018'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura19, '019')
                };
            }
            when else {
                //Vida
                return new  List<Cotizador.SumaCoberturaCotizadorWrapper>{
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura01, '001'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura02, '004'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura03, '005'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura04, '006'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura05, '008'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura06, '009'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura07, '011'),
                    CotizadorController.generateCannedWrapper(coveragesByCode, originalAmounts.montoCobertura08, '013')
                };
            }
        }
    }

    @AuraEnabled // METODO COTIZADOR ENLATADO
    public static List<Cotizador.SumaCoberturaCotizadorWrapper> searchCoveragesByEnlatado(String enlatadoCode, String ramoCode, String productCode, String sponsor, List<Cotizador.SumaCoberturaCotizadorWrapper> currentWrappers, Boolean reset){
        Map<String, Decimal> cannedCoveragesByCode = new Map<String, Decimal>();

        if ( ! reset ) {
            for ( Cobertura_Enlatado__c wrapper : QueryUtils.getEnlatadosCoverages(enlatadoCode, ramoCode, productCode, sponsor) ) {
                cannedCoveragesByCode.put( wrapper.Name, wrapper.Monto_Cobertura__c );
            }
        }

        for ( Cotizador.SumaCoberturaCotizadorWrapper wrapper : currentWrappers ) {
            if ( ! reset ) {
                wrapper.cotizacionAjustada = cannedCoveragesByCode.get(wrapper.codigoCobertura);
            } else {
                wrapper.cotizacionAjustada = wrapper.cotizacionInicial;
            }
        }


        return currentWrappers;
    }

    @AuraEnabled
    public static Lead searchLead(String leadId){

        return QueryUtils.getLead(leadId);
    }

    @AuraEnabled
    public static Map<String, String> searchPaymentDescriptions(String mdp, String odp){

        Map<String, String> descriptions = new Map<String, String>{
            'mdp' => PaymentMethodController.searchPaymentMethodDescription(mdp),
            'odp' => PaymentMethodController.searchPaymentOriginDescription(mdp, odp)
        };

        return descriptions;
    }

    @AuraEnabled
    public static List<Map<String, String>> searchMotivosNoVenta(){
        List<Map<String, String>> motivos = new List<Map<String, String>>();

        for (Motivos_no_Venta__c motivo : Motivos_no_Venta__c.getAll().values()) {
            motivos.add(new Map<String, String>{
                'code' => motivo.Codigo__c, 
                'description' => motivo.Descripcion__c
            });
        }

        return motivos;
    }

    @Auraenabled
    public static String changeToNoVenta (String motivoCode, String motivoDescription, String productToChange) {

        ProductsWrapper product = (ProductsWrapper) JSON.deserialize(productToChange, ProductsWrapper.class);

        product.icon = 'utility:archive';
        product.rowActions = new List<Map<String, String>>{ 
            new Map<String, String>{'label' => 'Editar', 'name' => 'editNoVenta', 'iconName' => 'utility:edit'},
            new Map<String, String>{'label' => 'Cambiar a Venta', 'name' => 'venta', 'iconName' => 'utility:cart'},
            new Map<String, String>{'label' => 'Eliminar', 'name' => 'delete', 'iconName' => 'utility:delete'}
        };
        product.isNoVenta = true;
        product.motivoNoVentaCode = motivoCode;
        product.motivoNoVenta = motivoDescription;

        return JSON.serialize(product);

    }

    @Auraenabled
    public static String initProductWrapper (Boolean isNoVenta) {

        ProductsWrapper product = new ProductsWrapper();

        if(isNoVenta){
            product.icon = 'utility:archive';
            product.rowActions = new List<Map<String, String>>{ 
                new Map<String, String>{'label' => 'Editar', 'name' => 'editNoVenta', 'iconName' => 'utility:edit'},
                new Map<String, String>{'label' => 'Cambiar a Venta', 'name' => 'venta', 'iconName' => 'utility:cart'},
                new Map<String, String>{'label' => 'Eliminar', 'name' => 'delete', 'iconName' => 'utility:delete'}
            };
            product.isNoVenta = isNoVenta;
        }

        return JSON.serialize(product);

    }

    @InvocableMethod(label='Guardar nuevas ventas')
    public static void saveNewVentas(List<SaveSaleInputs> parameters){
        List<ProductsWrapper> productsList = (List<ProductsWrapper>)JSON.deserialize(parameters[0].cartProducts, List<ProductsWrapper>.class);
        
        List<Producto_Vendido__c> productosVendidos = new List<Producto_Vendido__c>();

        String recordTypeVenta = QueryUtils.getRecordTypeVenta();

        String recordTypeNoVenta = QueryUtils.getRecordTypeNoVenta();

        for(ProductsWrapper product : productsList) {
            Producto_Vendido__c pv = new Producto_Vendido__c();

            pv.Venta__c = parameters[0].saleId;

            //Cuenta
            if(parameters[0].accountId != '' && parameters[0].accountId != null) {
                pv.Cuenta__c = parameters[0].accountId;
            }

            //RecordType
            if(product.isNoVenta){
                pv.Motivo_No_Venta__c = product.motivoNoVentaCode;
                pv.Descripcion_Motivo_No_Venta__c = product.motivoNoVenta;
                pv.RecordTypeId = recordTypeNoVenta;
                pv.tipoNovedad__c = 'NVT';
            }else{
                //Rector
                pv.Estado_Comunicacion_Rector__c = 'Para Enviar';
                pv.RecordTypeId = recordTypeVenta;
                pv.tipoNovedad__c = 'EMI';
            }
        
            //Payment Method
            pv = addPaymentMethodToSoldProduct(pv, product);

            //Payment Method Bonuses
            pv = addPaymentMethodBonusToSoldProduct(pv, product);

            //Addresses
            pv = addAddressToSoldProduct(pv, product);

            //Informacion basica
            pv.Sponsor__c = product.sponsor;
            pv.Producto_IdBHSeg__c = product.productCode;
            pv.Ramo_IdBHSeg__c = product.ramoCode;
            pv.Ramo__c = product.ramoDescription;
            /*pv.Plan_Nombre__c = product.productName;*/
            /*pv.Plan__c = product.combo;*/
            pv.Codigo_Enlatado__c = product.cannedCode;
            if(String.isNotBlank(product.premio)){
                pv.premioOrigen__c = Decimal.valueOf(product.premio);
                pv.premioDestino__c = Decimal.valueOf(product.premio);
            }

            //Plan activo
            pv = addActivePlanToSoldProduct(pv, product);

            /*if(String.isNotBlank(product.planNumber)){
                pv.Plan_IdBHSeg__c = product.planNumber;
            }else{
                //Plan activo
                
            }*/
            if(String.isNotBlank(product.cupon)){
                pv.cupon__c = product.cupon;
            }
            if(! product.isNoVenta && String.isBlank(product.premio) &&
                (pv.premioOrigen__c == null || pv.premioOrigen__c < 0) &&
                (pv.premioDestino__c == null || pv.premioDestino__c < 0)
            ){
                NoDataFoundException noPremio = new NoDataFoundException();
                noPremio.setMessage(
                    String.format(
                        'No se pudo guardar el premio esperado para el producto: {0}({1}-{2}-{3})',
                        new List<String>{ pv.Ramo__c, pv.Ramo_IdBHSeg__c, pv.Producto_IdBHSeg__c,/*pv.Plan_IdBHSeg__c,*/ pv.Sponsor__c }
                    )
                );
                throw noPremio;
            }

            //Coberturas
            if(!product.coberturas.isEmpty()){
                pv = addCoveregesToSoldProduct(pv, product.coberturas);
            }

            //Coberturas - Add Ons
            List<Cotizador.SumaCoberturaCotizadorWrapper> addOnsCoberturas = new List<Cotizador.SumaCoberturaCotizadorWrapper>();
            for (Cotizador.SumaCoberturaCotizadorWrapper cobertura : product.coberturas){
                if(cobertura.isAddon && (cobertura.addonSelected.monto != 0)){
                    addOnsCoberturas.add(cobertura);
                }
            }
            if(! addOnsCoberturas.isEmpty()){
                pv = addAddOnsInfo(pv, addOnsCoberturas);
            }

            //Premio Base
            //Si existe el premio base (y tambien hay premio editable) asigno el base
            if(String.isNotBlank(product.premioBase)){
                pv.Premio_Base__c = Decimal.valueOf(product.premioBase);
            }
            //Sino asigno el mismo premio total
            else{
                if(String.isNotBlank(product.premio)){
                    pv.Premio_Base__c = Decimal.valueOf(product.premio);
                }
            }

            //Promociones
            pv = addPromotionToSoldProduct(pv, product);

            //bases
            pv = addBaseToSoldProduct(pv, product);

            //Camara
            pv = addCameraToSoldProduct(pv, product);

            //Preguntas de producto
            pv = addProductQuestionsToSoldProduct(pv, product);

            //Preguntas de asegurabilidad
            if(!product.insurabilityQuestions.isEmpty()){
                pv = addInsurabilityQuestionsToSoldProduct(pv, product);
            }
            
            //Asistencia
            pv = addAsistanceToSoldProduct(pv, product);

            //Ambientes
            if(String.isNotBlank(product.enlatadoAmbiente)){
                pv.metrosCuadrados__c = product.enlatadoAmbiente;
            }

            //Hijos
            if(!product.coberturas.isEmpty()){
                pv = addChildsAgesToSoldProduct(pv, product);
            }

            //Escolaridad
            if(product.cuotaPromedio != 0){
                pv.Cuota_Colegio_Promedio__c = product.cuotaPromedio;
            }

            //Lead
            if(String.isNotBlank(parameters[0].leadId)){
                
                pv.Candidato__c = parameters[0].leadId;

                String source = QueryUtils.getLeadSource(parameters[0].leadId);

                if(source.equalsIgnoreCase('Portal-ventas') || String.isBlank(source)){
                    pv.Source__c = 'Abandonos';
                }else{
                    pv.Source__c = source;
                }
            }
            
            product.soldProduct = pv;

            productosVendidos.add(pv);
        }
        
        List<String> response = new List<String>();

        try {
            insert productosVendidos;

            Beneficiario_de_Venta__c benObj;

            Adicional__c adicional;

             //Beneficiarios & Lead & Email
            List<Beneficiario_de_Venta__c> beneficiaries = new List<Beneficiario_de_Venta__c>();
            List<Adicional__c> aditionals = new List<Adicional__c>();

            for(ProductsWrapper pw : productsList){
                
                //Email
                if(
                    pw.ramoCode.equalsIgnoreCase('2') 
                    && pw.productCode.equalsIgnoreCase('210') 
                    && pw.sponsor.equalsIgnoreCase('DIAPIN') 
                    && pw.soldProduct.RecordTypeId == Schema.SObjectType.Producto_Vendido__c.getRecordTypeInfosByName().get('Venta').getRecordTypeId()
                ){
                    EmailSenderToCustomer.sendHogarProtegidoCoberturasEmail(parameters[0].accountEmail, pw.soldProduct);
                }

                //Beneficiaries - Adtionals
                if(!pw.beneficiarios.isEmpty()){ 
                    for(BeneficiaryController.SaleBeneficiaryWrapper ben : pw.beneficiarios){
                        if(ben.isAdicional){
                            adicional = new Adicional__c();
                            adicional.Tipo_de_Documento__c = ben.tipoDeDocumento;
                            adicional.Numero_de_Documento__c = String.valueOf(ben.numeroDeDocumento);
                            adicional.Apellido__c = ben.apellido;
                            adicional.Nombre__c = ben.nombre;
                            adicional.Fecha_de_Nacimiento__c = ben.fchDeNacimiento;
                            adicional.Relacion__c = ben.relacion;
                            //Este tipo de adicional tiene un 50% fijo como porcentaje.
                            adicional.Porcentaje__c = 50;
                            adicional.Producto_Vendido__c = pw.soldProduct.Id;
                            aditionals.add(adicional);
                        }else{
                            benObj = new Beneficiario_de_Venta__c();
                            benObj.Tipo_de_Documento__c = ben.tipoDeDocumento;
                            benObj.Numero_de_Documento__c = String.valueOf(ben.numeroDeDocumento);
                            benObj.Apellido__c = ben.apellido;
                            benObj.Nombre__c = ben.nombre;
                            benObj.Relacion__c = ben.relacion;
                            benObj.Telefono__c = ben.telefono;
                            benObj.Porcentaje__c = ben.porcentaje;
                            benObj.Producto_Vendido__c = pw.soldProduct.Id;
                            if (String.isNotBlank(benObj.id)) {
                                benObj.Id = ben.Id;
                            }
                            beneficiaries.add(benObj);
                        }
                    }
                }
            }

            upsert beneficiaries;

            insert aditionals;

        } catch (Exception e) {
			CreateApexLog.create(
				new Map<MapLogArgKey, Object> { 
					MapLogArgKey.EXCEPTIONINFO => e,
					MapLogArgKey.CLASSINFO => 'SaleDataController',
					MapLogArgKey.METHODINFO => 'saveNewVentas'
			});
			throw e;
		}
    }

    /*
    [}--------------------------------------------------------------------------------------{]
    [}--------------------------------{>Auxiliary Methods<}--------------------------------{]
    [}--------------------------------------------------------------------------------------{]
    */

    private static Producto_Vendido__c addPaymentMethodBonusToSoldProduct(Producto_Vendido__c soldProduct, ProductsWrapper cartProduct){

        for(Payment_Method_Bonus__c bonus : Payment_Method_Bonus__c.getAll().values()){
            if(bonus.Trade_Code__c == cartProduct.ramoCode 
                && bonus.Product_Code__c == cartProduct.productCode
                && bonus.Sponsor__c == cartProduct.sponsor
                && bonus.Payment_Method_Code__c == PaymentMethodController.searchPaymentMethodCode(cartProduct.sPaymentWrapper.paymentMethod)
                && bonus.Payment_Origin_Code__c == PaymentMethodController.searchPaymentOriginCode(cartProduct.sPaymentWrapper.paymentOrigin)){
                    soldProduct.id_bonificacion__c = bonus.Bonus_Type__c;
                    soldProduct.cuotas_bonificacion__c = bonus.Bonus_Installment__c != null ? String.valueOf(bonus.Bonus_Installment__c.intValue()) : '';
                    soldProduct.porcentaje_bonificacion__c =  bonus.Bonus_Percentage__c  != null ? String.valueOf(bonus.Bonus_Percentage__c.intValue()) : '';
            }
        }

        return soldProduct;
    }

    private static Producto_Vendido__c addActivePlanToSoldProduct(Producto_Vendido__c soldProduct, ProductsWrapper cartProduct){

        for(Active_Plan__c plan : Active_Plan__c.getAll().values()){
            if(cartProduct.ramoCode == plan.Trade_Code__c 
                && cartProduct.productCode == plan.Product_Code__c){
                soldProduct.Plan_IdBHSeg__c = plan.Plan_Code__c;
            }
        }

        return soldProduct;
    }

    private static Producto_Vendido__c addChildsAgesToSoldProduct(Producto_Vendido__c soldProduct, ProductsWrapper cartProduct){

        List<String> childsAges = new List<String>();

        for(CotizadorController.ChildsWrapper child : cartProduct.hijos){
            childsAges.add(String.valueOf(child.age));
        }

        soldProduct.Edad_Hijos__c = String.join(childsAges, ';');

        return soldProduct;
    }

    private static Producto_Vendido__c addProductQuestionsToSoldProduct(Producto_Vendido__c soldProduct, ProductsWrapper cartProduct){

        switch on cartProduct.ramoCode {
            when '2' {
                soldProduct = addHogarQuestions(soldProduct, cartProduct);
            }
            when '19' {
                soldProduct = addVidaQuestions(soldProduct, cartProduct);
            }
            when '9' {
                soldProduct = addHogarQuestions(soldProduct, cartProduct);
            }
            when else {
                //Do Nothing.
            }
        }

        return soldProduct;

    }

    private static Producto_Vendido__c addHogarQuestions(Producto_Vendido__c soldProduct, ProductsWrapper cartProduct){

        if(String.isNotBlank(cartProduct.terrenoQuestion)){
            soldProduct.pregunta3__c = cartProduct.terrenoQuestion;
        }

        if(String.isNotBlank(cartProduct.rejasQuestion)){
            soldProduct.pregunta2__c = cartProduct.rejasQuestion;
        }

        if(String.isNotBlank(cartProduct.mediaDescription)){
            soldProduct.Como_nos_conocio__c = cartProduct.mediaDescription;
        }
        if(String.isNotBlank(cartProduct.patente)){
            soldProduct.Patente__c = cartProduct.patente;
        }
        if(cartProduct.ramoCode == '9'){
            if(String.isNotBlank(cartProduct.marca)){
                soldProduct.Marca__c = cartProduct.marca;
            }
            if(String.isNotBlank(cartProduct.modelo)){
                soldProduct.Modelo__c = cartProduct.modelo;
            }
            if(String.isNotBlank(cartProduct.imei)){
                soldProduct.IMEI__c = cartProduct.imei;
            }

            soldProduct.Numero_de_Serie__c = String.isNotBlank(cartProduct.serialNumber) ? cartProduct.serialNumber : '';
            soldProduct.Tipo_de_bien__c = String.isNotBlank(cartProduct.typeOfGood) ? cartProduct.typeOfGood : '';
        }

        return soldProduct;

    }

    private static Producto_Vendido__c addVidaQuestions(Producto_Vendido__c soldProduct, ProductsWrapper cartProduct){

        if(cartProduct.peso != 0){
            soldProduct.Peso_IMC__c = cartProduct.peso;
        }

        if(cartProduct.altura != 0){
            soldProduct.Altura_IMC__c = cartProduct.altura;
        }

        if(String.isNotBlank(cartProduct.bmiClassification)){
            soldProduct.Clasificacion_IMC__c = cartProduct.bmiClassification;
        }

        return soldProduct;

    }

    private static Producto_Vendido__c addInsurabilityQuestionsToSoldProduct(Producto_Vendido__c soldProduct, ProductsWrapper cartProduct){

        switch on cartProduct.ramoCode {
            when '2' {
                soldProduct = addHogarInsurabilityQuestions(soldProduct, cartProduct);
            }
            when '19' {
                switch on cartProduct.productCode {
                    when '310', '311', '312' {
                        soldProduct = addVidaEducacionInsurabilityQuestions(soldProduct, cartProduct);
                    }
                    when else {
                        //Do Nothing.
                    }
                }
            }
            when else {
                //Do Nothing.
            }
        }

        return soldProduct;

    }

    private static Producto_Vendido__c addHogarInsurabilityQuestions(Producto_Vendido__c soldProduct, ProductsWrapper cartProduct){

        for(QuestionController.QuestionWrapper question : cartProduct.insurabilityQuestions){
            switch on question.order {
                when 1 {
                    if(question.answer){
                        soldProduct.viviendaPermanente__c = 'S';
                    }else{
                        soldProduct.viviendaPermanente__c = 'N';
                    }
                }
                when 2 {
                    if(question.answer){
                        soldProduct.actividadesComerciales__c = 'S';
                    }else{
                        soldProduct.actividadesComerciales__c = 'N';
                    }
                }
                when 3 {
                    if(question.answer){
                        soldProduct.paredesMaterial__c = 'S';
                    }else{
                        soldProduct.paredesMaterial__c = 'N';
                    }
                }
                when else {
                    //Do Nothing.
                }
            }
        }

        return soldProduct;

    }

    private static Producto_Vendido__c addVidaEducacionInsurabilityQuestions(Producto_Vendido__c soldProduct, ProductsWrapper cartProduct){

        soldProduct.Declaracion_Jurada__c = getAffidavit(cartProduct.insurabilityQuestions);

        soldProduct.Respuestas_Declaracion_Jurada__c = getInsurabilityQuestionsAnswer(cartProduct.insurabilityQuestions);

        if(String.isNotBlank(cartProduct.comments)){
            soldProduct.Comentarios_Declaracion_Jurada__c = cartProduct.comments; 
        }

        return soldProduct;

    }

    private static String getAffidavit(List<QuestionController.QuestionWrapper> insurabilityQuestions){

        String affidavit = '';

        for(QuestionController.QuestionWrapper question : insurabilityQuestions){
            switch on question.affidavit {
                when 'S' {
                    if(!affidavit.equalsIgnoreCase('C') && !affidavit.equalsIgnoreCase('I')){
                        affidavit = question.affidavit;
                    }
                }
                when 'I' {
                    if(!affidavit.equalsIgnoreCase('C')){
                        affidavit = question.affidavit;
                    }
                }
                when 'C', 'E' {
                    affidavit = question.affidavit;
                }
                when else {
                    //Do Nothing.
                }
            }
        }

        return affidavit;

    }

    private static String getInsurabilityQuestionsAnswer(List<QuestionController.QuestionWrapper> insurabilityQuestions){

        String answer = 'N';

        for(QuestionController.QuestionWrapper question : insurabilityQuestions){
            if(question.answer){
                answer = 'S';
                break;
            }
        }

        return answer;
    }

    //!Alerta: Modificado en la division de hogares.
    private static Producto_Vendido__c addPromotionToSoldProduct(Producto_Vendido__c soldProduct, ProductsWrapper cartProduct){
        
        if(cartProduct.offer != null){
            soldProduct.Promocion__c = cartProduct.offer.Promotion_Type__c;
            soldProduct.Porcentaje_Devolucion__c = cartProduct.offer.Percentage__c;
        }

        return soldProduct;

        /*User currentUser = QueryUtils.getUserChannels(UserInfo.getUserId());

        for(Promotion__c promotion :  Promotion__c.getAll().values()){
            if(promotion.Active__c){
                if(promotion.Sponsor__c.equalsIgnoreCase(cartProduct.sponsor)
                    && promotion.Trade_Code__c.equalsIgnoreCase(cartProduct.ramoCode)
                    && promotion.Product_Code__c.equalsIgnoreCase(cartProduct.productCode)
                    && promotion.Offer__c.equalsIgnoreCase(searchProductOffer(cartProduct.ramoCode, cartProduct.productCode, cartProduct.ramoDescription))
                    && (promotion.Channels__c.containsIgnoreCase(currentUser.Canal1__c != null ? currentUser.Canal1__c : '')
                        || promotion.Channels__c.containsIgnoreCase(currentUser.Canal2__c != null ? currentUser.Canal1__c : '')
                        || currentUser.Profile.Name.equalsIgnoreCase('Administrador del Sistema'))){
                    soldProduct.Promocion__c = promotion.Promotion_Type__c;
                    soldProduct.Porcentaje_Devolucion__c = promotion.Percentage__c;
                }
            }
        }*/

    }

    private static Producto_Vendido__c addBaseToSoldProduct(Producto_Vendido__c soldProduct, ProductsWrapper cartProduct){
        if(cartProduct.base != null){
            soldProduct.Base__c = cartProduct.base.Base__c;
        }

        return soldProduct;
    }

    /*TODO: Agregar Oferta al wrapper de venta y se evita esta logica.
    private static String searchProductOffer (String ramoCode, String productCode, String ramoDescription){

        if(ramoCode == '2' 
            && productCode == '212' 
            && ramoDescription.containsIgnoreCase('Cámara')){
            return 'Camara';
        }else{
            if(ramoCode == '2' 
                && productCode == '212' 
                && ramoDescription.containsIgnoreCase('Devolución')){
                return 'Devolucion';
            }
        }

        return '';
    }*/

    private static Producto_Vendido__c addCameraToSoldProduct(Producto_Vendido__c soldProduct, ProductsWrapper cartProduct){

        if('S'.equalsIgnoreCase(soldProduct.Promocion__c)
            && String.isNotBlank(cartProduct.camaraCode)){
            soldProduct.Camara__c = cartProduct.camara;
            soldProduct.Numero_de_Serie_Camara__c = cartProduct.camaraCode;
        }

        return soldProduct;
    }

    private static Producto_Vendido__c addAsistanceToSoldProduct(Producto_Vendido__c soldProduct, ProductsWrapper cartProduct){

        switch on cartProduct.ramoCode {
            when '2' {
                soldProduct.combinatoria__c = getHogarAsistance(cartProduct);
            }
            when '19' {
                soldProduct.combinatoria__c = getVidaEducacionAsistance(cartProduct);
            }
            when else {
                //Do Nothing.
            }
        }

        return soldProduct;
    }

    private static String getHogarAsistance(ProductsWrapper cartProduct){

        if(String.isNotBlank(cartProduct.asistencia)){
            switch on cartProduct.asistencia.toLowerCase() {
                when 'basica' {
                    return 'CLA';
                }
                when 'plus' {
                    return 'PLU';
                }
                when 'premium' {
                    return 'FUL';
                }
                when else {
                    return '';
                }
            }
        }

        return '';
    }

    private static String getVidaEducacionAsistance(ProductsWrapper cartProduct){
        switch on cartProduct.productCode {
            when '310', '311' {
                return 'EDU';
            }
            when else {
                return '';
            }
        }
    }

    private static List<Cotizador.SumaCoberturaCotizadorWrapper> addAddonsSelected(List<Cotizador.SumaCoberturaCotizadorWrapper> coberturas, String addonsIds){
        List<String> addonsList = addonsIds.split(';');

        List<Add_On_Options__c> addonsSelected = QueryUtils.getAddonsById(addonsList);

        List<Add_On_Options__c> dependentsAddons = new List<Add_On_Options__c>();

        for(Add_On_Options__c addonOption : addonsSelected){
            for(Add_On_Options__c option : Add_On_Options__c.getAll().values()){
                if(addonOption.Name ==  option.Cobertura_Padre__c){
                    dependentsAddons.add(option);
                }
            }
        }

        addonsSelected.addAll(dependentsAddons);
        
        for(Cotizador.SumaCoberturaCotizadorWrapper cobertura : coberturas){
            for(Add_On_Options__c addonOption : addonsSelected){
                if(addonOption.Codigo_Cobertura__c == cobertura.codigoCobertura){
                    cobertura.addonSelected = new Cotizador.AddonOptionWrapper(
                        addonOption.Name, 
                        '$'+ Integer.valueOf(addonOption.Monto__c), 
                        Integer.valueOf(addonOption.Monto__c), 
                        addonOption.Premio_Mensual__c,
                        addonOption.Premio_Diario__c, 
                        addonOption.Cobertura_Padre__c == null ? '' : addonOption.Cobertura_Padre__c
                    );
                    if(addonOption.Cobertura_Padre__c != null){
                        cobertura.addonSelectedFijo = true;
                    }
                }
            }
        }

        return coberturas;
    }

    private static List<String> getCodigosCoberturas(List<Cobertura_Enlatado__c> coberturasEnlatado){
        List<String> codigosCoberturas = new List<String>();

        for(Cobertura_Enlatado__c coberturaEnlatado : coberturasEnlatado){
            codigosCoberturas.add(coberturaEnlatado.Name);
        }

        return codigosCoberturas;
    }

    //!Alerta: Modificado en la division de hogares.
    public static Map<String, List<Cotizador.AddonOptionWrapper>> searchAddons(String ramoCode, /*String ramoDescription,*/ String productCode){
        Map<String, List<Cotizador.AddonOptionWrapper>> addons = new Map<String, List<Cotizador.AddonOptionWrapper>>();

        for(Add_On_Options__c addon :  Add_On_Options__c.getAll().values()){
            if(addon.Activo__c && addon.Codigo_Producto__c == productCode && addon.Codigo_Ramo__c == ramoCode/* && addon.Descripcion_Ramo__c == ramoDescription*/){
                if(addons.containsKey(addon.Codigo_Cobertura__c)){
                    addons.get(addon.Codigo_Cobertura__c).add(
                        new Cotizador.AddonOptionWrapper(addon.Name, '$'+ Integer.valueOf(addon.Monto__c), Integer.valueOf(addon.Monto__c), addon.Premio_Mensual__c, addon.Premio_Diario__c, addon.Cobertura_Padre__c == null ? '' : addon.Cobertura_Padre__c)
                    );
                }else{
                    addons.put(addon.Codigo_Cobertura__c, new List<Cotizador.AddonOptionWrapper>{
                        new Cotizador.AddonOptionWrapper(addon.Name, '$'+ Integer.valueOf(addon.Monto__c), Integer.valueOf(addon.Monto__c), addon.Premio_Mensual__c,addon.Premio_Diario__c, addon.Cobertura_Padre__c == null ? '' : addon.Cobertura_Padre__c)
                    });
                }
            }
        }

        return addons;
    }



    private static Producto_Vendido__c addPaymentMethodToSoldProduct(Producto_Vendido__c soldProduct, ProductsWrapper cartProduct){
        //Medio de pago
        soldProduct.Medio_de_Pago__c = cartProduct.sPaymentWrapper.paymentMethod;//medioDePago;
        soldProduct.Origen_de_Pago__c = cartProduct.sPaymentWrapper.paymentOrigin;//origenDePago;
        soldProduct.Numero_TC__c = 'DECIDIR'.equalsIgnoreCase(cartProduct.sPaymentWrapper.validation)/*isDecidir*/ ? cartProduct.sPaymentWrapper.encrypted/*encryptedMDP*/ : cartProduct.sPaymentWrapper.paymentNumber/*numeroMDP*/;

        if('DECIDIR'.equalsIgnoreCase(cartProduct.sPaymentWrapper.validation)){
            /*soldProduct.Medio_de_Pago_Encriptado__c = true;*/
            soldProduct.Mecanismo_Encriptacion__c = cartProduct.sPaymentWrapper.validation;
        }
        
        if(cartProduct.sPaymentWrapper.creditCard){
            soldProduct.Nombre_Titular_TC__c = cartProduct.sPaymentWrapper.creditCardFirstName;//cartProduct.nombreTC;
            soldProduct.Apellido_Titular_TC__c = cartProduct.sPaymentWrapper.creditCardLastName;//cartProduct.apellidoTC;
            if(!String.isBlank(cartProduct.sPaymentWrapper.creditCardMonth/*cartProduct.mesTC*/)
                && !String.isBlank(cartProduct.sPaymentWrapper.creditCardYear/*cartProduct.anioTC*/)){
                soldProduct.Fecha_Vencimiento_TC__c = Date.newInstance(
                    Integer.valueOf(cartProduct.sPaymentWrapper.creditCardYear/*cartProduct.anioTC*/),
                    Integer.valueOf(cartProduct.sPaymentWrapper.creditCardMonth/*cartProduct.mesTC*/),
                    01);
            }
        }

        if(cartProduct.sPaymentWrapper.webLead != null){
            soldProduct.Candidato_Medio_Pago__c = cartProduct.sPaymentWrapper.webLead;
        }
        
        /**
         * TODO: Revisar.
        if(cartProduct.isTC && String.isBlank(soldProduct.Numero_TC__c)){
            NoDataFoundException noTC = new NoDataFoundException();
            noTC.setMessage(
                String.format(
                    'No se pudo agregar el medio de pago para el producto: {0}({1}-{2}-{3}-{4})',
                    new List<String>{ cartProduct.ramoDescription, cartProduct.ramoCode, cartProduct.productCode, 
                        cartProduct.planNumber, cartProduct.sponsor }
                )
            );
            throw noTC;
        }
        **/

        /**
        if (cartProduct.isTC 
            && !cartProduct.isVerificado 
            && !String.isBlank(cartProduct.anioTC)
            && !String.isBlank(cartProduct.mesTC)) {
            soldProduct.Fecha_Vencimiento_TC__c = Date.newInstance(
                Integer.valueOf(cartProduct.anioTC),
                Integer.valueOf(cartProduct.mesTC),
                01);
        }
        **/

        return soldProduct;
    }

    private static Producto_Vendido__c addAddressToSoldProduct(Producto_Vendido__c soldProduct, ProductsWrapper cartProduct){
        //Domicilio Postal
        soldProduct.Calle_Domicilio_Postal__c = cartProduct.calle;
        soldProduct.Numero_Domicilio_Postal__c = cartProduct.numeroDomicilio;
        soldProduct.Piso_Domicilio_Postal__c = cartProduct.piso;
        soldProduct.Departamento_Domicilio_Postal__c = cartProduct.departamento;
        soldProduct.Codigo_Postal_Domicilio_Postal__c = cartProduct.codigoPostal;
        if(String.isNotBlank(cartProduct.localidadProvincia)){
            soldProduct.Localidad_y_Provincia_Domicilio_Postal__c = cartProduct.localidadProvincia;
        }

        //Domicilio Bien Asegurado
        soldProduct.Calle_Bien_Asegurado__c = cartProduct.calle;
        soldProduct.Numero_Bien_Asegurado__c = cartProduct.numeroDomicilio;
        soldProduct.Piso_Bien_Asegurado__c = cartProduct.piso;
        soldProduct.Departamento_Bien_Asegurado__c = cartProduct.departamento;
        soldProduct.Codigo_Postal_Bien_Asegurado__c = cartProduct.codigoPostal;
        if(String.isNotBlank(cartProduct.localidadProvincia)){
            soldProduct.Localidad_y_Provincia_Bien_Asegurado__c = cartProduct.localidadProvincia;
        }

        //Tipo de vivienda.
        if(cartProduct.isLote){ 
            soldProduct.tipoVivienda__c = '1'; //1 corresponde a Lote 
            soldProduct.Numero_Lote__c = cartProduct.numeroLote; 
        }
        if(cartProduct.isCasa){ 
            soldProduct.tipoVivienda__c = '2'; //2 corresponde a Casa 
        }
        if(cartProduct.isDepartamento){
            soldProduct.tipoVivienda__c = '3'; //3 correspondde a Departamento
        }

        return soldProduct;
    }

    /* 
    * OBS: como mejora podria ser un solo switc sobre las coverturas que revise una clave Ramo_IdBHSeg__c|codigoCobertura asi solo se utiliza un switch para la asignacion 
    * A evaluar por que puede ser no muy claro.
    */
    @TestVisible
    private static Producto_Vendido__c addCoveregesToSoldProduct(Producto_Vendido__c pv, List<Cotizador.SumaCoberturaCotizadorWrapper> coverages){

        switch on pv.Ramo_IdBHSeg__c {
            when '2', '02' {
                pv = asignHogarCoverages(pv, coverages);
            }
            when '9', '09' {
                pv = asignATMBienesMovilesCoverages(pv, coverages);
            }
            when '17' {
                pv = asignCompraProtegidaCoverages(pv, coverages);
            }
            when '18' {
                pv = asignAccidentesPersonalesCoverages(pv, coverages);
            }
            when '19' {
                pv = asignVidaSaludCoverages(pv, coverages);
            }
            when '20' {
                pv = asignSaludColectivaCoverages(pv, coverages);
            }
        }

        return pv;
    }

    private static Producto_Vendido__c asignSaludColectivaCoverages(Producto_Vendido__c pv, List<Cotizador.SumaCoberturaCotizadorWrapper> coverages) {
        for(Cotizador.SumaCoberturaCotizadorWrapper coverage : coverages){

            switch on coverage.codigoCobertura {
                when '002' {
                    pv.CodSumaAseg01__c = coverage.codigoCobertura;
                    pv.sumaAseg01__c = String.valueOf(coverage.cotizacionAjustada); // CANCER FEMENINO
                }
                when '003' {
                    pv.CodSumaAseg02__c = coverage.codigoCobertura;
                    pv.sumaAseg02__c = String.valueOf(coverage.cotizacionAjustada); // CANCER MASCULINO
                }
                when '004' {
                    pv.CodSumaAseg05__c = coverage.codigoCobertura;
                    pv.sumaAseg05__c = String.valueOf(coverage.cotizacionAjustada); // CANCER DIAGNOSTICADO
                }
                when '005' {
                    pv.CodSumaAseg03__c = coverage.codigoCobertura;
                    pv.sumaAseg03__c = String.valueOf(coverage.cotizacionAjustada); // ADICCIONES
                }
                when '006' {
                    pv.CodSumaAseg04__c = coverage.codigoCobertura;
                    pv.sumaAseg04__c = String.valueOf(coverage.cotizacionAjustada); // SIDA
                }
                when '007' {
                    pv.CodSumaAseg06__c = coverage.codigoCobertura;
                    pv.sumaAseg06__c = String.valueOf(coverage.cotizacionAjustada); // TRANSPLANTE DE ORGANOS
                }
                when '008' {
                    pv.CodSumaAseg07__c = coverage.codigoCobertura; // PROTESIS
                    if(coverage.isAddon){
                        pv.sumaAseg07__c = String.valueOf(coverage.addonSelected.monto);
                    }else{
                        pv.sumaAseg07__c = String.valueOf(coverage.cotizacionAjustada);
                    }
                }
                when '009' {
                    pv.CodSumaAseg08__c = coverage.codigoCobertura;
                    pv.sumaAseg08__c = String.valueOf(coverage.cotizacionAjustada); // PROTESIS SENIOR
                }
                when '010' {
                    pv.CodSumaAseg09__c = coverage.codigoCobertura;
                    pv.sumaAseg09__c = String.valueOf(coverage.cotizacionAjustada); // NEONATOLOGIA EN UNIDAD DE TERAPIA INTENSIVA
                }
                when '011' {
                    pv.CodSumaAseg10__c = coverage.codigoCobertura;
                    pv.sumaAseg10__c = String.valueOf(coverage.cotizacionAjustada); // GRAN TRAUMA
                }                
                when '012' {
                    pv.CodSumaAseg11__c = coverage.codigoCobertura;
                    pv.sumaAseg11__c = String.valueOf(coverage.cotizacionAjustada); // DIAGNOSTICO DE ENFERMEDADES CRITICAS
                }
                when '013' {
                    pv.CodSumaAseg12__c = coverage.codigoCobertura;
                    pv.sumaAseg12__c = String.valueOf(coverage.cotizacionAjustada); // DROGAS ONCOLOGICAS
                }
                when '014' {
                    pv.CodSumaAseg13__c = coverage.codigoCobertura;
                    pv.sumaAseg13__c = String.valueOf(coverage.cotizacionAjustada); // CUIDADOS EN EL HOGAR
                }
                when '015' {
                    pv.CodSumaAseg14__c = coverage.codigoCobertura;
                    pv.sumaAseg14__c = String.valueOf(coverage.cotizacionAjustada); // INSUFICIENCIA RENAL CRONICA
                }
                when '016' {
                    pv.CodSumaAseg15__c = coverage.codigoCobertura;
                    pv.sumaAseg15__c = String.valueOf(coverage.cotizacionAjustada); // INTERVENCIONES QUIRURGICAS
                }
                when '017' {
                    pv.CodSumaAseg16__c = coverage.codigoCobertura;
                    pv.sumaAseg16__c = String.valueOf(coverage.cotizacionAjustada); // RDI INTERNACION QUIRURGICA
                }
                when '018' {
                    pv.CodSumaAseg17__c = coverage.codigoCobertura;
                    pv.sumaAseg17__c = String.valueOf(coverage.cotizacionAjustada); // RDI INTERNACION CLINICA
                }
                when '019' {
                    pv.CodSumaAseg18__c = coverage.codigoCobertura;// RDI CLINICA Y/O QUIRURGUCA
                    if(coverage.isAddon){
                        pv.sumaAseg18__c = String.valueOf(coverage.addonSelected.monto);
                    }else{
                        pv.sumaAseg18__c = String.valueOf(coverage.cotizacionAjustada);
                    }
                }
            }
        }

        return pv;
    }

    private static Producto_Vendido__c asignATMBienesMovilesCoverages(Producto_Vendido__c pv, List<Cotizador.SumaCoberturaCotizadorWrapper> coverages) {
        for(Cotizador.SumaCoberturaCotizadorWrapper coverage : coverages){

            switch on coverage.codigoCobertura {
                //Bienes Moviles - ATM
                when '001' {
                    pv.CodSumaAseg01__c = coverage.codigoCobertura;
                    pv.sumaAseg01__c = String.valueOf(coverage.cotizacionAjustada); // ROBO CAJERO 1
                }
                when '002' {
                    pv.CodSumaAseg02__c = coverage.codigoCobertura;
                    pv.sumaAseg02__c = String.valueOf(coverage.cotizacionAjustada); // ROBO CAJERO 2
                }
                when '003' {
                    pv.CodSumaAseg05__c = coverage.codigoCobertura;
                    pv.sumaAseg05__c = String.valueOf(coverage.cotizacionAjustada); // ROBO DOCUMENTOS
                }
                when '011' {
                    pv.CodSumaAseg03__c = coverage.codigoCobertura;
                    pv.sumaAseg03__c = String.valueOf(coverage.cotizacionAjustada); // ROBO CAJERO H1
                }
                when '012' {
                    pv.CodSumaAseg04__c = coverage.codigoCobertura;
                    pv.sumaAseg04__c = String.valueOf(coverage.cotizacionAjustada); // ROBO CAJERO H2
                }
                when '004' {
                    pv.CodSumaAseg06__c = coverage.codigoCobertura;
                    pv.sumaAseg06__c = String.valueOf(coverage.cotizacionAjustada); // ROBO EQ. ELECTRONICOS 1°EV
                }
                when '005' {
                    pv.CodSumaAseg07__c = coverage.codigoCobertura;
                    pv.sumaAseg07__c = String.valueOf(coverage.cotizacionAjustada); // ROBO EQ. ELECTRONICOS 2°EV
                }
                when '006' {
                    pv.CodSumaAseg08__c = coverage.codigoCobertura;
                    pv.sumaAseg08__c = String.valueOf(coverage.cotizacionAjustada); // ROBO CELULARES 1°EV
                }
                when '007' {
                    pv.CodSumaAseg09__c = coverage.codigoCobertura;
                    pv.sumaAseg09__c = String.valueOf(coverage.cotizacionAjustada); // ROBO CELULARES 2°EV
                }
                when '008' {
                    pv.CodSumaAseg10__c = coverage.codigoCobertura;
                    pv.sumaAseg10__c = String.valueOf(coverage.cotizacionAjustada); // ROBO PC PORTATIL
                }
                when '009' {
                    pv.CodSumaAseg11__c = coverage.codigoCobertura;
                    pv.sumaAseg11__c = String.valueOf(coverage.cotizacionAjustada); // ROBO BOLSO Y CONT. 1°EV
                }
                when '010' {
                    pv.CodSumaAseg12__c = coverage.codigoCobertura;
                    pv.sumaAseg12__c = String.valueOf(coverage.cotizacionAjustada); // ROBO BOLSO Y CONT. 2°EV
                }
                when '013' {
                    pv.CodSumaAseg13__c = coverage.codigoCobertura;
                    pv.sumaAseg13__c = String.valueOf(coverage.cotizacionAjustada); // ROBO EQ. ELECTRO Y CEL. 1°EV
                }
                when '014' {
                    pv.CodSumaAseg14__c = coverage.codigoCobertura;
                    pv.sumaAseg14__c = String.valueOf(coverage.cotizacionAjustada); // ROBO EQ. ELECTRO Y CEL. 2°EV
                }
                when '015' {
                    pv.CodSumaAseg15__c = coverage.codigoCobertura;
                    pv.sumaAseg15__c = String.valueOf(coverage.cotizacionAjustada); // ROBO EQ. ELECTRO Y PC. 1°EV
                }
                when '016' {
                    pv.CodSumaAseg16__c = coverage.codigoCobertura;
                    pv.sumaAseg16__c = String.valueOf(coverage.cotizacionAjustada); // ROBO EQ. ELECTRO Y PC. 2°EV
                }

                //Producto Movilidad (401 y 402)
                when '018' {
                    pv.CodSumaAseg01__c = coverage.codigoCobertura;
                    pv.sumaAseg01__c = String.valueOf(coverage.cotizacionAjustada); // Robo Total
                }
                when '019' {
                    pv.CodSumaAseg02__c = coverage.codigoCobertura;
                    pv.sumaAseg02__c = String.valueOf(coverage.cotizacionAjustada); // Adicional Hurto en su Vivienda Particular
                }
                when '020' {
                    pv.CodSumaAseg03__c = coverage.codigoCobertura;
                    pv.sumaAseg03__c = String.valueOf(coverage.cotizacionAjustada); // Adicional Daños como Consecuencia de Robo o su Tentativa
                }
                when '021' {
                    pv.CodSumaAseg04__c = coverage.codigoCobertura;
                    pv.sumaAseg04__c = String.valueOf(coverage.cotizacionAjustada); // Pérdida Total por Incendio y/o Daños por Accidente
                }
                when '022' {
                    pv.CodSumaAseg05__c = coverage.codigoCobertura;
                    pv.sumaAseg05__c = String.valueOf(coverage.cotizacionAjustada); // Adicional Pérdida Parcial por Incendio
                }
                when '023' {
                    pv.CodSumaAseg06__c = coverage.codigoCobertura;
                    pv.sumaAseg06__c = String.valueOf(coverage.cotizacionAjustada); // Responsabilidad Civil
                }
                when '024' {
                    pv.CodSumaAseg07__c = coverage.codigoCobertura;
                    pv.sumaAseg07__c = String.valueOf(coverage.cotizacionAjustada); // Muerte o Invalidez Total y Permanente
                }
                when '025' {
                    pv.CodSumaAseg08__c = coverage.codigoCobertura;
                    pv.sumaAseg08__c = String.valueOf(coverage.cotizacionAjustada); // Adicional por Invalidez Parcial Permanente
                }
            }
        }

        return pv;
    }

    //!Alerta: Modificado en la division de hogares.
    private static Producto_Vendido__c asignHogarCoverages(Producto_Vendido__c pv, List<Cotizador.SumaCoberturaCotizadorWrapper> coverages){
        switch on pv.Producto_IdBHSeg__c {
            when '212', '213', '214' {
                return asignNewHogarCoverages(pv, coverages);
            }
            when else {
                return asignOldHogarCoverages(pv, coverages);
            }
        }
    }

    //!Alerta: Modificado en la division de hogares.
    private static Producto_Vendido__c asignNewHogarCoverages(Producto_Vendido__c pv, List<Cotizador.SumaCoberturaCotizadorWrapper> coverages){
        for(Cotizador.SumaCoberturaCotizadorWrapper coverage : coverages){

            switch on coverage.codigoCobertura {
                    //Incendio (Modulo 1)
                when '041' {
                    pv.CodSumaAseg17__c = coverage.codigoCobertura;
                    pv.sumaAseg17__c = String.valueOf(coverage.cotizacionAjustada); // Incendio de edificio con Granizo (Cobertura 041)
                }
                when '032' {
                    pv.CodSumaAseg03__c = coverage.codigoCobertura;
                    pv.sumaAseg03__c = String.valueOf(coverage.cotizacionAjustada); // Daños por Granizo al Edificio (Cobertura 060)
                }  
                when '035' {
                    pv.CodSumaAseg04__c = coverage.codigoCobertura;
                    pv.sumaAseg04__c = String.valueOf(coverage.cotizacionAjustada); // RC por Incendio o explosion (Cobertura 035)
                }
                when '036' {
                    pv.CodSumaAseg05__c = coverage.codigoCobertura;
                    pv.sumaAseg05__c = String.valueOf(coverage.cotizacionAjustada); // Alojamiento por Incendio o Explosion (Cobertura 036)
                }  
                when '037' {
                    pv.CodSumaAseg06__c = coverage.codigoCobertura;
                    pv.sumaAseg06__c = String.valueOf(coverage.cotizacionAjustada); // Gastos de Limpieza por incendio (Cobertura 037)
                }  
                    //Contenido (Modulo 2)
                when '029' {
                    pv.CodSumaAseg07__c = coverage.codigoCobertura;
                    pv.sumaAseg07__c = String.valueOf(coverage.cotizacionAjustada); // Robo o hurto del Contenido General (Cobertura 029) 
                }  
                when '038' {
                    pv.CodSumaAseg08__c = coverage.codigoCobertura;
                    pv.sumaAseg08__c = String.valueOf(coverage.cotizacionAjustada); // Daños por Robo o intento de Robo (Cobertura 038)
                }  
                when '062' {
                    pv.CodSumaAseg01__c = coverage.codigoCobertura;
                    pv.sumaAseg01__c = String.valueOf(coverage.cotizacionAjustada); // Rotura de Cristales (Cobertura 034)
                }  
                when '053' {
                    pv.CodSumaAseg13__c = coverage.codigoCobertura;
                    pv.sumaAseg13__c = String.valueOf(coverage.cotizacionAjustada); // Robo o Hurto en Vacaciones (Cobertura 053)
                }  
                when '034' {
                    pv.CodSumaAseg12__c = coverage.codigoCobertura;
                    pv.sumaAseg12__c = String.valueOf(coverage.cotizacionAjustada); // Rotura de Cristales (Cobertura 034)
                }  
                when '058' {
                    pv.CodSumaAseg11__c = coverage.codigoCobertura;
                    pv.sumaAseg11__c = String.valueOf(coverage.cotizacionAjustada); // Daños por agua al contenido (Cobertura 058)
                }  
                    //Servicios (Modulo 3)
                when '040' {
                    pv.CodSumaAseg10__c = coverage.codigoCobertura;
                    pv.sumaAseg10__c = String.valueOf(coverage.cotizacionAjustada); // Responsabilidad Civil Hechos Privados (Cobertura 040)
                }  
                when '033' {
                    pv.CodSumaAseg09__c = coverage.codigoCobertura;
                    /*if(coverage.cotizacionAjustada == 0){
                        pv.sumaAseg12__c = String.valueOf(coverage.addonSelected.monto); // Electrodomesticos o Equipos Electronicos (Cobertura 033)
                    }else{*/
                        pv.sumaAseg09__c = String.valueOf(coverage.cotizacionAjustada); // Electrodomesticos o Equipos Electronicos (Cobertura 033)
                    /*}*/
                } 
                when '063' {
                    pv.CodSumaAseg02__c = coverage.codigoCobertura;
                    pv.sumaAseg02__c = String.valueOf(coverage.cotizacionAjustada); // Incendio del contenido (Cobertura 032)
                } 
                    //Add-Ons (Modulo 4)
                when '055' {
                    pv.CodSumaAseg15__c = coverage.codigoCobertura;
                    /*if(coverage.cotizacionAjustada == 0){*/
                        pv.sumaAseg15__c = String.valueOf(coverage.addonSelected.monto); // Resposabilidad Civil Tenencia de Animales (Cobertura 055)
                    /*}else{
                        pv.sumaAseg10__c = String.valueOf(coverage.cotizacionAjustada); // Resposabilidad Civil Tenencia de Animales (Cobertura 055)
                    }*/
                }  
                when '056' {
                    pv.CodSumaAseg18__c = coverage.codigoCobertura;
                    pv.sumaAseg18__c = String.valueOf(coverage.addonSelected.monto); // Animales Domesticos (Cobertura 056)
                }
                when '057' {
                    pv.CodSumaAseg19__c = coverage.codigoCobertura;
                    pv.sumaAseg19__c = String.valueOf(coverage.addonSelected.monto); // Robo Bicicletas (Cobertura 057)
                }
                when '064' {
                    pv.CodSumaAseg20__c = coverage.codigoCobertura;
                    pv.sumaAseg20__c = String.valueOf(coverage.addonSelected.monto); // Robo Bicicletas (Cobertura 057)
                }
            }
        }

        return pv;
    }

    //!Alerta: Modificado en la division de hogares.
    private static Producto_Vendido__c asignOldHogarCoverages(Producto_Vendido__c pv, List<Cotizador.SumaCoberturaCotizadorWrapper> coverages){
        for(Cotizador.SumaCoberturaCotizadorWrapper coverage : coverages){

            switch on coverage.codigoCobertura {
                    //Incendio (Modulo 1)
                when '061' {
                    pv.CodSumaAseg16__c = coverage.codigoCobertura;
                    pv.sumaAseg16__c = String.valueOf(coverage.cotizacionAjustada); // Incendio de edificio (Cobertura 061)
                }
                when '031' {
                    pv.CodSumaAseg01__c = coverage.codigoCobertura;
                    pv.sumaAseg01__c = String.valueOf(coverage.cotizacionAjustada); // Incendio de edificio (Cobertura 031)
                }  
                when '041' {
                    pv.CodSumaAseg17__c = coverage.codigoCobertura;
                    pv.sumaAseg17__c = String.valueOf(coverage.cotizacionAjustada); // Incendio de edificio con Granizo (Cobertura 041)
                }
                when '060' {
                    pv.CodSumaAseg02__c = coverage.codigoCobertura;
                    pv.sumaAseg02__c = String.valueOf(coverage.cotizacionAjustada); // Daños por Granizo al Edificio (Cobertura 060)
                }  
                when '035' {
                    pv.CodSumaAseg03__c = coverage.codigoCobertura;
                    pv.sumaAseg03__c = String.valueOf(coverage.cotizacionAjustada); // RC por Incendio o explosion (Cobertura 035)
                }
                when '036' {
                    pv.CodSumaAseg04__c = coverage.codigoCobertura;
                    pv.sumaAseg04__c = String.valueOf(coverage.cotizacionAjustada); // Alojamiento por Incendio o Explosion (Cobertura 036)
                }  
                when '037' {
                    pv.CodSumaAseg05__c = coverage.codigoCobertura;
                    pv.sumaAseg05__c = String.valueOf(coverage.cotizacionAjustada); // Gastos de Limpieza por incendio (Cobertura 037)
                }  
                when '040' {
                    pv.CodSumaAseg06__c = coverage.codigoCobertura;
                    pv.sumaAseg06__c = String.valueOf(coverage.cotizacionAjustada); // Responsabilidad Civil Hechos Privados (Cobertura 040)
                }  
                    //Contenido (Modulo 2)
                when '029' {
                    pv.CodSumaAseg07__c = coverage.codigoCobertura;
                    pv.sumaAseg07__c = String.valueOf(coverage.cotizacionAjustada); // Robo o hurto del Contenido General (Cobertura 029) 
                }  
                when '034' {
                    pv.CodSumaAseg08__c = coverage.codigoCobertura;
                    pv.sumaAseg08__c = String.valueOf(coverage.cotizacionAjustada); // Rotura de Cristales (Cobertura 034)
                }  
                when '032' {
                    pv.CodSumaAseg09__c = coverage.codigoCobertura;
                    pv.sumaAseg09__c = String.valueOf(coverage.cotizacionAjustada); // Incendio del contenido (Cobertura 032)
                }  
                when '055' {
                    pv.CodSumaAseg10__c = coverage.codigoCobertura;
                    /*if(coverage.cotizacionAjustada == 0){
                        pv.sumaAseg10__c = String.valueOf(coverage.addonSelected.monto); // Resposabilidad Civil Tenencia de Animales (Cobertura 055)
                    }else{*/
                        pv.sumaAseg10__c = String.valueOf(coverage.cotizacionAjustada); // Resposabilidad Civil Tenencia de Animales (Cobertura 055)
                    /*}*/
                }  
                when '038' {
                    pv.CodSumaAseg11__c = coverage.codigoCobertura;
                    pv.sumaAseg11__c = String.valueOf(coverage.cotizacionAjustada); // Daños por Robo o intento de Robo (Cobertura 038)
                }  
                    //Servicios (Modulo 3)
                when '033' {
                    pv.CodSumaAseg12__c = coverage.codigoCobertura;
                    /*if(coverage.cotizacionAjustada == 0){
                        pv.sumaAseg12__c = String.valueOf(coverage.addonSelected.monto); // Electrodomesticos o Equipos Electronicos (Cobertura 033)
                    }else{*/
                        pv.sumaAseg12__c = String.valueOf(coverage.cotizacionAjustada); // Electrodomesticos o Equipos Electronicos (Cobertura 033)
                    /*}*/
                }  
                when '058' {
                    pv.CodSumaAseg13__c = coverage.codigoCobertura;
                    pv.sumaAseg13__c = String.valueOf(coverage.cotizacionAjustada); // Daños por agua al contenido (Cobertura 058)
                }  
                when '053' {
                    pv.CodSumaAseg14__c = coverage.codigoCobertura;
                    pv.sumaAseg14__c = String.valueOf(coverage.cotizacionAjustada); // Robo o Hurto en Vacaciones (Cobertura 053)
                }  
                when '054' {
                    pv.CodSumaAseg15__c = coverage.codigoCobertura;
                    pv.sumaAseg15__c = String.valueOf(coverage.cotizacionAjustada); // Objetos Especificos (Cobertura 054)
                }
                    //Add-Ons (Modulo 4)
                /*when '056' {
                    pv.CodSumaAseg18__c = coverage.codigoCobertura;
                    pv.sumaAseg18__c = String.valueOf(coverage.addonSelected.monto); // Animales Domesticos (Cobertura 056)
                }
                when '057' {
                    pv.CodSumaAseg19__c = coverage.codigoCobertura;
                    pv.sumaAseg19__c = String.valueOf(coverage.addonSelected.monto); // Robo Bicicletas (Cobertura 057)
                }*/
            }
        }

        return pv;
    }

    private static Producto_Vendido__c asignVidaSaludCoverages(Producto_Vendido__c pv, List<Cotizador.SumaCoberturaCotizadorWrapper> coverages){
        for(Cotizador.SumaCoberturaCotizadorWrapper coverage : coverages){

            switch on coverage.codigoCobertura {
                //Vida-Salud
                when '001' {
                    pv.CodSumaAseg01__c = coverage.codigoCobertura;
                    pv.sumaAseg01__c = String.valueOf(coverage.cotizacionAjustada); // Muerte (Cobertura 001)
                }
                when '004' {
                    pv.CodSumaAseg02__c = coverage.codigoCobertura;
                    pv.sumaAseg02__c = String.valueOf(coverage.cotizacionAjustada); // Muerte Accidental (Cobertura 004)
                }
                when '005' {
                    pv.CodSumaAseg03__c = coverage.codigoCobertura;
                    pv.sumaAseg03__c = String.valueOf(coverage.cotizacionAjustada); // Diagnostico de enfermedad critica (Cobertura 005)
                }
                when '006' {
                    pv.CodSumaAseg04__c = coverage.codigoCobertura;
                    pv.sumaAseg04__c = String.valueOf(coverage.cotizacionAjustada); // Renta diaria por internacion (Cobertura 006)
                }
                when '008' {
                    pv.CodSumaAseg05__c = coverage.codigoCobertura;
                    pv.sumaAseg05__c = String.valueOf(coverage.cotizacionAjustada); // Muerte conyuge (Cobertura 008)
                }                
                when '009' {
                    pv.CodSumaAseg06__c = coverage.codigoCobertura;
                    pv.sumaAseg06__c = String.valueOf(coverage.cotizacionAjustada); // Muerte accidental conyuge (Cobertura 009)
                }
                when '011' {
                    pv.CodSumaAseg07__c = coverage.codigoCobertura;
                    pv.sumaAseg07__c = String.valueOf(coverage.cotizacionAjustada); // Cuidado prolongados (Cobertura 011)
                }
                when '013' {
                    pv.CodSumaAseg08__c = coverage.codigoCobertura;
                    pv.sumaAseg08__c = String.valueOf(coverage.cotizacionAjustada); // Gasto de sepelio (Cobertura 013)
                }
                when '003' {
                    pv.CodSumaAseg09__c = coverage.codigoCobertura;
                    pv.sumaAseg09__c = String.valueOf(coverage.cotizacionAjustada); // Gasto de sepelio (Cobertura 013)
                }
            }
        }

        return pv;
    }

    private static Producto_Vendido__c asignAccidentesPersonalesCoverages(Producto_Vendido__c pv, List<Cotizador.SumaCoberturaCotizadorWrapper> coverages){
        for(Cotizador.SumaCoberturaCotizadorWrapper coverage : coverages){

            switch on coverage.codigoCobertura {
                when '001' {
                    pv.CodSumaAseg01__c = coverage.codigoCobertura;
                    pv.sumaAseg01__c = String.valueOf(coverage.cotizacionAjustada); // Muerte accidental (Cobertura 001)
                }
                when '002' {
                    pv.CodSumaAseg02__c = coverage.codigoCobertura;
                    pv.sumaAseg02__c = String.valueOf(coverage.cotizacionAjustada); // Invalidez total y permanente (Cobertura 002)
                }
                when '003' {
                    pv.CodSumaAseg03__c = coverage.codigoCobertura;
                    pv.sumaAseg03__c = String.valueOf(coverage.cotizacionAjustada); // Renta por hospitalizacion hasta (Cobertura 003)
                }
                when '004' {
                    pv.CodSumaAseg04__c = coverage.codigoCobertura;
                    pv.sumaAseg04__c = String.valueOf(coverage.cotizacionAjustada); // Asistencia medica hasta (Cobertura 004)
                }

                /**
                 * a confirmar
                 * when '005'
                 * CodSumaAseg09__c
                 * sumaAseg09__c
                 */

                when '006' {
                    pv.CodSumaAseg05__c = coverage.codigoCobertura;
                    pv.sumaAseg05__c = String.valueOf(coverage.cotizacionAjustada); // Muerte en accidente de transito (Cobertura 006)
                }                
                when '008' {
                    pv.CodSumaAseg06__c = coverage.codigoCobertura;
                    pv.sumaAseg06__c = String.valueOf(coverage.cotizacionAjustada); // Invalidez total temporaria por accidente (Cobertura 008)
                }
                when '009' {
                    pv.CodSumaAseg07__c = coverage.codigoCobertura;
                    pv.sumaAseg07__c = String.valueOf(coverage.cotizacionAjustada); // Fractura de huesos por accidente (Cobertura 009)
                }
                when '010' {
                    pv.CodSumaAseg08__c = coverage.codigoCobertura;
                    pv.sumaAseg08__c = String.valueOf(coverage.cotizacionAjustada); // Indemnizacion por quemaduras por accidente (Cobertura 010)
                }
            }
        }

        return pv;
    }

    private static Producto_Vendido__c asignCompraProtegidaCoverages(Producto_Vendido__c pv, List<Cotizador.SumaCoberturaCotizadorWrapper> coverages){
        for(Cotizador.SumaCoberturaCotizadorWrapper coverage : coverages){

            switch on coverage.codigoCobertura {
                //Compra Protegida
                when '002' {
                    pv.CodSumaAseg01__c = coverage.codigoCobertura;
                    pv.sumaAseg01__c = String.valueOf(coverage.cotizacionAjustada); // Robo-Daño accidental - primer evento (Cobertura 002)
                }
                when '003' {
                    pv.CodSumaAseg02__c = coverage.codigoCobertura;
                    pv.sumaAseg02__c = String.valueOf(coverage.cotizacionAjustada); // Robo-Daño accidental - segundo evento (Cobertura 003)
                }
                when '004' {
                    pv.CodSumaAseg03__c = coverage.codigoCobertura;
                    pv.sumaAseg03__c = String.valueOf(coverage.cotizacionAjustada); // Robo-Daño accidental - tercer evento (Cobertura 004)
                }
                when '005' {
                    pv.CodSumaAseg04__c = coverage.codigoCobertura;
                    pv.sumaAseg04__c = String.valueOf(coverage.cotizacionAjustada); // Robo Contenido - (Cobertura 005)
                }
                when '006' {
                    pv.CodSumaAseg05__c = coverage.codigoCobertura;
                    pv.sumaAseg05__c = String.valueOf(coverage.cotizacionAjustada); // Robo Contenido - (Cobertura 006)
                }
            }
        }

        return pv;
    }

    private static String generateValidationResponseJsonString(Boolean hasError, List<String> messages, Boolean createMessagesArray){
        JSONGenerator generator = createJsonObjectWithHasError(hasError);

        generator = addErrorMessagesToJson(generator, messages, createMessagesArray);

        return closeJsonObject(generator);
    }

    private static JSONGenerator createJsonObjectWithHasError(Boolean hasError){
        JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartObject();
        generator.writeBooleanField('hasError', hasError);
        return generator;
    }

    private static JSONGenerator addErrorMessagesToJson(JSONGenerator generator, List<String> messages, Boolean createMessagesArray){
        if(createMessagesArray){
            generator.writeFieldName('errorMessages');
            generator.writeStartArray();

            for(String eachMessage : messages){
                generator.writeString(eachMessage);
            }

            generator.writeEndArray();
        }
        else {
            generator.writeStringField('message', messages[0]);
        }

        return generator;
    }

    private static String closeJsonObject(JSONGenerator json){
        json.writeEndObject();
        return json.getAsString();
    }

    private static Producto_Vendido__c addAddOnsInfo(Producto_vendido__c pv, List<Cotizador.SumaCoberturaCotizadorWrapper> addOnsCoberturas){
        List<String> addOnsInfo = new List<String>();
        for(Cotizador.SumaCoberturaCotizadorWrapper cobertura : addOnsCoberturas){
            addOnsInfo.add(cobertura.descripcionCorta + ' - Premio mensual: ' +cobertura.addonSelected.premioMensual);
        }
        pv.Add_Ons__c = String.join(addOnsInfo, ';');
        return pv;
    }

    /*
    [}--------------------------------------------------------------------------------------{]
    [}--------------------------------{>Auxiliary Methods<}--------------------------------{]
    [}--------------------------------------------------------------------------------------{]
    */

    /*
    [}-----------------------------------------------------------------------------{]
    [}--------------------------------{>WRAPPERS<}---------------------------------{]
    [}-----------------------------------------------------------------------------{]    
    */

    public class SaveSaleInputs{
    
        @InvocableVariable
        public String saleId;

        @InvocableVariable
        public String accountId;

        @InvocableVariable
        public String accountEmail;

        @InvocableVariable
        public String leadId;

        @InvocableVariable
        public String cartProducts;

        public SaveSaleInputs(){
            initialize();
        }

        public SaveSaleInputs(String saleId, String accountId, String accountEmail, String leadId, String cartProducts){
            this.saleId       = saleId;
            this.accountId    = accountId;
            this.accountEmail = accountEmail;
            this.leadId       = leadId;
            this.cartProducts = cartProducts;
        }

        private void initialize(){
            this.saleId       = '';
            this.accountId    = '';
            this.accountEmail = '';
            this.leadId       = '';
            this.cartProducts = '';
        }
        
    }

    public class SaleWrapper {
        @AuraEnabled public String accountId {get; set;}
        @AuraEnabled public String documento {get; set;}
        @AuraEnabled public Date fechaDeNacimiento {get; set;}
        @AuraEnabled public String cuitPrefijo {get; set;}
        @AuraEnabled public String cuitNumero {get; set;}
        @AuraEnabled public String cuitDigitoVerificador {get; set;}
        @AuraEnabled public String genero {get; set;}

        public SaleWrapper(){
            this.initialize();
        }
        
        private void initialize(){
            this.accountId             = '';
            this.documento             = '' ;
            this.fechaDeNacimiento     = Date.newInstance(1900, 1, 1);
            this.cuitPrefijo           = '';
            this.cuitNumero            = '';
            this.cuitDigitoVerificador = '';
            this.genero = '';
        }
    }

    public class ProductsWrapper{

        //Datos basicos
        @AuraEnabled public String sponsor {get;set;}
        @AuraEnabled public String productCode {get; set;}
        @AuraEnabled public String productName {get; set;}
        @AuraEnabled public String ramoCode {get;set;}
        @AuraEnabled public String ramoDescription {get;set;}
        @AuraEnabled public Promotion__c offer {get;set;}
        @AuraEnabled public Bases__c base {get;set;}
        /*@AuraEnabled public String planNumber {get;set;}
        @AuraEnabled public String combo {get;set;}*/
        @AuraEnabled public String premio {get;set;}
        @AuraEnabled public String cupon {get;set;}
        @AuraEnabled public String premioBase {get;set;}

        //Medio de pago
        /*
        @AuraEnabled public String medioDePago {get;set;}
        @AuraEnabled public String origenDePago {get;set;}
        @AuraEnabled public String numeroMDP {get;set;}
        @AuraEnabled public String encryptedMDP {get;set;}
        @AuraEnabled public String nombreTC {get;set;}
        @AuraEnabled public String apellidoTC {get;set;}
        @AuraEnabled public String mesTC {get;set;}
        @AuraEnabled public String anioTC {get;set;}
        @AuraEnabled public String codigoTC {get;set;}
        @AuraEnabled public Boolean isTC {get;set;}
        @AuraEnabled public Boolean isVerificado{get;set;}
        @AuraEnabled public Boolean isDecidir {get;set;}
        @AuraEnabled public Boolean isValidDecidir {get;set;}
        */
        @AuraEnabled public PaymentMethodController.SalePaymentWrapper sPaymentWrapper {get;set;}

        //Domicilio
        @AuraEnabled public String calle {get;set;}
        @AuraEnabled public String numeroDomicilio {get;set;}
        @AuraEnabled public String piso {get;set;}
        @AuraEnabled public String departamento {get;set;}
        @AuraEnabled public String numeroLote {get;set;}
        @AuraEnabled public String codigoPostal {get; set;}
        @AuraEnabled public String localidadProvincia {get; set;}
        @AuraEnabled public Boolean isCasa{get;set;}
        @AuraEnabled public Boolean isDepartamento{get;set;}
        @AuraEnabled public Boolean isLote{get;set;}

        //No-Venta
        @AuraEnabled public String motivoNoVentaCode {get;set;}
        @AuraEnabled public String motivoNoVenta {get;set;}
        @AuraEnabled public Boolean isNoVenta {get;set;}

        //Beneficiarios-Adicional
        @AuraEnabled public List<BeneficiaryController.SaleBeneficiaryWrapper> beneficiarios {get;set;}

        //Preguntas de Asegurabilidad
        @AuraEnabled public List<QuestionController.QuestionWrapper> insurabilityQuestions {get;set;}
        @AuraEnabled public String comments {get;set;}

        //Preguntas de producto
        @AuraEnabled public String rejasQuestion {get; set;}
        @AuraEnabled public String terrenoQuestion {get; set;}
        @AuraEnabled public String mediaCode {get; set;}
        @AuraEnabled public String mediaDescription {get; set;}
        @AuraEnabled public String camara {get; set;}
        @AuraEnabled public String camaraCode {get; set;}
        @AuraEnabled public Decimal altura {get; set;}
        @AuraEnabled public Integer peso {get; set;}
        @AuraEnabled public String bmiClassification {get; set;}
        @AuraEnabled public String patente {get; set;}
        @AuraEnabled public String marca {get; set;}
        @AuraEnabled public String modelo {get; set;}
        @AuraEnabled public String imei {get; set;}
        // Pregntas de Producto - Movilidad
        @AuraEnabled public String serialNumber { get; set; }
        @AuraEnabled public String typeOfGood { get; set; }
        @AuraEnabled public String ageOfGood { get; set; }
        @AuraEnabled public String typeOfUse { get; set; }


        //Vida
        @AuraEnabled public Integer cuotaPromedio {get; set;}
        @AuraEnabled public List<CotizadorController.ChildsWrapper> hijos {get; set;}

        //Enlatados
        @AuraEnabled public String cannedCode {get; set;}
        @AuraEnabled public String enlatadoDescription {get; set;}
        @AuraEnabled public String enlatadoAmbiente {get; set;}
        @AuraEnabled public String enlatadoCombo {get; set;}
        @AuraEnabled public String asistencia {get; set;}
        @AuraEnabled public String combinatoria {get; set;}
        @AuraEnabled public String existingPolicy {get; set;} //!Deprecated VD-18

        //Cotizaciones
        @AuraEnabled public List<Cotizador.SumaCoberturaCotizadorWrapper> coberturas {get; set;}

        //Rows
        @AuraEnabled public String icon {get;set;}
        @AuraEnabled public List<Map<String, String>> rowActions {get;set;}
        @AuraEnabled public Boolean validated { get; set; }
        @AuraEnabled public Integer index { get; set; }

        //Producto Vendido
        public Producto_Vendido__c soldProduct {get; set;}

        public ProductsWrapper(){
            this.initialize();
        }

        private void initialize(){

            //Datos Basicos
            this.sponsor         = '';
            this.productCode     = '';
            this.productName     = '';
            this.ramoCode        = '';
            this.ramoDescription = '';
            this.offer           = null;
            this.base            = null;
            /*this.planNumber    = '';
            this.combo           = '';*/
            this.premio          = '';
            this.cupon          = '';
            this.premioBase      = '';

            //Medio de pago
            /*
            this.medioDePago    = '';
            this.origenDePago   = '';
            this.numeroMDP      = '';
            this.encryptedMDP   = '';
            this.nombreTC       = '';
            this.apellidoTC     = '';
            this.mesTC          = '';
            this.anioTC         = '';
            this.codigoTC       = '';
            this.isTC           = false;
            this.isVerificado   = false;
            this.isDecidir      = false;
            this.isValidDecidir = false;
            */
            this.sPaymentWrapper = new PaymentMethodController.SalePaymentWrapper();

            //Domicilio
            this.calle              = '';
            this.numeroDomicilio    = '';
            this.piso               = '';
            this.departamento       = '';
            this.numeroLote         = '';
            this.codigoPostal       = '';
            this.localidadProvincia = '';
            this.isCasa             = false;
            this.isDepartamento     = false;
            this.isLote             = false;

            //No-Venta
            this.motivoNoVentaCode = '';
            this.motivoNoVenta = '';
            this.isNoVenta     = false;

            //Beneficiarios
            this.beneficiarios = new List<BeneficiaryController.SaleBeneficiaryWrapper>();

            //Preguntas de asegurabilidad
            this.insurabilityQuestions = new List<QuestionController.QuestionWrapper>();
            this.comments = '';

            //Preguntas de producto
            this.rejasQuestion      = '';
            this.terrenoQuestion    = '';
            this.mediaCode          = '';
            this.mediaDescription   = '';
            this.camara             = '';
            this.camaraCode         = '';
            this.altura             = 0;
            this.peso               = 0;
            this.bmiClassification  = '';
            this.patente            = '';
            this.marca              = '';
            this.modelo             = '';
            this.serialNumber       = '';
            this.typeOfGood         = '';
            this.ageOfGood         	= '';
        	this.typeOfUse         	= '';

            //Vida
            this.cuotaPromedio 		= 0;
            this.hijos         		=  new List<CotizadorController.ChildsWrapper>();

            //Enlatados
            this.cannedCode          = '';
            this.enlatadoDescription = '';
            this.enlatadoAmbiente    = '';
            this.enlatadoCombo       = '';
            this.asistencia          = '';
            this.combinatoria        = '';
            this.existingPolicy      = ''; //!Deprecated VD-18

            //Cotizaciones
            this.coberturas          = new List<Cotizador.SumaCoberturaCotizadorWrapper>();

            //Rows
            this.icon       = 'utility:cart';
            this.rowActions = new List<Map<String, String>>{ 
                new Map<String, String>{'label' => 'Editar', 'name' => 'editVenta', 'iconName' => 'utility:edit'},
                new Map<String, String>{'label' => 'Cambiar a No Venta', 'name' => 'noVenta', 'iconName' => 'utility:archive'},
                new Map<String, String>{'label' => 'Eliminar', 'name' => 'delete', 'iconName' => 'utility:delete'}
            };
            this.validated = false;
            this.index = -1;
        }
    }

    @AuraEnabled
    public static Boolean isCommunity(){
        return Utils.isCommunity();
    }

    public class DTOisCommunityAndLicence {
        @AuraEnabled
        public Boolean isCommunity;
        @AuraEnabled
        public String licence;
	}

    @AuraEnabled
    public static DTOisCommunityAndLicence isCommunityAndGetTypeLicence(){
        DTOisCommunityAndLicence DTO = new DTOisCommunityAndLicence();

        DTO.isCommunity = Utils.isCommunity();
        User licenceUser = [Select Id, Profile.UserLicense.Name from User where Id =: UserInfo.getUserId() limit 1];
        DTO.licence = licenceUser.Profile.UserLicense.Name;

        return DTO;
    }

    /*
    [}-----------------------------------------------------------------------------{]
    [}--------------------------------{>WRAPPERS<}---------------------------------{]
    [}-----------------------------------------------------------------------------{]    
    */
}