import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import updateAlerts from '@salesforce/apex/AlertPanelAccountController.updateAlerts';

import NAME_FIELD from '@salesforce/schema/Account.Name';
import { getReplicatedDataset } from 'lightning/analyticsWaveApi';

export default class PanelAlertasCliente extends LightningElement {

    @api recordId;

    @wire(getRecord, {recordId: '$recordId', fields: [NAME_FIELD]})
    record;

    get name() {
        return this.record.data ? getFieldValue(this.record.data, NAME_FIELD) : '';
    }
}