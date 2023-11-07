import { LightningElement, track, api, wire } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { getRecord } from "lightning/uiRecordApi";

import { getRelatedListRecords } from 'lightning/uiRelatedListApi';

import validateFinancialCoverage from '@salesforce/apex/AlertController.validateFinancialCoverage';
import validateTechniqueCoverage from '@salesforce/apex/AlertController.validateTechniqueCoverage';
import getLastAttachmentModifiedDateFromClaim from '@salesforce/apex/AlertController.getLastAttachmentModifiedDateFromClaim';

import NAME_FIELD from "@salesforce/schema/Claim.Name";
import LOSS_DATE_FIELD from "@salesforce/schema/Claim.LossDate";
import PERIL_CODE_FIELD from "@salesforce/schema/Claim.Claim_Peril_Code__c";
import TRADE_CODE_FIELD from "@salesforce/schema/Claim.PolicyNumber.Ramo_IdBHSeg__c";
import POLICY_NUMBER_FIELD from "@salesforce/schema/Claim.PolicyNumber.ReferencePolicyNumber";
import CERTIFICATE_FIELD from "@salesforce/schema/Claim.PolicyNumber.Certificado__c";
import ENDORSEMENT_FIELD from "@salesforce/schema/Claim.PolicyNumber.Endoso__c";
import P_TRADE_CODE_FIELD from "@salesforce/schema/Claim.Poliza__r.Ramo_IdBHSeg__c";
import P_POLICY_NUMBER_FIELD from "@salesforce/schema/Claim.Poliza__r.Poliza__c";
import P_CERTIFICATE_FIELD from "@salesforce/schema/Claim.Poliza__r.Certificado__c";
import P_ENDORSEMENT_FIELD from "@salesforce/schema/Claim.Poliza__r.Endoso__c";
import CLAIM_REASON_FIELD from "@salesforce/schema/Claim.ClaimReason";
import ANALYST_CODE_FIELD from "@salesforce/schema/Claim.Codigo_Analista__c";

export default class ClaimAdministrativeAlerts extends LightningElement {

    @api recordId;

