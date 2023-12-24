/**
 * @description       : 
 * @author            : Agustin Ignacio Martinez Bisagno
 * @group             : Xappia
 * @last modified on  : 04-04-2022
 * @last modified by  : agustin.martinez@globant.com
 * Modifications Log 
 * Ver   Date         Author                        Modification
 * 1.0   Unknown      victor.degano@xappia.com      Initial Version
**/
public inherited sharing class CotizadorRamoVida extends Cotizador {

    //!New
    /**
     * Calcula todas las coberturas con el ajuste porcentual (-10, 0, 10, etc) recibidas como parametro.
     * Recalcula dependiendo si la cotizacion inicial es distinta a la cotizacion ajustada (eso quiere decir que se ajusto manualmente)
    **/
    public override List<SumaCoberturaCotizadorWrapper> calcularPorAjustePorcentual(
        Integer ajustePorcentual,
        List<SumaCoberturaCotizadorWrapper> coberturas
    ) {
        try {
            for (Integer i = 0; i < coberturas.size(); i++) {
                coberturas[i] = calcularCoberturaPorAjustePorcentual(
                    ajustePorcentual,
                    coberturas[i]
                );
            }
        } catch (Exception e) {
            CreateApexLog.create(
                new Map<MapLogArgKey, Object>{
                    MapLogArgKey.EXCEPTIONINFO => e,
                    MapLogArgKey.CLASSINFO => 'CotizadorController',
                    MapLogArgKey.METHODINFO => 'calcularPorAjustePorcentual'
                }
            );
            throw e;
        }
        return coberturas;
    }

    //!New
    /**
     * Calcula la suma cobertura en base a un ajuste porcentual y recalculando los sublimites si corresponden.
    **/
    private SumaCoberturaCotizadorWrapper calcularCoberturaPorAjustePorcentual(Integer ajuste, SumaCoberturaCotizadorWrapper cobertura) {
        if (cobertura.isHired()) {
            cobertura.calcularPorPorcentajeDeAjuste(ajuste, 'INICIAL');
        } else {
            cobertura.resetCotizacionesToZero();
        }
        return cobertura;
    }

    //!New
    /**
     * Metodo que recalcula las sumas iniciales de las coberturas seteando la cotizacion ajustada y la inicial como la actual de la poliza.
     * Recalcula Los Limites de los monto. SOLO se utiliza para cuando se inicia el flow, y se prenden o apagan la cotizacion por M2 o por Ajuste Porcentual
    **/
    public override List<SumaCoberturaCotizadorWrapper> cargarCoberturasActual(List<SumaCoberturaCotizadorWrapper> coberturas) {
        try {
            for (Integer i = 0; i < coberturas.size(); i++) {
                coberturas[i] = cargarCoberturaActual(
                    coberturas[i]
                );
            }
        } catch (Exception e) {
            CreateApexLog.create(
                new Map<MapLogArgKey, Object>{
                    MapLogArgKey.EXCEPTIONINFO => e,
                    MapLogArgKey.CLASSINFO => 'CotizadorController',
                    MapLogArgKey.METHODINFO => 'cargarCoberturasActual'
                }
            );
            throw e;
        }
        return coberturas;
    }

    //!New
    /**
     * Resetea las cobertura con los valores de la cotizacionactual (La cotizacion de la poliza a retener) realizando el reseteo de flags.
     */
    private SumaCoberturaCotizadorWrapper cargarCoberturaActual(SumaCoberturaCotizadorWrapper cobertura) {
        if (cobertura.isHired()) {
            cobertura.resetCotizacionesToActual();
            cobertura.controlarLimitesSumaActual();
            cobertura.controlarLimitesSumaInicial();
        } else {
            cobertura.resetCotizacionesToZero();
        }
        return cobertura;
    }

    public override CotizadorResult obtenerPremioDeProducto(CotizadorRequest request) {
        /*Decimal tasaPrimerRiesgo = 0;//request.infoDemografica.Rate__c;
        Decimal tasaPrimaPuraRecargoSeguridad = this.calcularTasaPrimaPuraMasRiesgoSeguridad(tasaPrimerRiesgo, request.gastos.get('Recargo Seguridad'));
        Decimal primaPuraMasSeguridad = this.calcularSumaPrimaPuraMasRiesgoSeguridad(request.sumaCoberturas[0].cotizacionAjustada, tasaPrimaPuraRecargoSeguridad);*/

        Decimal primaPura = this.calcularSumaPrimaPura(request.sumaCoberturas, request.infoDemografica);
        Decimal primaPuraMasSeguridad = this.calcularPrimaPuraMasRiesgoSeguridad(primaPura, request.gastos.get('Recargo Seguridad'));
        
        Decimal primaTarifa = this.calcularPrimaDeTarifa(primaPuraMasSeguridad, request.gastos.get('Gasto de Adquisicion'), request.gastos.get('Gasto de Administracion'));
        Decimal tasaSSN = this.calcularSumaTasaSSN(primaTarifa, request.gastos.get('Tasa SSN'));
        Decimal premioSinSellos = primaTarifa + tasaSSN;
        Decimal sellos = this.calcularSelloProvincial(getSumaAseguradaToSelloProvincial(request.sumaCoberturas, request.impuestoProvincial)/*(request.sumaCoberturas[0].cotizacionAjustada + request.sumaCoberturas[2].cotizacionAjustada)*/, primaTarifa, premioSinSellos, request.impuestoProvincial);
        Decimal premioConSellos = premioSinSellos + sellos;
        premioConSellos = premioConSellos.setscale(2);

        CotizadorResult result = new CotizadorResult();
        result.premioAnual = premioConSellos;
        result.premioMensual = (premioConSellos / 12).setscale(2);

        result.premioAnualSinSellos = premioSinSellos;
        result.premioMensualSinSellos = (premioSinSellos / 12).setscale(2);

        result.sellos = sellos;

        result.primeraCuotaMasSellos = result.premioMensualSinSellos + sellos;

        return result;
    }

    /*@TestVisible
    private Decimal calcularTasaPrimaPuraMasRiesgoSeguridad(Decimal tasaPrimerRiesgo, Decimal gastoRecargoSeguridad) {
        // Formula: Tasa_Prima_Pura * (1 + Riesgo_Seguridad)
        return tasaPrimerRiesgo * (1 + gastoRecargoSeguridad);
    }

    @TestVisible
    private Decimal calcularSumaPrimaPuraMasRiesgoSeguridad(Decimal sumaAsegurada, Decimal tasaPPmasRS) {
        // Formula: Suma_Asegurada * Tasa_Prima_Pura_Recargo_Seguridad
        return sumaAsegurada * tasaPPmasRS;
    }*/

    @TestVisible
    private Decimal calcularSumaPrimaPura(List<Cotizador.SumaCoberturaCotizadorWrapper> sumaCoberturas, Map<String, Informacion_Demografica__c> infoDemografica) {
        // Formula: Suma_Asegurada * Tasa_Prima_Pura_Recargo_Seguridad
        Decimal result = 0;
        for(Cotizador.SumaCoberturaCotizadorWrapper sumaCobertura : sumaCoberturas){
            result = result + (sumaCobertura.cotizacionAjustada * infoDemografica.get(sumaCobertura.codigoCobertura).Rate__c);
        }
        return result;
    }

    @TestVisible
    private Decimal calcularPrimaPuraMasRiesgoSeguridad(Decimal primaPura, Decimal gastoRecargoSeguridad) {
        // Formula: Tasa_Prima_Pura * (1 + Riesgo_Seguridad)
        return primaPura * (1 + gastoRecargoSeguridad);
    }

    @TestVisible
    private Decimal calcularPrimaDeTarifa(Decimal sumaPPmasRs, Decimal gastoAdquicision, Decimal gastoAdministracion) {
        // Formula: Suma_Prima_Pura_Recargo_Seguridad / (1 - Gasto_Adquicision - Gasto_Aadministracion)
        return sumaPPmasRs / (1 - gastoAdquicision - gastoAdministracion);
    }

    @TestVisible
    private Decimal calcularSumaTasaSSN(Decimal primaDeTarifa, Decimal gastoTasaSSN) {
        // Formula: Prima_de_Tarifa * Gasto_Tasa_SSN
        return primaDeTarifa * gastoTasaSSN;
    }

    private Decimal getSumaAseguradaToSelloProvincial(List<Cotizador.SumaCoberturaCotizadorWrapper> sumaCoberturas, Impuesto_Provincial__c impuestoProvincial) {

        Decimal result = 0;

        for(Cotizador.SumaCoberturaCotizadorWrapper suma : sumaCoberturas){
            switch on impuestoProvincial.Province_Code__c {
                // Se calculan el sello a: CORDOBA:4, CORRIENTES:5, CHACO:6, CHUBUT:7, FORMOSA:8, ENTRE RIOS:9, LA PAMPA:11, LA RIOJA:12, MENDOZA:13, MISIONES:14, NEUQUEN:15, RIO NEGRO:16, SALTA:17, SAN JUAN:18, SAN LUIS:19, SANTA CRUZ:20, SANTA FE:21
                when '6','9','12','15','18'{
                    result += '001'.equalsIgnoreCase(suma.codigoCobertura) || '004'.equalsIgnoreCase(suma.codigoCobertura) || '013'.equalsIgnoreCase(suma.codigoCobertura) ? suma.cotizacionAjustada :  0;
                }
                when '8','21' {
                    result += '001'.equalsIgnoreCase(suma.codigoCobertura) ? suma.cotizacionAjustada :  0;
                }
                when else {
                    result += suma.codigoCobertura != '005' ? suma.cotizacionAjustada :  0;
                }
            }
        }

        return result;
    }

    // Formula en Partes
    // A- SI ( Monto_base < Limite_Tasa) entonces "B"
    // B- Sello = 0 (Si se cumple "A")
    // C - SI ( Alicuota_calculada <= Tasa_minima ) entonces (Tasa_minima)
    // D - monto_base * alicuota = Alicuota Calculada
    // Condiciones
    // SI: A -> B
    // SI: NO A -> C
    // SI: NO C -> D
    // Formula donde SI(condicion;verdadero;falso)
    // SI (A; B; SI(C; Tasa_Minima; D) )
    @TestVisible
    private Decimal calcularSelloProvincial(
        Decimal sumaAsegurada,
        Decimal primaTarifa,
        Decimal premio,
        Impuesto_Provincial__c impuestoProvincial
    ) {
        Decimal montoSellos;
        switch on impuestoProvincial.Province_Code__c {
            // Se calculan el sello a: CORDOBA:4, CORRIENTES:5, CHACO:6, CHUBUT:7, FORMOSA:8, ENTRE RIOS:9, LA PAMPA:11, LA RIOJA:12, MENDOZA:13, MISIONES:14, NEUQUEN:15, RIO NEGRO:16, SALTA:17, SAN JUAN:18, SAN LUIS:19, SANTA CRUZ:20, SANTA FE:21
            when '4','5','6','7','8','9','11','12','13','14','15','16','17','18','19','20','21'{
                Decimal montoBase;
                switch on impuestoProvincial.Tax_Base__c.toUpperCase() {
                    when 'CAPITAL' {
                        montoBase = sumaAsegurada;
                    } when 'PRIMA' {
                        montoBase = primaTarifa;
                    } when 'PREMIO' {
                        montoBase = premio;
                    } when else {
                        montoBase = 0;
                    }
                }

                Decimal primaRioNegro = 0;
                Boolean isRioNegro = '16'.equalsIgnoreCase(impuestoProvincial.Province_Code__c);
                if ( isRioNegro ) {
                    primaRioNegro = primaTarifa;
                }

                montoSellos = this.calcularSello(montoBase, impuestoProvincial, isRioNegro, primaRioNegro);
            } when else { // Exentos: CAPITAL FEDERAL:1, BUENOS AIRES:2, CATAMARCA:3, JUJUY:10, SANTIAGO DEL ESTERO:22, TIERRA DEL FUEGO:23, TUCUMAN:24
                montoSellos = 0;
            }
        }
        return montoSellos;
    }

    // A- SI ( Monto_base < Limite_Tasa) entonces "0" sino "calculo_de_alicuota"
    // CASO RIO NEGRO (Prima_TARIFA < Limite_tasa ) entonces "0" sino "calculo_de_alicuota"
    @TestVisible
    private Decimal calcularSello(Decimal monto, Impuesto_Provincial__c impuestoProvincial, Boolean isRioNegroProvince, Decimal primaTarifaRioNegro) {
        if ( monto < impuestoProvincial.Taxable_Limit__c  || ( isRioNegroProvince && primaTarifaRioNegro <= impuestoProvincial.Taxable_Minimum__c) ) {
            return 0;
        } else {
            return
                this.obtenerSelloMinimo(
                    this.calcularAlicuotaSello(monto,impuestoProvincial.Alicuota__c),
                    impuestoProvincial,
                    monto,
                    isRioNegroProvince
            );
        }
    }


    // B- SI ( Alicuota_calculada <= Tasa_minima ) entonces 'Tasa_minima, sino 'Alicuota_calculada'
    @TestVisible
    private Decimal obtenerSelloMinimo ( Decimal alicuotaCalculada, Impuesto_Provincial__c impuestoProvincial, Decimal monto, Boolean isRioNegroProvince) {
        if ( ( ! isRioNegroProvince && alicuotaCalculada <= impuestoProvincial.Taxable_Minimum__c)/*  || ( isRioNegroProvince && monto <= impuestoProvincial.Taxable_Minimum__c )*/) {
            return impuestoProvincial.Taxable_Minimum__c;//isRioNegroProvince ? 0 : impuestoProvincial.Taxable_Minimum__c;
        } else {
            return alicuotaCalculada;
        }
    }

    // D - monto_base * alicuota = Alicuota Calculada
    private Decimal calcularAlicuotaSello (Decimal monto, Decimal alicuota) {
        return monto * alicuota;
    }
}