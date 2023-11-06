public with sharing class GestionesBajaDerivadasController  {

	public Gestion__c gestionToCancel {get; set;}

	public String numeroFax {get; set;}
	public String aplicaORetieneSelection {get; set;}
	public String motivoDeBaja {get; set;}
	public Date fechaRegistroFax {get;set;}
	public Boolean reintegro {get;set;}
	
	public Boolean enableOperations {get;set;}


	//Los campos de  numero, motivo, reintegro y fecha solo son requerido en aplica, en retencion no son necesarios.
	// campos de motivo, fecha y numero son obligatorios para aplica.
	public PageReference save(){
		system.debug('save()');

		Boolean isValid = this.validate();
		Boolean hasError = false;
		try{
			if (isValid){
				Gestion__c gestionAux = this.gestionToCancel;

				WebServiceUpdateGestionBajaDerivado service = new WebServiceUpdateGestionBajaDerivado();
				Boolean operationSuccessful = service.updateGestionBajaDerivado(
																		this.gestionToCancel.Numero__c,
																		this.aplicaORetieneSelection,
																		this.numeroFax,
																		this.motivoDeBaja,
																		this.reintegro,
																		this.fechaRegistroFax);
				if(operationSuccessful){
					//Si es Aplica, le asigna los campos a la gestion.
					if(this.isAplica()){
						gestionAux.Motivo_Baja__c = this.motivoDeBaja;
						gestionAux.Motivo_Baja_IdBHSeg__c = XMLDataConversion.cancellationMotiveToXml(this.motivoDeBaja);

						gestionAux.Fecha_Registro_Fax__c = this.fechaRegistroFax;
						gestionAux.Reintegro__c = this.reintegro;

						gestionAux.Numero_Fax__c = this.numeroFax;
					} else {
						gestionAux.Motivo_Baja__c = this.gestionToCancel.Motivo_Baja__c;
						gestionAux.Motivo_Baja_IdBHSeg__c = this.gestionToCancel.Motivo_Baja_IdBHSeg__c;

						gestionAux.Fecha_Registro_Fax__c = this.gestionToCancel.Fecha_Registro_Fax__c;
						gestionAux.Reintegro__c = this.gestionToCancel.Reintegro__c;

						gestionAux.Numero_Fax__c = this.gestionToCancel.Numero_Fax__c;
					}

					gestionAux.Estado__c = this.aplicaORetieneSelection;
					gestionAux.Estado_IdBHSeg__c = XMLDataConversion.statusDerivedRequestToXML(this.aplicaORetieneSelection);
					gestionAux.Is_API_Update__c = true;

					update gestionAux;
				} else {
					ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'Se ha producido un error al comunicarse con rector, por favor vuelva a intentarlo.', '');
					ApexPages.addMessage(apexMessage);
					hasError =true;
				}

			} else {
				hasError =true;
			}
		}catch(Exception e) {
			CreateApexLog.create(new Map<MapLogArgKey, Object> { MapLogArgKey.EXCEPTIONINFO => e });
			throw e;
		}
		
		if(hasError){
			return null;
		} else{
			return new PageReference('/apex/Gestion_Baja_Derivada_Exitosa?Id=' + this.gestionToCancel.Id);
		}
	}

	public Boolean validate(){
		system.debug('validate()');
		return this.getIsNotAplicaSelected() || this.validateAplica();
	}

	@TestVisible
	private Boolean validateAplica(){
		system.debug('validateAplica()');
		Boolean hasError = false;

		Boolean validFaxNumber = String.isNotEmpty(this.numeroFax)
								&& this.numeroFax.isNumeric();

		Boolean validBaja = String.isNotBlank(this.motivoDeBaja) 
							&& this.motivoDeBaja != '--SELECCIONAR--';

		Boolean validFecha = this.fechaRegistroFax <= Date.today();

		if(!validFaxNumber){
			this.generateAndPushApexMessage('El numero de fax invalido:', 'Por favor revise que no esta vacio y que contiene solo numeros.');
			hasError = true;
		}
		if(!validBaja){
			this.generateAndPushApexMessage('Debe Seleccionar un Motivo de Baja.','');
			hasError = true;
		}
		if(!validFecha){
			this.generateAndPushApexMessage('Fecha Invalida:', 'La fecha tiene que ser igual o anterior a hoy.');
			hasError = true;
		}
		return !hasError;
	}

	public void generateAndPushApexMessage(String aMessage, String detail){
		system.debug('generateAndPushApexMessage()');
		ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.severity.ERROR, aMessage, detail);
		ApexPages.addMessage(apexMessage);
	}

	public Boolean getDisableSaveButton(){
		system.debug('getDisableSaveButton()');
		return String.isBlank(this.aplicaORetieneSelection) && this.getIsNotAplicaSelected();
	}

	public Boolean getIsNotAplicaSelected(){
		system.debug('getIsNotAplicaSelected()');
		return ! this.isAplica();
	}

	private Boolean isAplica(){
		return this.aplicaORetieneSelection.equalsIgnoreCase('Aplica');
	}	

	public List<SelectOption> getApplyOrRetain() {
		system.debug('getApplyOrRetain()');
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Aplica', 'Aplica')); 
        options.add(new SelectOption('Retiene', 'Retiene'));
		return options;
    }

	public List<SelectOption> getMotivoBajaOptions() {
		system.debug('getMotivoBajaOptions()');
		List<SelectOption> options = new list<SelectOption>();

		Schema.DescribeSObjectResult objDescribe = Gestion__c.getSObjectType().getDescribe();
		map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
		list<Schema.PicklistEntry> values = fieldMap.get('Motivo_Baja__c').getDescribe().getPickListValues();

		options.add(new SelectOption('--SELECCIONAR--', '--SELECCIONAR--')); 
		for (Schema.PicklistEntry a : values){ 
			options.add(new SelectOption(a.getLabel(), a.getValue())); 
		}

		return options;
    }

	private Boolean isValidGestionToOperate(Gestion__c gestionToCancel){
		return  'DERIVADO'.equalsIgnoreCase(gestionToCancel.Estado__c)
				&& 'BAJA'.equalsIgnoreCase(gestionToCancel.Tramite__c)
				&& '49'.equalsIgnoreCase(gestionToCancel.Tramite_IdBHSeg__c);
	}