    @track alerts = [{
        "type" : "financialCoverage",
        "title" : "Cobertura financiera",
        "success" : false,
        "wrong" : false,
        "error" : false,
        "loaded" : false,
        "successMessage" : "Se posee cobertura financiera sobre la póliza asociada al siniestro.",
        "wrongMessage" : "No se posee cobertura financiera sobre la póliza asociada al siniestro.",
        "errorMessage" : "Se tuvieron inconvenientes para evaluar el alerta, comuníquese con un administrador.",
        "Codigo_Analista__c": ""
      },{
        "type" : "techniqueCoverage",
        "title" : "Cobertura técnica",
        "success" : false,
        "wrong" : false,
        "error" : true,
        "loaded" : true,
        "successMessage" : "Se posee cobertura técnica sobre la póliza asociada al siniestro.",
        "wrongMessage" : "No se posee cobertura técnica sobre la póliza asociada al siniestro.",
        "errorMessage" : "Se tuvieron inconvenientes para evaluar el alerta, comuníquese con un administrador.",
        "Codigo_Analista__c": ""
      },
      /* SIN-233 | 17-10-2023 | Se oculta la baja administrativa.
      {
        "type" : "administrativeDeregistration",
        "title" : "Baja Administrativa",
        "success" : false,
        "wrong" : false,
        "error" : true,
        "loaded" : true,
        "successMessage" : "Se cumplió el plazo desde el último movimiento.",
        "wrongMessage" : "No se cumplió el plazo desde el último movimiento.",
        "errorMessage" : "Se tuvieron inconvenientes para evaluar el alerta, comuníquese con un administrador.",
        "Codigo_Analista__c": ""
      },*/
      {
        "type" : "lackCoverage",
        "title" : "Carencia",
        "success" : false,
        "wrong" : false,
        "error" : true,
        "loaded" : true,
        "successMessage" : "Se posee cobertura técnica por carencia sobre la póliza asociada al siniestro.",
        "wrongMessage" : "No se posee cobertura técnica por carencia sobre la póliza asociada al siniestro.",
        "errorMessage" : "Se tuvieron inconvenientes para evaluar el alerta, comuníquese con un administrador.",
        "Codigo_Analista__c": ""
      },{
        "type" : "extemporaneousComplaint",
        "title" : "Denuncia extemporánea",
        "success" : false,
        "wrong" : false,
        "error" : true,
        "loaded" : true,
        "successMessage" : "La denuncia actual cumple con el criterio de extemporánea.",
        "wrongMessage" : "La denuncia actual no cumple con el criterio de extemporánea.",
        "errorMessage" : "Se tuvieron inconvenientes para evaluar el alerta, comuníquese con un administrador.",
        "Codigo_Analista__c": ""
      },{
        "type" : "insuredRiskAddress",
        "title" : "Riesgo asegurado",
        "success" : false,
        "wrong" : false,
        "error" : true,
        "loaded" : true,
        "successMessage" : "El domicilio del riesgo asegurado se condice con el de bien asegurado.",
        "wrongMessage" : "El domicilio del riesgo asegurado no se condice con el de bien asegurado.",
        "errorMessage" : "Se tuvieron inconvenientes para evaluar el alerta, comuníquese con un administrador.",
        "Codigo_Analista__c": ""
      },
      {
        "type" : "noWhiteLineCoverage",
        "title" : "Sin Cobertura Línea Blanca",
        "success" : false,
        "wrong" : false,
        "error" : true,
        "loaded" : true,
        "successMessage" : "El domicilio del riesgo asegurado se condice con el de bien asegurado.",
        "wrongMessage" : "El domicilio del riesgo asegurado no se condice con el de bien asegurado.",
        "errorMessage" : "Se tuvieron inconvenientes para evaluar el alerta, comuníquese con un administrador.",
        "Codigo_Analista__c": ""
      },
      {
        "type" : "noLightningCoverage",
        "title" : "Sin Cobertura Rayo",
        "success" : false,
        "wrong" : false,
        "error" : true,
        "loaded" : true,
        "successMessage" : "El domicilio del riesgo asegurado se condice con el de bien asegurado.",
        "wrongMessage" : "El domicilio del riesgo asegurado no se condice con el de bien asegurado.",
        "errorMessage" : "Se tuvieron inconvenientes para evaluar el alerta, comuníquese con un administrador.",
        "Codigo_Analista__c": ""
    }];

    @track lastUpdate = new Date();
    @track loaded = false;
    @track analista = "";
    @track shouldLoad = false;

    claim = null;
    claimCoverages = [];

    connectedCallback(){}

    @wire(getRecord, {
      recordId: '$recordId', 
      fields: [NAME_FIELD, PERIL_CODE_FIELD, LOSS_DATE_FIELD, TRADE_CODE_FIELD, POLICY_NUMBER_FIELD, CERTIFICATE_FIELD, ENDORSEMENT_FIELD, P_CERTIFICATE_FIELD, P_ENDORSEMENT_FIELD, P_POLICY_NUMBER_FIELD, P_TRADE_CODE_FIELD, CLAIM_REASON_FIELD, ANALYST_CODE_FIELD]
    })
    wiredRecord({ error, data }) {
      if (error) {
        console.log("Administrative Error", error);
        this.dispatchEvent(
          new ShowToastEvent({
              title: 'Error!',
              message : 'Se tuvieron inconvenientes para obtener el siniestro.',
              variant: 'error',
          }),
        );
        this.shouldLoad = false;
        this.loaded = true;
      } else if (data) {
        this.claim = this.getSObject(data);
        // SIN-233 | 17-10-2023 | Se valida si es un siniestro de rechazo.
        this.shouldLoad = (this.claim.Name != 'SIN-CALL');
        console.info("Should Load", this.shouldLoad);
        if(this.claim.PolicyNumber){
          this.claim.PolicyNumber = this.getSObject(this.claim.PolicyNumber);
        }
        if (this.claim.Poliza__r) {
          this.claim.Poliza__r = this.getSObject(this.claim.Poliza__r);
        }
        this.analista = this.claim.Codigo_Analista__c;
        this.loadClaimAlerts();
      }
    }

