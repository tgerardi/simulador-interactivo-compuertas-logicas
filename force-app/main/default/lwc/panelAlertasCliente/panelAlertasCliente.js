// alertPanelAccount.js
import { LightningElement, track } from 'lwc';
import updateAlerts from '@salesforce/apex/AlertPanelAccountController.updateAlerts';

export default class AlertPanelAccount extends LightningElement {
    @track alerts;

    loadAlerts() {
        updateAlerts()
            .then(result => {
                this.alerts = result;
            })
            .catch(error => {
                console.error('Error al cargar alertas', error);
            });
    }
}
