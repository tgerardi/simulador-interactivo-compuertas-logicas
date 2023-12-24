/**
 * @description       : 
 * @author            : Agustin Ignacio Martinez Bisagno
 * @group             : Xappia
 * @last modified on  : 12-13-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   Unknown      Unknown       Initial Version
**/
public without sharing class UtilsRequest {
	
	@TestVisible
	private final static String BENEFICIARY_SIZE_ERROR = 'Se adminen hasta 4 beneficiarios';

	@TestVisible
	private final static String BENEFICIARY_PERCENTAGE_ERROR = 'La sumatoria de los porcentajes tiene que ser 100%';


	//Insert Change Payment Method from CMDP Prestamo Object
	public static String insertChangePaymentMethodRequest(CMDP_Prestamo__c prestamo) {
		System.debug('insertChangePaymentMethodRequest()');
		Gestion__c requestToInsert = new Gestion__c();

		try {
			requestToInsert.RecordTypeId = [SELECT ID
			                                FROM RecordType
			                                WHERE DeveloperName = 'Cambio_Medio_Pago'].Id;
			System.debug('requestToInsert.RecordTypeId: ' + requestToInsert.RecordTypeId);
			requestToInsert.Cuenta__c = [SELECT id
			                             FROM Account
			                             WHERE Id_Cliente_BHSeg__c = :prestamo.id_cliente_bhseg__c].Id;
			System.debug('requestToInsert.Cuenta__c: ' + requestToInsert.Cuenta__c);

			System.debug('prestamo.ramo__c: ' + prestamo.ramo__c);
			System.debug('prestamo.poliza__c: ' + prestamo.poliza__c);
			System.debug('prestamo.certificado__c: ' + prestamo.certificado__c);
			System.debug('requestToInsert.Cuenta__c: ' + requestToInsert.Cuenta__c);
			requestToInsert.Poliza__c = [SELECT Id
			                             FROM Poliza__c
			                             WHERE Ramo_IdBHSeg__c = :prestamo.ramo__c
			                             AND Poliza__c = :prestamo.poliza__c
			                             AND Certificado__c = :prestamo.certificado__c
			                             //AND Endoso__c = :prestamo.endoso__c
			                             AND Cuenta__c = :requestToInsert.Cuenta__c].Id;
			System.debug('requestToInsert.Poliza__c: ' + requestToInsert.Poliza__c);

			requestToInsert.Estado__c = 'P';
			requestToInsert.Resultado__c = '110';
			requestToInsert.Observaciones__c = '';
			requestToInsert.Tramite__c = '52';
			requestToInsert.Novedad__c = 'PAG';
			//requestToInsert.CreatedById = ''; TODO valores mock de una custom setting
			requestToInsert.Medio_de_Pago__c = 'TARJETA DE CREDITO';
			requestToInsert.Origen_de_Pago__c = prestamo.Origen_de_Pago__c;
			requestToInsert.Token_de_Pago__c = prestamo.token__c;

			requestToInsert.mtPremioRef__c = String.valueOf(prestamo.premio_actual__c);
			requestToInsert.mtBonifRef__c = String.valueOf(prestamo.premio_con_descuento__c);

			requestToInsert.CMDP_Con_Bonificacion__c = true;
			requestToInsert.Estado_Comunicacion_Rector__c = 'Para Enviar';

			insert requestToInsert;

		} catch(Exception e) {
            CreateApexLog.create(new Map<MapLogArgKey, Object> {MapLogArgKey.EXCEPTIONINFO => e});
			System.debug(e.getMessage());
			System.debug(e.getStackTraceString());
			return 'ERROR ' + e.getMessage();
		}

		try {
			prestamo.Estado_Gestion__c = 'Enviado';
			prestamo.Gestion__c = requestToInsert.Id;
			update prestamo;
		} catch(Exception e) {
            CreateApexLog.create(new Map<MapLogArgKey, Object> {MapLogArgKey.EXCEPTIONINFO => e});
			System.debug(e.getMessage());
		}

		return 'OK';
	}

	/* Crea e inserta una venta completa (Venta + Producto Vendido) en base a el lead que se recibe. Esto es parte del flujo de Venta Web*/
	public static String insertSell(Lead newLead) {
		System.debug('insertSell()');
		System.debug('newLead: ' + newLead);
		System.debug(newLead.Cod_Ramo__c + ' - ' + newLead.Cod_Producto__c + ' - ' + newLead.Cod_Plan__c);

		Venta__c venta;
		Producto_Vendido__c pv;
		if(newLead.Intentos_de_Conversion__c == null ){
			newLead.Intentos_de_Conversion__c = 0;
		}
		if(newLead.Intentos_de_Conversion_Fallidos__c == null ){
			newLead.Intentos_de_Conversion_Fallidos__c = 0;
		}
		newLead.Intentos_de_Conversion__c += 1;

		try {
			venta = insertVenta(newLead);
			insert venta;
			System.debug('venta:' + venta.Id);
            pv = insertProductoVendido(venta, newLead);
			insert pv;
			
			associateBeneficiariosDeVenta(pv,newlead);
			
		} catch(Exception e) {
			CreateApexLog.create(new Map<MapLogArgKey, Object> { MapLogArgKey.EXCEPTIONINFO => e });

			newLead.Intentos_de_Conversion_Fallidos__c += 1;

			if(venta != null && venta.id != null){
				//we make a rollback by deleting the venta__c previously inserted
				try {
					DELETE venta;
				} catch(Exception ex) {
					CreateApexLog.create(new Map<MapLogArgKey, Object> { MapLogArgKey.EXCEPTIONINFO => e });
					System.debug(ex.getMessage());
				}
			}

			System.debug('Exception: ' + e.getMessage());
			newLead.Observacion__c = e.getTypeName() +': '+ e.getMessage();
			return 'ERROR: ' + e.getMessage();
		}

		if(pv != null && String.isNotEmpty(pv.Observacion__c)){
			newLead.Observacion__c = pv.Observacion__c;
			return 'WARNING';
		}

		newLead.Paso_de_Venta__c = 'VENTA';
		newLead.Convertido_a_Venta__c = true;
		return 'OK';
	}


	/** Metodo que se encarga de crear el objeto "Venta" en base a un lead.*/
    public static Venta__c insertVenta(Lead newLead){
		System.debug('Entreo en insert venta');
		Venta__c venta = new Venta__c();

		Venta.Fecha_de_Nacimiento__c = newLead.FECHA_NACIMIENTO__c;
		Venta.Pais_de_Nacimiento__c = newLead.Pais_Nacimiento__c;
		venta.Estado_Civil__c = newLead.Estado_Civil__c;
		venta.Nacionalidad__c = newLead.NACIONALIDAD__c;
		venta.Apellido__c = newLead.LastName;
		Venta.Nombre__c = newLead.FirstName;
		venta.Genero__c = newLead.Sexo__c;
		venta.Numero_de_Documento__c = newLead.DNI__c;
        if('DNI'.equalsIgnoreCase(newLead.Tipo_de_Documento__c)){
            venta.Tipo_de_Documento__c = 'D.N.I.';
        } else {
            venta.Tipo_de_Documento__c = newLead.Tipo_de_Documento__c;
        }

		String cuilResult = Utils.CalcularCuil(newLead.DNI__c, newLead.Sexo__c == 'Masculino' ? 'M' : 'F');
		if (String.isNotBlank(cuilResult)) {
			venta.CUIL_CUIT_Prefijo__c = cuilResult.substring(0, 2);
			venta.CUIL_CUIT_Numero__c = cuilResult.substring(2, 10);
			venta.CUIL_CUIT_Digito_Verificador__c = cuilResult.substring(cuilResult.length() - 1, cuilResult.length());
		}

		//Contact Data
		Venta.caracteristica_celular__c = newLead.Codigo_de_area__c;
		Venta.Celular__c = newLead.Phone;
		venta.Email__c = newLead.Email;

		//Address Data (Domicilio real)
		venta.Departamento__c = newLead.DPTO_DOMICILIO__c;
		venta.Numero__c = String.valueOf(Math.round(newLead.NUMERO_DOMICILIO__c));
		venta.Calle__c = newLead.Street;
		Venta.Piso__c = newLead.PISO_DOMICILIO__c;
		Venta.Numero_Lote__c = newLead.Numero_Lote__c;

		Localidad_Provincia__c locAndProv =
			Utils.GetCodLocalidadProvincia(newLead.domicilio_localidad__c, newLead.domicilio_provincia__c, newLead.PostalCode);

		if (locAndProv == null) {
			throw new DmlException('LOCALIDAD Y PROVINCIA NOT FOUND');
		}

		venta.Localidad_Provincia__c = locAndProv.Id;
		if(String.isNotBlank(locAndProv.Codigo_Postal__c)){
			venta.Codigo_Postal__c = locAndProv.Codigo_Postal__c;
		} else{
			venta.Codigo_Postal__c = newLead.PostalCode;
		}

        return venta;
    }

	/**Arma un producto vendido para el lead y venta recibidos. Utiliza los datos del lead para completar los datos del producto vendido. */
    public static Producto_Vendido__c insertProductoVendido(Venta__c venta, Lead newLead ){
		System.debug('entro prod vendido');
        Producto_Vendido__c pv = new Producto_Vendido__c();

		//Record Type
		pv.RecordTypeId = QueryUtils.getRecordTypeVenta();

		//Rector Connection fields
		pv.Estado_Comunicacion_Rector__c = 'Para Enviar';

		//Relaciones
		pv.Venta__c = venta.Id;
		pv.Candidato__c = newLead.id;
		pv.Cupon__c = newLead.Cupon__c;
		
		//Origen de la venta
		pv.Source__c = newLead.LeadSource;

		///Informacion Basica
		pv.Sponsor__c = newLead.Sponsor__c;
		System.debug(String.valueOf(Math.round(newLead.Cod_Ramo__c)));
		pv.Ramo_IdBHSeg__c = String.valueOf(Math.round(newLead.Cod_Ramo__c));
        pv.Ramo__c = newLead.Desc_Producto__c;
		
		String codProductoStr =	String.valueOf(Integer.valueOf(newLead.Cod_Producto__c));
		pv.Producto_IdBHSeg__c = '0'.repeat(3 - codProductoStr.length()) + codProductoStr;

		pv.Plan_IdBHSeg__c = newLead.Cod_Plan__c;

		//Medio de pago
		pv.Apellido_Titular_TC__c = newLead.TC_Titular_Apellido__c;
		pv.Nombre_Titular_TC__c = newLead.TC_Titular_Nombre__c;
		pv.Origen_de_Pago__c = XMLDataConversion.originOfPaymentFromXml(newLead.Origen_de_Pago__c, newLead.Medio_de_Pago__c);
		pv.Medio_de_Pago__c = XMLDataConversion.meansOfPaymentFromXml(newLead.Medio_de_Pago__c);
		/*pv.Medio_de_Pago_Encriptado__c = true;*/
		if(newLead.LeadSource == 'CECA' 
			|| newLead.LeadSource == 'FOTA' 
			|| (newLead.LeadSource == 'MAP' 
				&& newLead.Cod_Ramo__c == 2 
				&& newLead.Cod_Producto__c == 217)){
			pv.Mecanismo_Encriptacion__c = 'INTERNO';
		}else if (newLead.LeadSource == 'MAP' 
			&& newLead.Cod_Ramo__c == 2 
			&& newLead.Cod_Producto__c == 216) {
			pv.Mecanismo_Encriptacion__c = 'NO APLICA';
		}else{
			pv.Mecanismo_Encriptacion__c =  'CBU'.equalsIgnoreCase(pv.Origen_de_Pago__c) ? 'PLANO':'DECIDIR';
		}
		pv.Numero_TC__c = newLead.Pago__c; //Viene encriptada y va asi a rector

        //El vencimiento de la tarjeta de credito llega como un numero de 3 u 4 digitos.
        if(String.isNotBlank(newLead.TC_Vencimiento__c)){
            /* Para poder pasarlo bien a fecha, nos quedamos con los 2 primeros digitos del año actual
             luego con los sub string correspondientes armamos el mes y el año.
             Tc_Vencimiento puede tener una longuitud de 3 a 4 caracteres (mYY o mmYY),
             el replace es por el formateo del integer. Segun si lo parsea en ES o US usa la ',' o el '.' para los miles*/
            String firstPartOfYear = Date.today().year().format().replaceAll('[\\.\\,]','').substring(0, 2);
            Integer year;
            Integer month;
            if (newLead.TC_Vencimiento__c.length() == 3){
                month = Integer.valueOf(newLead.TC_Vencimiento__c.substring(0, 1));
                year = Integer.valueOf(firstPartOfYear + newLead.TC_Vencimiento__c.substring(1));
            } else {
                month = Integer.valueOf(newLead.TC_Vencimiento__c.substring(0, 2));
                year = Integer.valueOf(firstPartOfYear + newLead.TC_Vencimiento__c.substring(2));
			}

            pv.Fecha_Vencimiento_TC__c = Date.newInstance(year,month,01);
		}
		
		//Postal Address => Inherits from real Address
		pv.Localidad_y_Provincia_Domicilio_Postal__c = venta.Localidad_Provincia__c;
		pv.Codigo_Postal_Domicilio_Postal__c = venta.Codigo_Postal__c;
		pv.Departamento_Domicilio_Postal__c = venta.Departamento__c;
		pv.Numero_Domicilio_Postal__c = venta.Numero__c;
		pv.Calle_Domicilio_Postal__c = venta.Calle__c;
		pv.Piso_Domicilio_Postal__c = venta.Piso__c;

		//Insured Property Address => Inherits from real Address
		pv.Localidad_y_Provincia_Bien_Asegurado__c = venta.Localidad_Provincia__c;
		pv.Codigo_Postal_Bien_Asegurado__c = venta.Codigo_Postal__c;
		pv.Departamento_Bien_Asegurado__c = venta.Departamento__c;
		pv.Numero_Bien_Asegurado__c = venta.Numero__c;
		pv.Calle_Bien_Asegurado__c = venta.Calle__c;
		pv.Piso_Bien_Asegurado__c = venta.Piso__c;

		//here
		pv = addPaymentMethodCuponsToSoldProduct(pv);

		switch on  String.valueOf(Math.round(newLead.Cod_Ramo__c)){
			when '2' {
                if(newLead.Cod_Producto__c == 219){
                    pv = addCotizacionAbiertaSoldProduct(pv, newLead);
                }else{
                    pv = addHogarProtegidoIIIDataToSoldProduct(pv, newLead);
                }
				
			}
			when '20' {
			//aca iria beneficiarios cuando se implemente
			//validateBeneficiary(newLead);
			pv = addSaludIntegralToSoldProduct(pv, newLead);
			}
			when '19' {
				validateBeneficiary(newLead);
				pv = addVidaDataToSoldProduct(pv, newLead);
			}
			when '17' {
				pv = addRoboContenidoDatatoSoldProduct(pv, newLead);
			}
			when '18' {
				validateBeneficiary(newLead);
				pv = addAccidentesPersonalesDatatoSoldProduct(pv, newLead);
			}
			when '9' {
				pv = addBiensMovilesDatatoSoldProduct(pv, newLead);
				
			}
			when else {
				//Do Nothing
			}
		}
        return pv;
	}

	///VD
	private static Producto_Vendido__c addPaymentMethodCuponsToSoldProduct(Producto_Vendido__c soldProduct){

		String ramo = String.valueOf(soldProduct.Ramo_IdBHSeg__c);
		String producto = String.valueOf(soldProduct.Producto_IdBHSeg__c);
		
		List<Bonificaciones_por_Cupon__c> bc = [ SELECT Id, 
		Codigo_Producto__c, Codigo_Ramo__c, Cuotas_Bonificadas__c, 
		Procentaje_Bonificado__c, Productor__c, Tipo_de_Cupon__c, Activo__c, Cupon__c 
		FROM Bonificaciones_por_Cupon__c 
		WHERE Codigo_Producto__c = :producto AND 
		Codigo_Ramo__c = :ramo AND Productor__c = :soldProduct.Sponsor__c AND Cupon__c =: soldProduct.Cupon__c AND Activo__c =:true
		LIMIT 1
		];
		if(!bc.isEmpty()){
			soldProduct.id_bonificacion__c = bc[0].Tipo_de_Cupon__c;
			soldProduct.cuotas_bonificacion__c = bc[0].Cuotas_Bonificadas__c;
			soldProduct.porcentaje_bonificacion__c =  bc[0].Procentaje_Bonificado__c;
		}
      
        return soldProduct;
    }

	//17-501
	private static Producto_Vendido__c addRoboContenidoDataToSoldProduct(Producto_Vendido__c pv, Lead newLead) {

		String errorMessage = 'WARNING: ';
		Boolean hasError = false;
		Enlatado__C canned;
		Map<String,String> coberturas = new Map<String,String>();
		Map<String,Coverages_Names__c> coveragesNames = new Map<String,Coverages_Names__c>();

		try{
			canned = Queryutils.getEnlatadoWithCoberturaEnlatadosById(newLead.COMBINATORIA__c);
			coberturas = getCoveragesAmountByCoverageCode(canned.Coberturas_enlatado__r);
		} catch (Exception e) {
			hasError |= true;
			errorMessage += 'Enlatado: '+ e.getMessage()+'.';
		}

		
		try{
			coveragesNames = getCoveragesNamesByCode(String.valueOf(Math.round(newLead.Cod_Ramo__c)));
		} catch (Exception e) {
			hasError |= true;
			errorMessage += 'Nombres de Coberturas: '+ e.getMessage();
		}

		if(canned != null){
			pv.metrosCuadrados__c = canned.Ambiente__c;
			pv.combinatoria__c = canned.Asistencia__c.substring(0,3).toUpperCase(); 
			
			pv.Premio_Base__c = canned.Premio__c;
		}

		if ( !hasError ) {

			/*
			pv.sumaAseg01__c = XMLDataConversion.stringToXML('','0'); // N/A
			pv.sumaAseg02__c = XMLDataConversion.stringToXML('','0'); // N/A
			pv.sumaAseg03__c = XMLDataConversion.stringToXML('','0'); // N/A
			*/
			pv.CodSumaAseg04__c = '005';
			pv.sumaAseg04__c = XMLDataConversion.stringToXML(coberturas.get('005'),'0');
			pv.CodSumaAseg05__c = '006';
			pv.sumaAseg05__c = XMLDataConversion.stringToXML(coberturas.get('006'),'0');
			/*pv.sumaAseg06__c = XMLDataConversion.stringToXML('','0'); // N/A  		
			pv.sumaAseg07__c = XMLDataConversion.stringToXML('','0'); // N/A  
			pv.sumaAseg08__c = XMLDataConversion.stringToXML('','0'); // N/A  
			pv.sumaAseg09__c = XMLDataConversion.stringToXML('','0'); // N/A  
			pv.sumaAseg10__c = XMLDataConversion.stringToXML('','0'); // N/A  
			pv.sumaAseg11__c = XMLDataConversion.stringToXML('','0'); // N/A  
			pv.sumaAseg12__c = XMLDataConversion.stringToXML('','0'); // N/A  
			pv.sumaAseg13__c = XMLDataConversion.stringToXML('','0'); // N/A  
			pv.sumaAseg14__c = XMLDataConversion.stringToXML('','0'); // N/A  
			pv.sumaAseg15__c = XMLDataConversion.stringToXML('','0'); // N/A  
			pv.sumaAseg16__c = XMLDataConversion.stringToXML('','0'); // N/A  
			pv.sumaAseg17__c = XMLDataConversion.stringToXML('','0'); // N/A  
			pv.sumaAseg18__c = XMLDataConversion.stringToXML('','0'); // N/A  
			pv.sumaAseg19__c = XMLDataConversion.stringToXML('','0'); // N/A  
			*/

		}

		pv.Numero_Lote__c = newLead.Numero_Lote__c;

		if(hasError){
			pv.Observacion__c = errorMessage;
			pv.Estado_Comunicacion_Rector__c = 'Fallida - A Revisar';
		}

		return pv;
	}

	//18-211
	private static Producto_Vendido__c addAccidentesPersonalesDatatoSoldProduct(Producto_Vendido__c pv, Lead newLead) {

		String errorMessage = 'WARNING: ';
		Boolean hasError = false;
		Enlatado__C canned;
		Map<String,String> coberturas = new Map<String,String>();
		Map<String,Coverages_Names__c> coveragesNames = new Map<String,Coverages_Names__c>();

		try{
			canned = Queryutils.getEnlatadoWithCoberturaEnlatadosById(newLead.COMBINATORIA__c);
			System.debug('canned' + canned);
			coberturas = getCoveragesAmountByCoverageCode(canned.Coberturas_enlatado__r);
		} catch (Exception e) {
			hasError |= true;
			errorMessage += 'Enlatado: '+ e.getMessage()+'.';
		}
		
		try{
			coveragesNames = getCoveragesNamesByCode(String.valueOf(Math.round(newLead.Cod_Ramo__c)));
		} catch (Exception e) {
			hasError |= true;
			errorMessage += 'Nombres de Coberturas: '+ e.getMessage();
		}

		if(canned != null) {
			pv.premioOrigen__c = pv.premioDestino__c = pv.Premio_Base__c = canned.Premio__c;
		}

		if (!hasError) {

			pv.CodSumaAseg01__c = '001';
			pv.sumaAseg01__c = XMLDataConversion.stringToXML(coberturas.get('001'),'0');   		
			pv.CodSumaAseg02__c = '002';
			pv.sumaAseg02__c = XMLDataConversion.stringToXML(coberturas.get('002'),'0');   		
			pv.CodSumaAseg03__c = '003';
			pv.sumaAseg03__c = XMLDataConversion.stringToXML(coberturas.get('003'),'0');   		
			pv.CodSumaAseg04__c = '004';
			pv.sumaAseg04__c = XMLDataConversion.stringToXML(coberturas.get('004'),'0');
			//pv.CodSumaAseg09__c = '005';
			//pv.sumaAseg09__c = XMLDataConversion.stringToXML(coberturas.get('005'),'0');
			pv.CodSumaAseg05__c = '006';
			pv.sumaAseg05__c = XMLDataConversion.stringToXML(coberturas.get('006'),'0');   		
			pv.CodSumaAseg06__c = '008';
			pv.sumaAseg06__c = XMLDataConversion.stringToXML(coberturas.get('008'),'0');  		
			pv.CodSumaAseg07__c = '009';
			pv.sumaAseg07__c = XMLDataConversion.stringToXML(coberturas.get('009'),'0');   		
			pv.CodSumaAseg08__c = '010';
			pv.sumaAseg08__c = XMLDataConversion.stringToXML(coberturas.get('010'),'0');

		}

		if(hasError) {
			pv.Observacion__c = errorMessage;
			pv.Estado_Comunicacion_Rector__c = 'Fallida - A Revisar';
		}

		return pv;
	}

	private static Producto_Vendido__c addBiensMovilesDatatoSoldProduct(Producto_Vendido__c pv, Lead newLead) {

		String errorMessage = 'WARNING: ';
		Boolean hasError = false;
		Enlatado__C canned;
		Map<String,String> coberturas = new Map<String,String>();
		Map<String,Coverages_Names__c> coveragesNames = new Map<String,Coverages_Names__c>();

		try{
			canned = Queryutils.getEnlatadoWithCoberturaEnlatadosById(newLead.COMBINATORIA__c);
			System.debug('canned' + canned);
			coberturas = getCoveragesAmountByCoverageCode(canned.Coberturas_enlatado__r);
		} catch (Exception e) {
			hasError |= true;
			errorMessage += 'Enlatado: '+ e.getMessage()+'.';
		}
		
		try{
			coveragesNames = getCoveragesNamesByCode(String.valueOf(Math.round(newLead.Cod_Ramo__c)));
		} catch (Exception e) {
			hasError |= true;
			errorMessage += 'Nombres de Coberturas: '+ e.getMessage();
		}

		if(canned != null) {
			pv.Premio_Base__c = canned.Premio__c;
			pv.premioOrigen__c = canned.Premio__c;
			pv.premioDestino__c = canned.Premio__c;
		}

		if (!hasError) {

			pv.CodSumaAseg08__c = '006';
			pv.sumaAseg08__c = XMLDataConversion.stringToXML(coberturas.get('006'),'0');   		
			pv.CodSumaAseg09__c = '007';
			pv.sumaAseg09__c = XMLDataConversion.stringToXML(coberturas.get('007'),'0');   		
			pv.CodSumaAseg10__c = '008';
			pv.sumaAseg10__c = XMLDataConversion.stringToXML(coberturas.get('008'),'0');   		
			pv.CodSumaAseg11__c = '009';
			pv.sumaAseg11__c = XMLDataConversion.stringToXML(coberturas.get('009'),'0');   		
			pv.CodSumaAseg12__c = '010';
			pv.sumaAseg12__c = XMLDataConversion.stringToXML(coberturas.get('010'),'0');
			pv.CodSumaAseg13__c = '013';
			pv.sumaAseg13__c = XMLDataConversion.stringToXML(coberturas.get('013'),'0');
			pv.CodSumaAseg14__c = '014';
			pv.sumaAseg14__c = XMLDataConversion.stringToXML(coberturas.get('014'),'0');
			pv.CodSumaAseg15__c = '015';
			pv.sumaAseg15__c = XMLDataConversion.stringToXML(coberturas.get('015'),'0');
			pv.CodSumaAseg16__c = '016';
			pv.sumaAseg16__c = XMLDataConversion.stringToXML(coberturas.get('016'),'0');  

		}

		pv.Marca__c = newLead.Marca__c;
		pv.Modelo__c = newLead.Modelo__c;

		if(hasError) {
			pv.Observacion__c = errorMessage;
			pv.Estado_Comunicacion_Rector__c = 'Fallida - A Revisar';
		}

		return pv;
	}
	
	private static Producto_Vendido__c asignHogarCoverages(Producto_Vendido__c pv, Map<String,String> coverages,Lead newLead,Map<String,Add_On_Options__c> addons){
        switch on pv.Producto_IdBHSeg__c {
            when '212', '213', '214' {
                return asignNewHogarCoverages(pv, coverages,newLead,addons);
            }
            when else {
            	 return asignOldHogarCoverages(pv, coverages,newLead,addons);
            }
        }
    }
	//20-007
	private static Producto_Vendido__c asignSaludIntegralCoverages(Producto_Vendido__c pv, Map<String,String> coverages,Lead newLead,Map<String,Add_On_Options__c> addons){
        
		for(String coverage : coverages.keySet()){

            switch on coverage {
				when '007'{
					pv.CodSumaAseg06__c = coverage;
					pv.sumaAseg06__c = XMLDataConversion.stringToXML(coverages.get(coverage),'0');
				}
				when '012'{
					pv.CodSumaAseg11__c = coverage;
					pv.sumaAseg11__c = XMLDataConversion.stringToXML(coverages.get(coverage),'0');
				}
				when '016'{
					pv.CodSumaAseg15__c = coverage;
					pv.sumaAseg15__c = XMLDataConversion.stringToXML(coverages.get(coverage),'0');
				}
				when '008'{
					pv.CodSumaAseg07__c = coverage;
					pv.sumaAseg07__c = XMLDataConversion.decimalToStringXML(getAddon(addons,coverage));
				}
				when '019'{
					pv.CodSumaAseg18__c = coverage;
					pv.sumaAseg18__c = XMLDataConversion.decimalToStringXML(getAddon(addons,coverage));
				}
            }
        }

        return pv;
    }

	private static Producto_Vendido__c asignNewHogarCoverages(Producto_Vendido__c pv, Map<String,String> coverages,Lead newLead,Map<String,Add_On_Options__c> addons){
        for(String coverage : coverages.keySet()){

            switch on coverage {
                    //Incendio (Modulo 1)
                
				when '062'{
					pv.CodSumaAseg01__c = coverage;
					pv.sumaAseg01__c = XMLDataConversion.stringToXML(coverages.get(coverage),'0');
				}
				when '063'{
					pv.CodSumaAseg02__c = coverage;
					pv.sumaAseg02__c = XMLDataConversion.stringToXML(coverages.get(coverage),'0');
				}
				when '032'{
					pv.CodSumaAseg03__c = coverage;
					pv.sumaAseg03__c = XMLDataConversion.stringToXML(coverages.get(coverage),'0'); 
				}
				when '035'{
					pv.CodSumaAseg04__c = coverage;
					pv.sumaAseg04__c = XMLDataConversion.stringToXML(coverages.get(coverage),'0');
				}
				when '036'{
					pv.CodSumaAseg05__c = coverage;
					pv.sumaAseg05__c = XMLDataConversion.stringToXML(coverages.get(coverage),'0');
				}
				when '037'{
					pv.CodSumaAseg06__c = coverage;
					pv.sumaAseg06__c = XMLDataConversion.stringToXML(coverages.get(coverage),'0');
				}
				when '029'{
					pv.CodSumaAseg07__c = coverage;
					pv.sumaAseg07__c = newLead.Cod_Producto__c == 213 
					? newLead.Suma_robo__c 
					: XMLDataConversion.stringToXML(coverages.get(coverage),'0')/*getRoboHurtoInsuredAmount(coberturas, newLead.Suma_robo__c, newLead.Cod_Producto__c == 213)*/;
				}
				when '038'{
					pv.CodSumaAseg08__c = coverage;
					pv.sumaAseg08__c = XMLDataConversion.stringToXML(coverages.get(coverage),'0');
				}
				when '033'{
					pv.CodSumaAseg09__c = coverage;
					pv.sumaAseg09__c = XMLDataConversion.stringToXML(coverages.get(coverage),'0');
				}
				when '040'{
					pv.CodSumaAseg10__c = coverage;
					pv.sumaAseg10__c = XMLDataConversion.stringToXML(coverages.get(coverage),'0')/*XMLDataConversion.decimalToStringXML(getAddon(addons,'055'))*/;
				}
				when '058'{
					pv.CodSumaAseg11__c = coverage;
					pv.sumaAseg11__c = XMLDataConversion.stringToXML(coverages.get(coverage),'0');
				}
				when '034'{
					pv.CodSumaAseg12__c = coverage;
					pv.sumaAseg12__c = XMLDataConversion.stringToXML(coverages.get(coverage),'0');
				}
				when '053'{
					pv.CodSumaAseg13__c = coverage;
					pv.sumaAseg13__c = XMLDataConversion.stringToXML(coverages.get(coverage),'0');
				}
				when '055'{
					pv.CodSumaAseg15__c = coverage;
					pv.sumaAseg15__c = XMLDataConversion.decimalToStringXML(getAddon(addons,coverage));
				}
				when '041'{
					pv.CodSumaAseg17__c = coverage;
					pv.sumaAseg17__c = XMLDataConversion.stringToXML(coverages.get(coverage),'0');  
				}
				when '056'{
					pv.CodSumaAseg18__c = coverage;
					pv.sumaAseg18__c = XMLDataConversion.decimalToStringXML(getAddon(addons,coverage)); 
				}
				when '057'{
					pv.CodSumaAseg19__c = coverage;
					pv.sumaAseg19__c = XMLDataConversion.decimalToStringXML(getAddon(addons,coverage));
				}
				when '064'{
					pv.CodSumaAseg20__c = coverage;
					pv.sumaAseg20__c = XMLDataConversion.decimalToStringXML(getAddon(addons,coverage));
				}
               
            }
        }

        return pv;
    }
	
	private static Producto_Vendido__c asignOldHogarCoverages(Producto_Vendido__c pv, Map<String,String> coverages,Lead newLead,Map<String,Add_On_Options__c> addons){
        for(String coverage : coverages.keySet()){

            switch on coverage {
                    //Incendio (Modulo 1)
                
					when '061' {
						pv.CodSumaAseg16__c = '061';
						pv.sumaAseg16__c = XMLDataConversion.stringToXML(coverages.get('061'),'0'); // Incendio de edificio (Cobertura 061)
					}
					when '031' {
						pv.CodSumaAseg01__c = '031';
						pv.sumaAseg01__c = XMLDataConversion.stringToXML(coverages.get('031'),'0'); // Incendio de edificio (Cobertura 031)
					}  
					when '041' {
						pv.CodSumaAseg17__c = '041';
						pv.sumaAseg17__c = XMLDataConversion.stringToXML(coverages.get('041'),'0'); // Incendio de edificio con Granizo (Cobertura 041)
					}
					when '060' {
						pv.CodSumaAseg02__c = '060';
						pv.sumaAseg02__c = XMLDataConversion.stringToXML(coverages.get('060'),'0'); // Daños por Granizo al Edificio (Cobertura 060)
					}  
					when '035' {
						pv.CodSumaAseg03__c = '035';
						pv.sumaAseg03__c = XMLDataConversion.stringToXML(coverages.get('035'),'0'); // RC por Incendio o explosion (Cobertura 035)
					}
					when '036' {
						pv.CodSumaAseg04__c = '036';
						pv.sumaAseg04__c = XMLDataConversion.stringToXML(coverages.get('036'),'0'); // Alojamiento por Incendio o Explosion (Cobertura 036)
					}  
					when '037' {
						pv.CodSumaAseg05__c = '037';
						pv.sumaAseg05__c = XMLDataConversion.stringToXML(coverages.get('037'),'0'); // Gastos de Limpieza por incendio (Cobertura 037)
					}  
					when '040' {
						pv.CodSumaAseg06__c = '040';
						pv.sumaAseg06__c = XMLDataConversion.stringToXML(coverages.get('040'),'0'); // Responsabilidad Civil Hechos Privados (Cobertura 040)
					}  
						//Contenido (Modulo 2)
					when '029' {
						pv.CodSumaAseg07__c = '029';
						pv.sumaAseg07__c = XMLDataConversion.stringToXML(coverages.get('029'),'0'); // Robo o hurto del Contenido General (Cobertura 029) 
					}  
					when '034' {
						pv.CodSumaAseg08__c = '034';
						pv.sumaAseg08__c = XMLDataConversion.stringToXML(coverages.get('034'),'0'); // Rotura de Cristales (Cobertura 034)
					}  
					when '032' {
						pv.CodSumaAseg09__c = '032';
						pv.sumaAseg09__c = XMLDataConversion.stringToXML(coverages.get('032'),'0'); // Incendio del contenido (Cobertura 032)
					}  
					when '055' {
						pv.CodSumaAseg10__c = '055';
						/*if(coverage.cotizacionAjustada == 0){
							pv.sumaAseg10__c = String.valueOf(coverage.addonSelected.monto); // Resposabilidad Civil Tenencia de Animales (Cobertura 055)
						}else{*/
							pv.sumaAseg10__c = XMLDataConversion.stringToXML(coverages.get('055'),'0'); // Resposabilidad Civil Tenencia de Animales (Cobertura 055)
						/*}*/
					}  
					when '038' {
						pv.CodSumaAseg11__c = '038';
						pv.sumaAseg11__c = XMLDataConversion.stringToXML(coverages.get('038'),'0'); // Daños por Robo o intento de Robo (Cobertura 038)
					}  
						//Servicios (Modulo 3)
					when '033' {
						pv.CodSumaAseg12__c = '033';
						/*if(coverage.cotizacionAjustada == 0){
							pv.sumaAseg12__c = String.valueOf(coverage.addonSelected.monto); // Electrodomesticos o Equipos Electronicos (Cobertura 033)
						}else{*/
							pv.sumaAseg12__c = XMLDataConversion.stringToXML(coverages.get('033'),'0'); // Electrodomesticos o Equipos Electronicos (Cobertura 033)
						/*}*/
					}  
					when '058' {
						pv.CodSumaAseg13__c = '058';
						pv.sumaAseg13__c = XMLDataConversion.stringToXML(coverages.get('058'),'0'); // Daños por agua al contenido (Cobertura 058)
					}  
					when '053' {
						pv.CodSumaAseg14__c = '053';
						pv.sumaAseg14__c = XMLDataConversion.stringToXML(coverages.get('053'),'0'); // Robo o Hurto en Vacaciones (Cobertura 053)
					}  
					when '054' {
						pv.CodSumaAseg15__c = '054';
						pv.sumaAseg15__c = XMLDataConversion.stringToXML(coverages.get('054'),'0'); // Objetos Especificos (Cobertura 054)
					}

            }
        }

        return pv;
    }

	//2-212, 2-213, 2-214
	private static Producto_Vendido__c addHogarProtegidoIIIDataToSoldProduct(Producto_Vendido__c pv, Lead newLead) {
		System.debug('produvto vendido sold');
		Boolean isHPDevolucion = 'Devolucion'.equalsIgnoreCase(newLead.Oferta__c);
		String errorMessage = 'WARNING: ';
		Boolean hasError = false;
		Enlatado__C canned;
		Map<String,String> coberturas = new Map<String,String>();
		Map<String,Add_On_Options__c> addons = new Map<String,Add_On_Options__c>();
		Map<String,Coverages_Names__c> coveragesNames = new Map<String,Coverages_Names__c>();

		try{
			canned = Queryutils.getEnlatadoWithCoberturaEnlatadosById(newLead.COMBINATORIA__c);
			System.debug('canned ' + canned);
			coberturas = getCoveragesAmountByCoverageCode(canned.Coberturas_enlatado__r);
			System.debug('coberturas ' + coberturas);
		} catch (Exception e) {
			hasError |= true;
			errorMessage += 'Enlatado: '+ e.getMessage()+'.';
		}

		// Si es HP III Devolucion tratamos de obtener el premio original y del monto seleccionado para robo/hurto
		Decimal selectedPrizeOption = 0;
		Decimal oldPrizeOption = 0;
		if ( /*isHPDevolucion*/ newLead.Cod_Producto__c == 213) {
			try {
				Cobertura_Enlatado__c roboCannedCoverage = getRoboHurtoCoverage(canned.Coberturas_enlatado__r);
				System.debug('roboCannedCoverage ' + roboCannedCoverage);
				selectedPrizeOption = getCoverageSelectedPrize(roboCannedCoverage, '029', String.valueOf(newLead.Suma_Robo__c));
				oldPrizeOption =
					getCoverageSelectedPrize(
						roboCannedCoverage,
						'029',
						String.valueOf(
							Integer.valueOf(
								roboCannedCoverage.monto_Cobertura__c
							)
						)
					);
			} catch (Exception e) {
				hasError |= true;
				errorMessage += 'Suma Robo: '+ e.getMessage();
			}
		}

		try{
			addons = getAddonsAmountByCode(newLead.AddOns__c);
			System.debug('addons ' + addons);
		} catch (System.QueryException qe) {
			hasError |= true;
			errorMessage += 'Addons: '+ qe.getMessage();
		}

		try{
			coveragesNames = getCoveragesNamesByCode(String.valueOf(Math.round(newLead.Cod_Ramo__c)));
			System.debug('coveragesNames ' + coveragesNames);
		} catch (Exception e) {
			hasError |= true;
			errorMessage += 'Nombres de Coberturas: '+ e.getMessage();
		}

		if(canned != null){
			System.debug('pv 1' + pv);
			System.debug('canned.Ambiente__c' + canned.Ambiente__c);
			pv.metrosCuadrados__c = canned.Ambiente__c;
			System.debug('pv.metrosCuadrados__c' + pv.metrosCuadrados__c);
			System.debug('pv 2' + pv);
			if(!String.isBlank(canned.Asistencia__c)){

				pv.combinatoria__c = canned.Asistencia__c.substring(0,3).toUpperCase(); // 'CLA': Asistencia Clasica | 'PLU': Asistencia Plus
				System.debug('canned.Asistencia__c' + canned.Asistencia__c.substring(0,3).toUpperCase());
				System.debug('pv.combinatoria__c' + pv.combinatoria__c);    
			}
			System.debug('pv 3' + pv);
			if(newLead.Cod_Producto__c == 213 /*isHPDevolucion*/){
				pv.premioOrigen__c =
					pv.premioDestino__c =
						canned.Premio__c - oldPrizeOption + selectedPrizeOption;
			}else{
				pv.premioOrigen__c =
					pv.premioDestino__c = canned.Premio__c;
			}
			
			pv.Premio_Base__c = canned.Premio__c;
			System.debug('pv 10' + pv);
		}
		System.debug('pv 22' + pv);
		for (Add_On_Options__c addon : addons.values()){
			pv.premioDestino__c += addon.Premio_Mensual__c;
			pv.premioOrigen__c += addon.Premio_Mensual__c;
			pv.Add_Ons__c = (pv.Add_Ons__c == null ? '' : pv.Add_Ons__c) + getCoverageName(addon.Codigo_Cobertura__c, coveragesNames) +' - '+ addon.Premio_Mensual__c +';';
		}

		if(String.isNotBlank(pv.Add_Ons__c)){
			pv.Add_Ons__c = pv.Add_Ons__c.removeEnd(';');
		}

		if ( !hasError && newLead.LeadSource == 'Portal-ventas' ) {
			newLead.Premio__c = pv.premioOrigen__c;
		}

		pv = asignHogarCoverages(pv, coberturas,newLead,addons);		

		/* //!Viejo orden
		pv.sumaAseg01__c = XMLDataConversion.stringToXML(coberturas.get('031'),'0');   		// Incendio de edificio (031)
		pv.sumaAseg02__c = XMLDataConversion.stringToXML(coberturas.get('060'),'0');   		// Daños por Granizo al Edificio ( 060)
		pv.sumaAseg03__c = XMLDataConversion.stringToXML(coberturas.get('035'),'0');   		// RC por Incendio o explosion (Cobertura 035)
		pv.sumaAseg04__c = XMLDataConversion.stringToXML(coberturas.get('036'),'0');   		// Alojamiento por Incendio o Explosion (Cobertura 036)
		pv.sumaAseg05__c = XMLDataConversion.stringToXML(coberturas.get('037'),'0');   		// Gastos de Limpieza por incendio (Cobertura 037)
		pv.sumaAseg06__c = XMLDataConversion.stringToXML(coberturas.get('040'),'0');  		// Responsabilidad Civil Hechos Privados (040)
        pv.sumaAseg07__c = getRoboHurtoInsuredAmount(coberturas, newLead.Suma_robo__c, isHPDevolucion);   		// Robo o hurto del Contenido General (029)
		pv.sumaAseg08__c = XMLDataConversion.stringToXML(coberturas.get('034'),'0');   		// Rotura de Cristales (034)
		pv.sumaAseg09__c = XMLDataConversion.stringToXML(coberturas.get('032'),'0');		// Incendio del contenido (Cobertura 032)
		pv.sumaAseg10__c = XMLDataConversion.decimalToStringXML(getAddon(addons,'055'));	// Resposabilidad Civil Tenencia de Animales (055)
		pv.sumaAseg11__c = XMLDataConversion.stringToXML(coberturas.get('038'),'0'); 		// Daños por Robo o intento de Robo (038)
		pv.sumaAseg12__c = XMLDataConversion.stringToXML(coberturas.get('033'),'0');        // Electrodomesticos o Equipos Electronicos (033)
		if(pv.sumaAseg12__c.equalsIgnoreCase('0')){
			pv.sumaAseg12__c = XMLDataConversion.decimalToStringXML(getAddon(addons,'033')); 
		}		
		pv.sumaAseg13__c = XMLDataConversion.stringToXML(coberturas.get('058'),'0');   		// Daños por agua al contenido (058)
		pv.sumaAseg14__c = XMLDataConversion.stringToXML(coberturas.get('053'),'0');   		// Robo o Hurto en Vacaciones (053)
		pv.sumaAseg15__c = XMLDataConversion.stringToXML(coberturas.get('054'),'0');   		// Objetos Especificos (054)
		pv.sumaAseg16__c = XMLDataConversion.stringToXML(coberturas.get('061'),'0');   		// Incendio Edificio con Granizo Primer Riesgo (061)
		pv.sumaAseg17__c = XMLDataConversion.stringToXML(coberturas.get('041'),'0');   		// Incendio De Edificio Con Granizo Prorrata (041)
		pv.sumaAseg18__c = XMLDataConversion.decimalToStringXML(getAddon(addons,'056'));	// Animeales Domesticos (056)
		pv.sumaAseg19__c = XMLDataConversion.decimalToStringXML(getAddon(addons,'057'));	// Robo de Bicicletas (057)
		*/

		/** AL Acpetar los Terminos y Condiciones de la venta Web acepta estas respuestas */
		pv.actividadesComerciales__c = 'N';
        pv.viviendaPermanente__c = 'S';
        pv.paredesMaterial__c = 'S';
		pv.cantidadObjetos__c = '';

		pv.pregunta1__c = 'S'; // Servicios Adicionales
		pv.pregunta2__c = 'N'; // Posee Rejas
		pv.pregunta3__c = 'S'; // Linda Con Terreno Baldio
        pv.pregunta4__c = '';  // No se sabe cual es

		pv.Numero_Lote__c = newLead.Numero_Lote__c;

		pv.tipoVivienda__c = newLead.tipo_vivienda__c; //1: Barrio Privado | 2: Casa | 3: Departamento

		Map<String, String> promotion = getPromotion('MA', String.valueOf(newLead.Cod_Ramo__c), String.valueOf(newLead.Cod_Producto__c)/*, newLead.Cod_Producto__c == 213*/);
		System.debug('promotion ' + promotion);
		if(!promotion.isEmpty()){
			pv.promocion__c = promotion.get('type');
			if(String.isNotBlank(promotion.get('percentage'))){
				pv.Porcentaje_Devolucion__c = Decimal.valueOf(promotion.get('percentage'));
			}
		}

		if(hasError){
			pv.Observacion__c = errorMessage;
			pv.Estado_Comunicacion_Rector__c = 'Fallida - A Revisar';
		}
		System.debug('antes de enviar' + pv);
        return pv;

	}
    
    private static Producto_Vendido__c addCotizacionAbiertaSoldProduct(Producto_Vendido__c pv, Lead newLead) {
		System.debug('producto vendido soldCotizacionAbierta');
		Boolean isHPDevolucion = 'Devolucion'.equalsIgnoreCase(newLead.Oferta__c);
        
		String errorMessage = 'WARNING: ';
		Boolean hasError = false;

        Cotizacion_Abierta__c cot;
		try{
			cot = [SELECT Id, Codigo_Ramo__c, Codigo_Producto__c, Codigo_Plan__c, Fecha_Desde__c, Fecha_Hasta__c, Codigo_Provincia__c, Codigo_Postal__c,
                   Tipo_Vivienda__c, Destino_Vivienda__c, Tipo_Adhesion__c, Es_Tarjeta_de_Credito__c, Afinidad__c, Codigo_Productor__c, Porcentaje_Comision_Productor__c,
                   Tipo_Vigencia__c, Tipo_Facturacion__c, (SELECT Id, Monto__c, Codigo__c FROM Cobertura_de_Cotizaciones__r)
                   FROM Cotizacion_Abierta__c
                   WHERE Id = :newLead.Id_Cotizacion_Abierta__c];
		} catch (Exception e) {
			hasError |= true;
			errorMessage += 'Falló al obtener cotización abierta: '+ e.getMessage()+'.';
		}
        
        if(!hasError){
            /*pv.Ramo_IdBHSeg__c = cot.Codigo_Ramo__c;
            String codProductoStr =	String.valueOf(cot.Codigo_Producto__c);
			pv.Producto_IdBHSeg__c = '0'.repeat(3 - codProductoStr.length()) + codProductoStr;
            pv.Plan_IdBHSeg__c = cot.Codigo_Plan__c;
            //pv.Plan_IdBHSeg__c = cot.Fecha_Desde__c;
            //pv.Plan_IdBHSeg__c = cot.Fecha_Hasta__c;
            
            //pv.Plan_IdBHSeg__c = cot.Codigo_Provincia__c;
            //pv.Plan_IdBHSeg__c = cot.Codigo_Postal__c;
            pv.tipoVivienda__c = newLead.tipo_vivienda__c; //1: Barrio Privado | 2: Casa | 3: Departamento

            pv.Sponsor__c = cot.Codigo_Productor__c;*/
            
            pv.tipoVivienda__c = String.ValueOf(cot.Tipo_Vivienda__c); //1: Barrio Privado | 2: Casa | 3: Departamento
            
            pv.Tipo_Vigencia__c = cot.Tipo_Vigencia__c;
            pv.Tipo_de_Facturacion__c = cot.Tipo_Facturacion__c;
            pv.Porcentaje_Comision_Productor__c = cot.Porcentaje_Comision_Productor__c;
            pv.Afinidad__c = cot.Afinidad__c;
            pv.Es_Tarjeta_de_Credito__c = cot.Es_Tarjeta_de_Credito__c ? 'SI' : 'NO';
            pv.Tipo_Adhesion__c = cot.Tipo_Adhesion__c;
            pv.Destino_Vivienda__c = cot.Destino_Vivienda__c;
            
            pv = asignHogarCoveragesCotizacionAbierta(pv, cot.Cobertura_de_Cotizaciones__r);	
        }

		/** AL Acpetar los Terminos y Condiciones de la venta Web acepta estas respuestas */
		pv.actividadesComerciales__c = 'N';
        pv.viviendaPermanente__c = 'S';
        pv.paredesMaterial__c = 'S';
		pv.cantidadObjetos__c = '';

		pv.pregunta1__c = 'S'; // Servicios Adicionales
		pv.pregunta2__c = 'N'; // Posee Rejas
		pv.pregunta3__c = 'S'; // Linda Con Terreno Baldio
        pv.pregunta4__c = '';  // No se sabe cual es

		pv.Numero_Lote__c = newLead.Numero_Lote__c;

		if(hasError){
			pv.Observacion__c = errorMessage;
			pv.Estado_Comunicacion_Rector__c = 'Fallida - A Revisar';
		}
		System.debug('antes de enviar' + pv);
        return pv;

	}
    
    private static Producto_Vendido__c asignHogarCoveragesCotizacionAbierta(Producto_Vendido__c pv, List<Cobertura_de_Cotizacion__c> coverages){
        for(Cobertura_de_Cotizacion__c coverage : coverages){
            switch on coverage.Codigo__c {
                    //Incendio (Modulo 1)
                
				when '062'{
					pv.CodSumaAseg01__c = coverage.Codigo__c;
					pv.sumaAseg01__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
				when '063'{
					pv.CodSumaAseg02__c = coverage.Codigo__c;
					pv.sumaAseg02__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
				when '032'{
					pv.CodSumaAseg03__c = coverage.Codigo__c;
					pv.sumaAseg03__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
				when '035'{
					pv.CodSumaAseg04__c = coverage.Codigo__c;
					pv.sumaAseg04__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
				when '036'{
					pv.CodSumaAseg05__c = coverage.Codigo__c;
					pv.sumaAseg05__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
				when '037'{
					pv.CodSumaAseg06__c = coverage.Codigo__c;
					pv.sumaAseg06__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
				when '029'{
					pv.CodSumaAseg07__c = coverage.Codigo__c;
					pv.sumaAseg07__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
				when '038'{
					pv.CodSumaAseg08__c = coverage.Codigo__c;
					pv.sumaAseg08__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
				when '033'{
					pv.CodSumaAseg09__c = coverage.Codigo__c;
					pv.sumaAseg09__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
				when '040'{
					pv.CodSumaAseg10__c = coverage.Codigo__c;
					pv.sumaAseg10__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
				when '058'{
					pv.CodSumaAseg11__c = coverage.Codigo__c;
					pv.sumaAseg11__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
				when '034'{
					pv.CodSumaAseg12__c = coverage.Codigo__c;
					pv.sumaAseg12__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
				when '053'{
					pv.CodSumaAseg13__c = coverage.Codigo__c;
					pv.sumaAseg13__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
                when '071'{
					pv.CodSumaAseg14__c = coverage.Codigo__c;
					pv.sumaAseg14__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
				when '055'{
					pv.CodSumaAseg15__c = coverage.Codigo__c;
					pv.sumaAseg15__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
                when '050'{
					pv.CodSumaAseg16__c = coverage.Codigo__c;
					pv.sumaAseg16__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
				when '041'{
					pv.CodSumaAseg17__c = coverage.Codigo__c;
					pv.sumaAseg17__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0'); 
				}
				when '056'{
					pv.CodSumaAseg18__c = coverage.Codigo__c;
					pv.sumaAseg18__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
				when '057'{
					pv.CodSumaAseg19__c = coverage.Codigo__c;
					pv.sumaAseg19__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
				when '064'{
					pv.CodSumaAseg20__c = coverage.Codigo__c;
					pv.sumaAseg20__c = XMLDataConversion.stringToXML(String.ValueOf(coverage.Monto__c),'0');
				}
               
            }
        }

        return pv;
    }

	//20-007
	private static Producto_Vendido__c addSaludIntegralToSoldProduct(Producto_Vendido__c pv, Lead newLead) {
		System.debug('producto vendido sold salud integral');
		String errorMessage = 'WARNING: ';
		Boolean hasError = false;
		Enlatado__C canned;
		Map<String,String> coberturas = new Map<String,String>();
		Map<String,Add_On_Options__c> addons = new Map<String,Add_On_Options__c>();
		Map<String,Coverages_Names__c> coveragesNames = new Map<String,Coverages_Names__c>();

		try{
			canned = Queryutils.getEnlatadoWithCoberturaEnlatadosById(newLead.COMBINATORIA__c);
			System.debug('canned ' + canned);
			coberturas = getCoveragesAmountByCoverageCode(canned.Coberturas_enlatado__r);
			System.debug('coberturas ' + coberturas);
		} catch (Exception e) {
			hasError |= true;
			errorMessage += 'Enlatado: '+ e.getMessage()+'.';
		}
		
		Decimal selectedPrizeOption = 0;
		Decimal oldPrizeOption = 0;

		try{
			addons = getAddonsAmountByCode(newLead.AddOns__c);
			System.debug('addons ' + addons);
		} catch (System.QueryException qe) {
			hasError |= true;
			errorMessage += 'Addons: '+ qe.getMessage();
		}

		try{
			coveragesNames = getCoveragesNamesByCode(String.valueOf(Math.round(newLead.Cod_Ramo__c)));
			System.debug('coveragesNames ' + coveragesNames);
		} catch (Exception e) {
			hasError |= true;
			errorMessage += 'Nombres de Coberturas: '+ e.getMessage();
		}

		if(canned != null){
			System.debug('pv 1' + pv);

			System.debug('pv 2' + pv);
			if(!String.isBlank(canned.Asistencia__c)){

				pv.combinatoria__c = canned.Asistencia__c; 
				System.debug('pv.combinatoria__c' + pv.combinatoria__c);    
			}
			System.debug('pv 3' + pv);
			
			pv.premioOrigen__c = pv.premioDestino__c = canned.Premio__c;		
			pv.Premio_Base__c = canned.Premio__c;
			System.debug('pv 10' + pv);
		}
		System.debug('pv 22' + pv);
		for (Add_On_Options__c addon : addons.values()){
			pv.premioDestino__c += addon.Premio_Mensual__c;
			pv.premioOrigen__c += addon.Premio_Mensual__c;
			pv.Add_Ons__c = (pv.Add_Ons__c == null ? '' : pv.Add_Ons__c) + getCoverageName(addon.Codigo_Cobertura__c, coveragesNames) +' - '+ addon.Premio_Mensual__c +';';
		}
		if(String.isNotBlank(pv.Add_Ons__c)){
			pv.Add_Ons__c = pv.Add_Ons__c.removeEnd(';');
		}
		if ( !hasError && newLead.LeadSource == 'Portal-ventas' ) {
			newLead.Premio__c = pv.premioOrigen__c;
		}
		pv = asignSaludIntegralCoverages(pv, coberturas,newLead,addons);		
		
		// pv.actividadesComerciales__c = 'N';
        // pv.viviendaPermanente__c = 'S';
        // pv.paredesMaterial__c = 'S';
		// pv.cantidadObjetos__c = '';

		// pv.pregunta1__c = 'S'; // Servicios Adicionales
		// pv.pregunta2__c = 'N'; // Posee Rejas
		// pv.pregunta3__c = 'S'; // Linda Con Terreno Baldio
        // pv.pregunta4__c = '';  // No se sabe cual es

		pv.Numero_Lote__c = newLead.Numero_Lote__c;

		pv.tipoVivienda__c = newLead.tipo_vivienda__c; //1: Barrio Privado | 2: Casa | 3: Departamento

		//Declaracion Jurada
		pv.Declaracion_Jurada__c = 'P';
		pv.Respuestas_Declaracion_Jurada__c = 'N';

		//Asistencia
		pv.combinatoria__c = 'Salud + Telemedicina'; //

		if(hasError){
			pv.Observacion__c = errorMessage;
			pv.Estado_Comunicacion_Rector__c = 'Fallida - A Revisar';
		}
		System.debug('antes de enviar' + pv);
        return pv;
	}

	//19-310, 19-311, 19-312
	private static Producto_Vendido__c addVidaDataToSoldProduct(Producto_Vendido__c pv, Lead newLead) {

		String errorMessage = 'WARNING: ';
		Boolean hasError = false;
		Integer age;
		String provinceCode;
		Cotizador.CotizadorResult result;
		Map<String, String> amountsByCode = new Map<String, String>();
		Map<String, String> bmi = new Map<String, String>();
		List<Cotizador.SumaCoberturaCotizadorWrapper> coverages = new List<Cotizador.SumaCoberturaCotizadorWrapper>();

		try{

			provinceCode = getProvinceCodeByDescription(newLead.Domicilio_Provincia__c );

		} catch (Exception e) {
			hasError |= true;
			errorMessage += 'Provincia: '+ e.getMessage() + ' ';
		}

		try{

			age = ClientDataController.calculateAge(newLead.FECHA_NACIMIENTO__c/*, System.today().addDays(1)*/);
			
		} catch (Exception e) {
			hasError |= true;
			errorMessage += 'Edad: '+ e.getMessage() + ' ';
		}

		if(!hasError){
			try{
				if(newLead.Cod_Ramo__c == 19 
					&& (newLead.Cod_Producto__c == 310 || newLead.Cod_Producto__c == 311)){
					coverages = CotizadorController.calcVidaEducacionCoverages(
						age,
						newLead.Sexo__c,
						String.valueOf(newLead.Cod_Ramo__c),
						String.valueOf(newLead.Cod_Producto__c),
						JSON.serialize(getChildsWrappers(newLead.Edad_Hijos__c)),
						newLead.Cuota_Colegio_Promedio__c
					);
				}else{
					Enlatado__c canned = QueryUtils.getEnlatado(newLead.COMBINATORIA__c);
					coverages = SaleDataController.searchCoveragesByEnlatadoToSell(canned.Codigo_Enlatado__c, String.valueOf(newLead.Cod_Ramo__c), String.valueOf(newLead.Cod_Producto__c), newLead.Sponsor__c);
				}
				
				CotizadorController.CotizadorControllerRequest request = new CotizadorController.CotizadorControllerRequest();
				
				request.codigoProvincia = provinceCode;
				request.ramo_idbhseg = String.valueOf(newLead.Cod_Ramo__c);
				request.producto_idbhseg = String.valueOf(newLead.Cod_Producto__c);
				request.edad = age;
				request.sexo = newLead.Sexo__c;
				request.coberturas = coverages;
				request.useType = 'Venta';
	
				result = CotizadorController.obtenerDatosDePremio(request);
			} catch (Exception e) {
				hasError |= true;
				errorMessage += 'Calculos: '+ e.getMessage() + ' ';
			}
		}

		if(!hasError){

			//Coberturas
			amountsByCode = getAmountsByCode(coverages);

			pv.CodSumaAseg01__c = '001';
			pv.sumaAseg01__c = XMLDataConversion.stringToXML(amountsByCode.get('001'),'0');
			pv.CodSumaAseg02__c = '004';
			pv.sumaAseg02__c = XMLDataConversion.stringToXML(amountsByCode.get('004'),'0'); 
			pv.CodSumaAseg03__c = '005';
			pv.sumaAseg03__c = XMLDataConversion.stringToXML(amountsByCode.get('005'),'0');  
			pv.CodSumaAseg04__c = '006';
			pv.sumaAseg04__c = XMLDataConversion.stringToXML(amountsByCode.get('006'),'0');  
			pv.CodSumaAseg05__c = '008';
			pv.sumaAseg05__c = XMLDataConversion.stringToXML(amountsByCode.get('008'),'0'); 
			pv.CodSumaAseg06__c = '009';
			pv.sumaAseg06__c = XMLDataConversion.stringToXML(amountsByCode.get('009'),'0');  
			pv.CodSumaAseg07__c = '011';
			pv.sumaAseg07__c = XMLDataConversion.stringToXML(amountsByCode.get('011'),'0'); 
			pv.CodSumaAseg08__c = '013';
			pv.sumaAseg08__c = XMLDataConversion.stringToXML(amountsByCode.get('013'),'0');  
			pv.CodSumaAseg09__c = '003';
			pv.sumaAseg09__c = XMLDataConversion.stringToXML(amountsByCode.get('003'),'0');  
			/*
			pv.sumaAseg10__c = XMLDataConversion.stringToXML('','0');                               // N/A  
			pv.sumaAseg11__c = XMLDataConversion.stringToXML('','0');                               // N/A  
			pv.sumaAseg12__c = XMLDataConversion.stringToXML('','0');                               // N/A  
			pv.sumaAseg13__c = XMLDataConversion.stringToXML('','0');                               // N/A  
			pv.sumaAseg14__c = XMLDataConversion.stringToXML('','0');                               // N/A  
			pv.sumaAseg15__c = XMLDataConversion.stringToXML('','0');                               // N/A  
			pv.sumaAseg16__c = XMLDataConversion.stringToXML('','0');                               // N/A  
			pv.sumaAseg17__c = XMLDataConversion.stringToXML('','0');                               // N/A  
			pv.sumaAseg18__c = XMLDataConversion.stringToXML('','0');                               // N/A  
			pv.sumaAseg19__c = XMLDataConversion.stringToXML('','0');                               // N/A 
			*/
	
			//Premio
			pv.Premio_Base__c =
				pv.premioOrigen__c =
					pv.premioDestino__c =
						result.premioMensualSinSellos;
		}

		//Indice de Masa Corporal (IMC)
		try{
			
			bmi = QuestionController.calculateBodyMassIndex(newLead.Altura_IMC__c, Integer.valueOf(newLead.Peso_IMC__c));

		} catch (Exception e) {
			hasError |= true;
			errorMessage += 'IMC: '+ e.getMessage() + ' ';
		}

		if(!hasError){
			pv.Altura_IMC__c = newLead.Altura_IMC__c;
			pv.Peso_IMC__c = newLead.Peso_IMC__c;
			pv.Clasificacion_IMC__c = bmi.get('classification');
		}

		//Declaracion Jurada
		pv.Declaracion_Jurada__c = (newLead.Cod_Ramo__c == 19 && newLead.Cod_Producto__c == 312) 
			? newLead.Declaracion_Jurada__c 
			: 'C';
		pv.Respuestas_Declaracion_Jurada__c = 'N';

		//Escolaridad
		pv.Edad_Hijos__c = newLead.Edad_Hijos__c;
		pv.Cuota_Colegio_Promedio__c = newLead.Cuota_Colegio_Promedio__c;

		//Asistencia
		pv.combinatoria__c = 'EDU'; // 'EDU': Asistencia de Educacion

		if(hasError){
			pv.Observacion__c = errorMessage;
			pv.Estado_Comunicacion_Rector__c = 'Fallida - A Revisar';
		}

        return pv;

	}

	private static String getProvinceCodeByDescription(String provinceDescription) {

		provinceDescription = Utils.formatProvinceDescrition(provinceDescription);

		String provinceCode = [ 
			SELECT Id_bhseg__c 
			FROM Provincia_Rector__c 
			WHERE Descripcion__c = :provinceDescription
		]?.Id_bhseg__c;

		if(provinceCode != null){
			return provinceCode;
		}else{
			throw new Exceptions.NotFoundException('No se encontro el codigo para la provincia: '+ provinceDescription + '. ');
		}
    }

	private static Map<String, String> getAmountsByCode(List<Cotizador.SumaCoberturaCotizadorWrapper> coverages) {
        Map<String, String> amoutsByCode = new Map<String, String>();
        for (Cotizador.SumaCoberturaCotizadorWrapper coverage : coverages) {
            amoutsByCode.put(coverage.codigoCobertura, String.valueOf(coverage.cotizacionAjustada));
        }
        return amoutsByCode;
    }

	public static List<CotizadorController.ChildsWrapper> getChildsWrappers(String childsAges) {
        List<CotizadorController.ChildsWrapper> childs = new List<CotizadorController.ChildsWrapper>();
		List<String> ages = childsAges.split(',');

        for (Integer i = 0; i < ages.size(); i++) {
            childs.add(new CotizadorController.ChildsWrapper(String.valueOf(i), 'Child ' + String.valueOf(i), Integer.valueOf(ages[i])));
        }
        return childs;
    }

	private static Map<String, String> getPromotion(String sponsor, String tradeCode, String productCode/*, Boolean offer*/) {

		Map<String, String> promotion = new Map<String, String>();

		for(Promotion__c prom :  Promotion__c.getAll().values()){
			if(prom.Active__c){
				if(prom.Sponsor__c.equalsIgnoreCase(sponsor)
					&& prom.Trade_Code__c.equalsIgnoreCase(tradeCode)
					&& prom.Product_Code__c.equalsIgnoreCase(productCode)
					/*&& prom.Offer__c.equalsIgnoreCase(offer ? 'Devolucion' : 'Camara')*/ //!ALERT: Deprecado en division de hogares.
					&& prom.Channels__c.containsIgnoreCase('1009')){
					promotion.put('type', prom.Promotion_Type__c);
					promotion.put('percentage', String.valueOf(prom.Percentage__c));
				}
			}
		}

        return promotion;

	}

	/**
	 * Metodo que retorna los nombres de las coberturas del producto distinguidas por el codigo
	 * de estas.
	**/
	private static Map<String, Coverages_Names__c> getCoveragesNamesByCode(String tradeCode){
		Map<String, Coverages_Names__c> coveragesNamesByCode = new Map<String, Coverages_Names__c>();

		for(Coverages_Names__c coverage: Coverages_Names__c.getAll().values()){
			if(tradeCode.equalsIgnoreCase(coverage.Codigo_Ramo__c)){
				coveragesNamesByCode.put(coverage.Codigo_Cobertura__c, coverage);
			}
		}

		if(coveragesNamesByCode.isEmpty()){
			throw new Exceptions.NotFoundException('No se encontraron nombres de coberturas para el ramo ' + tradeCode);
		}

		return coveragesNamesByCode;
	}

	/**
	 * Metodo que retorna el nombre de cobertura en base al codigo que se especifique.
	**/
	private static String getCoverageName(String coverageCode, Map<String, Coverages_Names__c> coveragesNames){
		if(coveragesNames.containsKey(coverageCode)){
			return coveragesNames.get(coverageCode).Abbreviation__c;
		}
		return 'Nombre no encontrado';
	}

	private static Decimal getCoverageSelectedPrize( Cobertura_Enlatado__c cannedCoverage, String coverageCode, String option ) {

		Integer indexOfOption = cannedCoverage.Opciones_de_Suma__c.split(',').indexOf(option);

		return Decimal.valueOf(cannedCoverage.Premios_Opciones_de_Sumas__c.split(',').get(indexOfOption));
	}

	private static Cobertura_enlatado__c getRoboHurtoCoverage(List<Cobertura_Enlatado__c> coverages){
		for(Cobertura_Enlatado__c coverage: coverages){
			if('029'.equalsIgnoreCase(coverage.name)){
				return coverage;
			}
		}

		throw new System.NoSuchElementException('Cobertura de Robo No Encontrada.');
	}

	/**
	 * Retorna el monto correspondiente a la sima Robo/hurto. Si es HP III (Comun) devuelve el monto de la cobertura de enlatado, en cambio si es HP III (Devolucion) devuelve el monto seleccionado que llega en el lead.
	//!ALERT: Deprecado en division de hogares.
	private static String getRoboHurtoInsuredAmount(Map<String,String> coverages, String selectedInsuredAmount, Boolean isDevolucion ){
		if (isDevolucion) {
			return selectedInsuredAmount;
		} else {
			return XMLDataConversion.stringToXML(coverages.get('029'),'0');
		}
	}*/

	/**Retorna el monto de cada cobertura mapeada con su respectivo codigo. */
	private static Map<String,String> getCoveragesAmountByCoverageCode(List<Cobertura_Enlatado__c> coverageCanned){
		Map<String,String> coverageAmountByCode = new Map<String,String>();

		for(Cobertura_Enlatado__c eachCoverage: coverageCanned){
			coverageAmountByCode.put(eachCoverage.name, eachCoverage.Monto_Cobertura__c.format().remove('.').replace(',','.'));
		}

		return coverageAmountByCode;
	}

	private static Double getAddon(Map<String,Add_On_Options__c> addonsByCode, String code){
		if(addonsByCode.containsKey(code)){
			return addonsByCode.get(code).Monto__c;
		}
		return 0;
	}

	/** Retorna las coberturas opcionales mapeadas por su codigo de Cobertura */
	private static Map<String,Add_On_Options__c> getAddonsAmountByCode(String addonsIdsString){
		Map<String,Add_On_Options__c> addonAmountByCode = new Map<String,Add_On_Options__c>();
		List<String> fatherToSearch = new List<String>();
		Integer extraAddonExpected = 0;

		if(String.isNotBlank(addonsIdsString)){
			List<String> addonsIds = addonsIdsString.split(',');

			for(Add_On_Options__c eachAddon : Add_On_Options__c.getAll().values()){
				if(addonsIds.contains(eachAddon.id)){
					addonAmountByCode.put(eachAddon.Codigo_Cobertura__c, eachAddon);
					fatherToSearch.add(eachAddon.name);
					if('056'.equalsIgnoreCase(eachAddon.Codigo_Cobertura__c)){
						extraAddonExpected = 1;
					}
				}
			}

			for(Add_On_Options__c eachAddon : Add_On_Options__c.getAll().values()){
				if(fatherToSearch.contains(eachAddon.Cobertura_Padre__c)){
					addonAmountByCode.put(eachAddon.Codigo_Cobertura__c, eachAddon);
				}
			}

			if((addonsIds.size() + extraAddonExpected) > addonAmountByCode.size()){
				throw new System.QueryException(Label.Addons_No_Encontrados);
			}

			
		}

		return addonAmountByCode;
	}

	private static void validateBeneficiary(Lead newLead) {

			List<Beneficiario_de_Venta__c> beneficiarios = [
				SELECT Id, Candidato__c, Porcentaje__c 
				FROM Beneficiario_de_Venta__c 
				WHERE Candidato__c = :newLead.Id
				];
			if (beneficiarios.size() > 4) {
				throw new Exceptions.ValidationException(BENEFICIARY_SIZE_ERROR);
			}
			double sumaPorcentaje = 0.0;
			
			for(Beneficiario_de_Venta__c beneficiario : beneficiarios){
				sumaPorcentaje += beneficiario.Porcentaje__c;
			}
			if(beneficiarios.size() > 0 && sumaPorcentaje != 100.0){
				throw new Exceptions.ValidationException(BENEFICIARY_PERCENTAGE_ERROR);
			}
	}
	private static void associateBeneficiariosDeVenta(Producto_Vendido__c pv,Lead newLead) {

		List<Beneficiario_de_Venta__c> beneficiarios = [
			SELECT Id, Producto_Vendido__c 
			FROM Beneficiario_de_Venta__c 
			WHERE Candidato__c = :newLead.Id
			];
		for (Beneficiario_de_Venta__c beneficiario : beneficiarios) {
			beneficiario.producto_vendido__c = pv.id;
		}
		update beneficiarios;
	}
}