    @wire(getRelatedListRecords, {
      parentRecordId: '$recordId',
      relatedListId: 'ClaimCoverages',
      fields: ['ClaimCoverage.Id','ClaimCoverage.Name', 'ClaimCoverage.Codigo_Cobertura__c']
    })
    wiredRelatedListRecords({ error, data }) {
      if (error) {
        console.log("Administrative Claim Coverage Error", error);
        this.dispatchEvent(
          new ShowToastEvent({
              title: 'Error!',
              message : 'Se tuvieron inconvenientes para obtener las coberturas de siniestro.',
              variant: 'error',
          }),
        );
        this.loaded = true;
      } else if (data) {
        data.records.forEach(element => {
          this.claimCoverages.push(this.getSObject(element));
        });
        this.loadCoveragesClaimAlerts();
      }
    }

    getLastAttachmentModifiedDate() {
      getLastAttachmentModifiedDateFromClaim({aClaim: this.claim})
        .then(response => {
          let lastModifiedDate = new Date(response);
          console.info("Last Modified Date: ", lastModifiedDate);
          return lastModifiedDate;
        })
    }

    updateAlerts(){
      this.loaded = false;
      this.loadClaimAlerts();
      this.loadCoveragesClaimAlerts();
    }

    loadClaimAlerts(){
      this.financialCoverageAlert();
      // SIN-233 | 17-10-2023 | No se carga la baja administrativa
      // this.administrativeDeregistrationAlert();
      this.lackCoverageAlert();
      this.extemporaneousComplaintAlert();
      this.insuredRiskAddressAlert();
      this.noWhiteLineCoverageAlert();
      this.noLightningCoverageAlert();
    }

    loadCoveragesClaimAlerts(){
      this.techniqueCoverageAlert();
    }

    // Alerta sin Cobertura Financiera
    financialCoverageAlert(){
      if (this.claim && (this.claim.PolicyNumber || this.claim.Poliza__r)) {
        validateFinancialCoverage({aClaim : this.claim, policy: this.claim.Poliza__r})
          .then(response => {
            let result = (response && response.status) ? (response.result ? 'success' : 'wrong') : 'error';
            this.setAlertStatus('financialCoverage', result);
        })
        .catch(error => {
          console.info("Error validateFinancialCoverage", error);
        });
      } else {
        this.setAlertStatus('financialCoverage', 'error');
      }
    }

    // Alerta sin Cobertura Técnica
    techniqueCoverageAlert(){
      if (this.claim && (this.claim.Poliza__r || this.claim.PolicyNumber)){
        validateTechniqueCoverage({aClaim : this.claim, coverages : this.claimCoverages})
          .then(response => {
            let result = (response && response.status) ? (response.result ? 'success' : 'wrong') : 'error';
            this.setAlertStatus('techniqueCoverage', result);
        })
        .catch(error => {
          console.info("Error techniqueCoverage", error);
        });
      } else {
        this.setAlertStatus('techniqueCoverage', 'error');
      }
    }

    // Alerta Baja Administrativa
    administrativeDeregistrationAlert() {
      let result;
        if(this.claim 
            && (this.claim.PolicyNumber || this.claim.Poliza__r)
            ){
              if ((parseInt(this.claim.Affected_Trade_Code__c) == 1 || parseInt(this.claim.Affected_Trade_Code__c) == 2 || parseInt(this.claim.Affected_Trade_Code__c) == 3 || parseInt(this.claim.Affected_Trade_Code__c) == 9 || parseInt(this.claim.Affected_Trade_Code__c) == 17)) {
                let sumaAsegurada = (this.claim.PolicyNumber) ? parseInt(this.claim.PolicyNumber.Suma_Asegurada__c) : parseInt(this.claim.Poliza__r.Suma_Asegurada__c);
                let sumaAseguradaMenor50k = sumaAsegurada < 50000;
                let mesesInactividad = (sumaAseguradaMenor50k) ? 6 : 12;
                let controlDate = new Date(this.getLastAttachmentModifiedDate());
                let lastModifiedDatePlusAllowedInactiveLapsus = new Date(controlDate.getMonth()+mesesInactividad);
                result = (lastModifiedDatePlusAllowedInactiveLapsus > controlDate) ? 'success' : 'wrong';
              } else {
                result = 'error';
              }
        }else{
            result = 'error';
        }
        this.setAlertStatus('administrativeDeregistration', result);
    }