/*[{}]--------------------------------------------------[{}]
  [{}]----------[CONSTRUCTORS && INITIALIZERS]----------[{}]
  [{}]--------------------------------------------------[{}]*/
	public GestionesBajaDerivadasController(ApexPages.StandardController gestionStandardController){
		this.aplicaORetieneSelection = '';
		this.gestionToCancel = null;
		this.aplicaORetieneSelection = '';
		this.motivoDeBaja = '';
		this.reintegro = false;
		this.fechaRegistroFax = null;
		this.enableOperations = true;
	}

	//todo Hay que hacer una verificacion de que si no encuentra la gestion o no es un parametro correcto, avise y no deje hacer nada.
	public void initializeController(){
		system.debug('initializeController()');
		try{
			String derivedGestionId = ApexPages.currentPage().getParameters().get('gestion');
		
			if(String.isBlank(derivedGestionId)){
				this.generateAndPushApexMessage('No se encuentra la gestion:','Por favor verifique y vuelva a intentarlo.');
				this.enableOperations = false;
				return;
			}

			List<Gestion__c> derivedManagements = [
				SELECT Id, 
					   Numero__c, 
					   Name, 
					   Estado__c, 
					   Tramite__c,
					   Tramite_IdBHSeg__c,
					   Numero_Fax__c,
					   Motivo_Baja__c, 
					   Reintegro__c, 
					   Fecha_Registro_Fax__c,
					   Is_API_Update__c
				FROM Gestion__c
				WHERE Id = :derivedGestionId
			];

			if(derivedManagements.isEmpty()){
				this.generateAndPushApexMessage('No hay Gestion asociada:','Por favor verifique y vuelva a intentarlo.');
				this.enableOperations = false;
				return;
			}

			this.gestionToCancel = derivedManagements.get(0);

			if(! this.isValidGestionToOperate(this.gestionToCancel)){
				this.generateAndPushApexMessage('Gestion Invalida:','No es una gestion valida para operar. Motivos:\n- No Es una Gestion De Baja.\n- La Gestion de Baja se Encuentra en un estado distinto a Derivado.');
				this.enableOperations = false;
				return;
			}

			this.numeroFax = this.gestionToCancel.Numero_Fax__c;
			this.motivoDeBaja = this.gestionToCancel.Motivo_Baja__c;
			this.fechaRegistroFax = this.gestionToCancel.Fecha_Registro_Fax__c;
			this.reintegro = this.gestionToCancel.Reintegro__c;
		} catch(Exception e) {
			CreateApexLog.create(new Map<MapLogArgKey, Object> { MapLogArgKey.EXCEPTIONINFO => e });
			throw e;
		}
	}
}