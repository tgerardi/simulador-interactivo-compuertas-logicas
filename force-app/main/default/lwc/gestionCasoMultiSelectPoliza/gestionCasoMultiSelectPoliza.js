import { api, LightningElement, track } from 'lwc';
import { OmniscriptBaseMixin } from "vlocity_ins/omniscriptBaseMixin";

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class GestionCasoMultiSelectPoliza extends OmniscriptBaseMixin(LightningElement) {
    @api selectedOptionsList = [];

    @api disabled = false;
    @api accountId = '';
    @api label = 'Pólizas disponibles';
    @api name = 'Pólizas disponibles';
    @api options = [];
    @api placeholder = 'Escoge una o varias opciones';
    @api initialSelectedOptions = '';

    @api readOnly = false;
    @api required = false;
    @api singleSelect = false;
    @api showPills = false;
    @track currentOptions = [];
    selectedItems = [];
    selectedOptions = [];
    isInitialized = false;
    isLoaded = false;
    isVisible = false;
    isDisabled = false;
    connectedCallback() {
        this.isDisabled = this.disabled || this.readOnly;
        this.hasPillsEnabled = this.showPills && !this.singleSelect;
    }
    renderedCallback() {
        if (!this.isInitialized) {
            let params = {
                input: {
                    "accountId": this.accountId,

                },
                sClassName: "GestionCasoOmniscriptController",
                sMethodName: "populatePolizaPicklistReevioPoliza",
                options: "{}",
            };
            this.omniRemoteCall(params, true).then((response) => {
                console.log("Caso >> " + JSON.stringify(response));
                if(!response.error){
                    let newlist = [];
                    for (let i = 0; i< response.result.options.length; i++) {
                        let selected = this.initialSelectedOptions != '' && this.initialSelectedOptions != undefined ? this.initialSelectedOptions.includes(response.result.options[i].name) : false;
                        newlist.push({label: response.result.options[i].value, value:response.result.options[i].name, selected: selected});
                        //this.currentOptions.push({label: response.result.options[i].value, value:response.result.options[i].name, selected: true});
                    }
                    
                    this.options = newlist;

                    this.currentOptions = JSON.parse(JSON.stringify(this.options));
                    this.omniApplyCallResp({selectedPoliza : this.initialSelectedOptions});
                    this.setSelection();
                }else{
                    this.showToast('¡Error!','No se pudo obtener el listado de pólizad disponibles de este usuario', 'error', 'sticky');
                }

            }).catch(error =>{
                this.showToast('¡Error!','Este es un error inesperado: consulte a su administrador', 'error', 'sticky');
            })

            this.template.querySelector('.multi-select-combobox__input').addEventListener('click', (event) => {
                this.handleClick(event.target);
                event.stopPropagation();
            });
            this.template.addEventListener('click', (event) => {
                event.stopPropagation();
            });
            document.addEventListener('click', () => {
                this.close();
            });
            this.isInitialized = true;
            this.setSelection();
        }
    }
    handleChange(event) {
        this.change(event);
    }
    handleRemove(event) {
        this.selectedOptions.splice(event.detail.index, 1);
        this.change(event);
    }
    handleClick() {
        console.log("Test1");
        // initialize picklist options on first click to make them editable
        if (this.isLoaded === false) {
            this.currentOptions = JSON.parse(JSON.stringify(this.options));
            this.isLoaded = true;
        }
        if (this.template.querySelector('.slds-is-open')) {
            this.close();
        } else {
            this.template.querySelectorAll('.multi-select-combobox__dropdown').forEach((node) => {
                node.classList.add('slds-is-open');
            });
        }
    }
    change(event) {
        console.log("Test2");
        // remove previous selection for single select picklist
        if (this.singleSelect) {
            this.currentOptions.forEach((item) => (item.selected = false));
        }
        // set selected items
        this.currentOptions
            .filter((item) => item.value === event.detail.item.value)
            .forEach((item) => (item.selected = event.detail.selected));
        this.setSelection();
        const selection = this.getSelectedItems();
        this.selectedOptionsList = this.singleSelect ? selection[0] : selection;

        let selectedOptionsListString = '';
        if(this.singleSelect ){
            selectedOptionsListString = this.selectedOptionsList != undefined ? this.selectedOptionsList.value : '';
        }else{ 
            for (let i = 0; i < this.selectedOptionsList.length; i++) {
                if(i != 0){
                    selectedOptionsListString += ';';
                }
                selectedOptionsListString += this.selectedOptionsList[i].value;
            }
        }
        
        this.omniApplyCallResp({selectedPoliza : selectedOptionsListString});
        this.dispatchEvent(new CustomEvent('change', { detail: this.selectedOptionsList }));
        // for single select picklist close dropdown after selection is made
        if (this.singleSelect) {
            this.close();
        }
    }
    close() {
        this.template.querySelectorAll('.multi-select-combobox__dropdown').forEach((node) => {
            node.classList.remove('slds-is-open');
        });
        this.dispatchEvent(new CustomEvent('close'));
    }
    setSelection() {
        console.log("Test3");
        const selectedItems = this.getSelectedItems();
        let selection = '';
        if (selectedItems.length < 1) {
            selection = this.placeholder;
            this.selectedOptions = [];
        } else if (selectedItems.length > 1) {
            selection = `${selectedItems.length} opciones seleccionadas`;
            this.selectedOptions = this.getSelectedItems();
        } else {
            selection = selectedItems.map((selected) => selected.label).join(', ');
            this.selectedOptions = this.getSelectedItems();
        }
        this.selectedItems = selection;
        this.isVisible = this.selectedOptions && this.selectedOptions.length > 0;
    }

    getSelectedItems() {
        return this.currentOptions.filter((item) => item.selected);
    }

    showToast(title, messagge, variant, mode = 'dismissible') {
        const event = new ShowToastEvent({
            title: title,
            message: messagge,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(event);
    }
}