    // Alerta Carencia
    lackCoverageAlert() {
      let result;
        if(this.claim 
            && (this.claim.PolicyNumber || this.claim.Poliza__r)){
              let producto = (this.claim.PolicyNumber) ? parseInt(this.claim.PolicyNumber.Producto_IdBHSeg__c) : parseInt(this.claim.Poliza__r.Producto_IdBHSeg__c); 
              let coverageAlertProd201_202_203_205 = (parseInt(this.claim.Affected_Trade_Code__c) == 2
                                                      && this.claim.ClaimReasonType.toUpperCase() == ('Daño de electrodomésticos').toUpperCase()
                                                      && (producto == 201 || producto == 202 || producto == 203 || producto == 205));
              let coverageAlertProd212_213_214_215 = (parseInt(this.claim.Affected_Trade_Code__c) == 2
                                                      && this.claim.ClaimReasonType.toUpperCase() == ('Daño de electrodomésticos').toUpperCase()
                                                      && (producto == 212 || producto == 213 || producto == 214 || producto == 215));
              let coverageAlertRamo3 = (parseInt(this.claim.Affected_Trade_Code__c) == 3
                                        && this.claim.ClaimReasonType.toUpperCase() == ('Desempleo').toUpperCase());
              let coverageAlertRamo9 = (parseInt(this.claim.Affected_Trade_Code__c) == 9
                                        && this.claim.ClaimReasonType.toUpperCase() == ('Robo, Hurto o Daño').toUpperCase()
                                        && producto == 254);
              if (!coverageAlertProd201_202_203_205 && !coverageAlertProd212_213_214_215 && !coverageAlertRamo3 && !coverageAlertRamo9) {
                result = 'error';
              } else {
                if (coverageAlertProd201_202_203_205 || coverageAlertRamo9) {
                  let fechaEmision = (this.claim.PolicyNumber) ? this.claim.PolicyNumber.Fecha_Emision__c : this.claim.Poliza__r.Fecha_Emision__c;
                  let controlDate = new Date(fechaEmision);
                  controlDate.setDate(controlDate.getDate() + 30);
                  result = new Date(this.claim.LossDate) <= controlDate? 'success' : 'wrong';
                } else if (coverageAlertProd212_213_214_215 || coverageAlertRamo3) {
                  let controlDate = new Date(fechaEmision);
                  controlDate.setDate(controlDate.getDate() + 60);
                  result = new Date(this.claim.LossDate) <= controlDate? 'success' : 'wrong';
                }
              }
              if (result != 'wrong'){
                if (coverageAlertProd201_202_203_205 || coverageAlertProd212_213_214_215) {
                  if (this.claim.ClaimReason.toUpperCase == "Golpe o caida".toUpperCase()) {
                    this.setAlertStatus('techniqueCoverage', 'wrong');
                  }
                } else if (coverageAlertRamo3) {
                  if (this.claim.ClaimReason.toUpperCase == "Desempleo".toUpperCase()) {
                    this.setAlertStatus('techniqueCoverage', 'wrong');
                  }
                } else if (coverageAlertRamo9) {
                  if (this.claim.ClaimReason.toUpperCase == "Robo".toUpperCase()) {
                    this.setAlertStatus('techniqueCoverage', 'wrong');
                  }
                }
              }
        } else {
            result = 'error';
        }
        this.setAlertStatus('lackCoverage', result);
    }

    // Alerta Denuncia Exptemporanea
    extemporaneousComplaintAlert() {
      let result;
        if(this.claim 
            && (this.claim.PolicyNumber || this.claim.Poliza__r)){
              if ((parseInt(this.claim.Affected_Trade_Code__c) == 1 || parseInt(this.claim.Affected_Trade_Code__c) == 2)) {
                let fechaEmision = (this.claim.PolicyNumber) ? this.claim.PolicyNumber.Fecha_Emision__c : this.claim.Poliza__r.Fecha_Emision__c;
                let controlDate = new Date(fechaEmision);
                controlDate.setDate(controlDate.getDate() + 30);
                result = new Date(this.claim.LossDate) > controlDate? 'success' : 'wrong';
              } else {
                result = 'wrong';
              }
        } else {
            result = 'error';
        }
        this.setAlertStatus('extemporaneousComplaint', result);
    }

    // Alerta No Coincide Riesgo Asegurado
    insuredRiskAddressAlert() {
      let result;
      if (!this.claim || !(this.claim.PolicyNumber || this.claim.Poliza__r)) {
        result = 'error';
      } else {
        let ramoCorrecto = (parseInt(this.claim.Affected_Trade_Code__c) == 1 || parseInt(this.claim.Affected_Trade_Code__c) == 2);
        let address = (this.claim.PolicyNumber) ? this.claim.PolicyNumber.Domicilio__c : this.claim.Poliza__r.Domicilio__c;
        let sameAddress = (this.claim.IncidentSite == address);
        result = (ramoCorrecto && sameAddress) ? 'success' : ((ramoCorrecto) ? 'wrong' : 'error');
      }
      this.setAlertStatus('insuredRiskAddress', result);
    }

    noWhiteLineCoverageAlert() {
      let result;
      if (!this.claim || !(this.claim.PolicyNumber || this.claim.Poliza__r) || !this.claim.ClaimReasonType) {
        result = 'error';
      } else {
        let ramoCorrecto = (parseInt(this.claim.Affected_Trade_Code__c) == 2);
        let causeString = this.claim.ClaimReasonType.toString();
        let cause = (causeString === undefined) ? false : causeString.toUpperCase() == ('Daño Electrodomesticos').toUpperCase();
        let producto = (this.claim.PolicyNumber) ? parseInt(this.claim.PolicyNumber.Producto_IdBHSeg__c) : parseInt(this.claim.Poliza__r.Producto_IdBHSeg__c);
        let productoCorrecto = (producto == 213 || producto == 214 || producto == 215);
        result = (productoCorrecto && cause && ramoCorrecto) ? 'success' : 'wrong';
      }
      this.setAlertStatus('noWhiteLineCoverage', result);
    }

    noLightningCoverageAlert() {
      let result;
      if (!this.claim || !(this.claim.PolicyNumber || this.claim.Poliza__r) || !this.claim.ClaimReasonType) {
        result = 'error';
      } else {
        let ramoCorrecto = (parseInt(this.claim.Affected_Trade_Code__c) == 2);
        let causeString = this.claim.ClaimReasonType.toString();
        let cause = (causeString === undefined) ? false : causeString.toUpperCase() == ('Daño Electrodomesticos').toUpperCase();
        let producto = (this.claim.PolicyNumber) ? parseInt(this.claim.PolicyNumber.Producto_IdBHSeg__c) : parseInt(this.claim.Poliza__r.Producto_IdBHSeg__c);
        let productoCorrecto = (producto == 205);
        if (!ramoCorrecto || !productoCorrecto || !cause) {
          result = 'error';
        } else {
          let fechaEmision = (this.claim.PolicyNumber) ? this.claim.PolicyNumber.Fecha_Emision__c : this.claim.Poliza__r.Fecha_Emision__c;
          let controlDate = new Date(fechaEmision);
          controlDate.setDate(controlDate.getDate() + 30);
          result = new Date(this.claim.LossDate) <= controlDate? 'success' : 'wrong';
          if (this.claim.ClaimReason.toUpperCase() == "Rayo y/o Descarga Eléctrica".toUpperCase() && result != 'wrong') {
            result = 'wrong';
          }
        }
      }
      this.setAlertStatus('noLightningCoverage', result);
    }

    setAlertStatus(type, result){
      this.alerts.forEach(alert => {
        if(type == alert.type){
          alert.success = result === 'success';
          alert.wrong = result === 'wrong';
          alert.error = result === 'error';
          alert.loaded = true;
        }
        if(!alert.error && (alert.success || alert.wrong) && alert.loaded) {
          alert.Codigo_Analista__c = "Analista: " + this.analista;
        }
      });
      this.validateExecution();
    }

    validateExecution(){
      let syncComplete = true;
      this.alerts.forEach(alert => {
        syncComplete = syncComplete && alert.loaded;
      });
      this.loaded = syncComplete;
    }

    getSObject(wiredData) {
        let sObject = {
            sobjectType: wiredData.apiName,
            Id: wiredData.id
        };
        Object.keys(wiredData.fields).map(fieldPath => {
            sObject[fieldPath] = wiredData.fields[fieldPath].value;
        });
        return sObject;
    }
}