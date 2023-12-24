/**
 * @description       :
 * @author            : Victor M. Degano
 * @group             : Globant
 * @affected jiras    : EV-1802, EV-1845
 * @last modified on  : 12-06-2023
 * @last modified by  : Victor M. Degano
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   31-05-2023   Victor M. Degano   Initial Version
 * 1.0   05-06-2023   Victor M. Degano   Fix de performance
 * 1.0   12-06-2023   Victor M. Degano   Fix de sobre la logica de seteo de titulo e icono
 **/
import { LightningElement, wire, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { OmniscriptBaseMixin } from "vlocity_ins/omniscriptBaseMixin";
import pubsub from "vlocity_ins/pubsub";
import { CurrentPageReference, NavigationMixin } from "lightning/navigation";

export default class NuevoCaso extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    @track isLoading = true;
    @track init = false;

    @track prefill = null;
    @track prefillChilList = null;

    @track parentCaseId;
    @track accountId;

    @track buttonFinish = false;
    @track toUpdate = false;
    @track toUpdateSummaryList = false;

    @track hasError = false;

    @track modalMessagge;
    @track modalTitle;
    @track isShowModal = false;

    _myPubSubHandlers = {
        data: this.handleOmniAction.bind(this)
    };

    constructor() {
        super();
        this.setTitleAndIcon();
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            const parameters =
                currentPageReference.state.fragment != undefined ? currentPageReference.state.fragment.split("&") : [];
            if (parameters.length > 0) {
                this.accountId = parameters[0].split("=")[1];
                console.log(">>>>>>> Inicio");

                let params = {
                    input: {
                        accountId: this.accountId
                    },
                    sClassName: "NuevoCasoController",
                    sMethodName: "validateAccount",
                    options: "{}"
                };
                this.omniRemoteCall(params, true)
                    .then((response) => {
                        console.log("Cliente >>" + JSON.stringify(response));

                        if (!response.error) {
                            if (parameters.length > 1) {
                                this.parentCaseId = parameters[1].split("=")[1];

                                params = {
                                    input: {
                                        caseId: this.parentCaseId
                                    },
                                    sClassName: "NuevoCasoController",
                                    sMethodName: "getCaseInfo",
                                    options: "{}"
                                };
                                this.omniRemoteCall(params, true)
                                    .then((response) => {
                                        console.log("Caso >> " + JSON.stringify(response));
                                        if (!response.error) {
                                            this.buttonFinish = response.result.case.Status == "Abierto";

                                            this.prefill = {
                                                ContextId: this.accountId,
                                                ParentCaseId: this.parentCaseId
                                            };
                                            this.prefillChilList = { ContextId: this.parentCaseId };

                                            this.init = true;
                                            this.isLoading = false;
                                        } else {
                                            this.hasError = true;
                                            this.showToast(
                                                "¡Error!",
                                                "Este CASO PRINCIPAL no fue encontrado",
                                                "error",
                                                "sticky"
                                            );

                                            this.isLoading = false;
                                        }
                                    })
                                    .catch((error) => {
                                        this.hasError = true;
                                        this.showToast(
                                            "¡Error!",
                                            "Este es un error inesperado: consulte a su administrador (Consulta getCaseInfo)",
                                            "error",
                                            "sticky"
                                        );

                                        this.isLoading = false;
                                    });
                            } else {
                                this.prefill = { ContextId: this.accountId };
                                this.init = true;
                                this.isLoading = false;
                            }
                        } else {
                            this.hasError = true;
                            this.showToast("¡Error!", "Este CLIENTE no fue encontrado", "error", "sticky");

                            this.isLoading = false;
                        }
                    })
                    .catch((error) => {
                        this.hasError = true;
                        this.showToast(
                            "¡Error!",
                            "Este es un error inesperado: consulte a su administrador (Consulta validateAccount)",
                            "error",
                            "sticky"
                        );

                        this.isLoading = false;
                    });
            } else {
                this.init = true;
                this.isLoading = false;
            }
        }
    }

    handleOmniAction(data) {
        // perform logic to handle the Action's
        console.log("Evento Omni: " + JSON.stringify(data));
        console.log("ParentCaseIdFromEvent: " + JSON.stringify(data.parentId));

        /*
        * We check if ParentCaseId query param exist and its correct to avoid unwanted page refreshes.
        * We check on Hash url cause AccountID and ParentCaseId are loaded in the Hash location
        */
        const startWithHash = window.location.hash.lastIndexOf("#") === 0;
        const currentState = new URLSearchParams(startWithHash ? window.location.hash.slice(1) : window.location.hash); //We have the state in the Hash of URL.
        if (!currentState.has("ParentCaseId") && currentState.get("ParentCaseId") !== data.parentId) {
            currentState.set("ParentCaseId", data.parentId);
            window.location.hash = currentState.toString();
        }

        if (!data.parentCaseSaved) {
            this.toUpdateSummaryList = !this.toUpdateSummaryList;
        } else {

            /*
            * Check if parentCaseIds are distinct to avoid unwanted behavior
            */
            if (this.parentCaseId !== data.parentId) {
                this.parentCaseId = data.parentId;
            }

            const params = {
                input: {
                    caseId: this.parentCaseId
                },
                sClassName: "NuevoCasoController",
                sMethodName: "getCaseInfo",
                options: "{}"
            };
            this.omniRemoteCall(params, true)
                .then((response) => {
                    console.log("Omni Action Caso >> " + JSON.stringify(response));
                    if (!response.error) {
                        this.buttonFinish = response.result.case.Status == "Abierto";

                        this.prefill = { ContextId: this.accountId, ParentCaseId: this.parentCaseId };
                        this.prefillChilList = { ContextId: this.parentCaseId };
                    } else {
                        this.showToast("¡Error!", "Este CASO PRINCIPAL no fue encontrado", "error", "sticky");

                        this.isLoading = false;
                    }
                })
                .catch((error) => {
                    this.hasError = true;
                    this.showToast(
                        "¡Error!",
                        "Este es un error inesperado: consulte a su administrador (Consulta handleOmniAction-getCaseInfo)",
                        "error",
                        "sticky"
                    );

                    this.isLoading = false;
                });
        }
    }

    handleClickFinalizar(event) {
        this.isLoading = true;
        console.log("Fini");

        const params = {
            input: {
                caseId: this.parentCaseId
            },
            sClassName: "NuevoCasoController",
            sMethodName: "finishMainCase",
            options: "{}"
        };
        this.omniRemoteCall(params, true)
            .then((response) => {
                console.log("Caso >> " + JSON.stringify(response));
                if (!response.error) {
                    console.log("final result");
                    this.showToast("¡Finalizado!", "Has finalizado tu caso principal", "success");

                    this.buttonFinish = false;
                    this.toUpdate = !this.toUpdate;

                    this.isLoading = false;
                } else {
                    if (response.result.error == "Es necesario agregar operaciones a realizar...") {
                        this.showToast("Cuidado!", response.result.error, "warning", "sticky");
                    } else {
                        this.showToast(
                            "¡Error!",
                            "Este es un error inesperado: consulte a su administrador (Consulta finishMainCase): " +
                                response.result.error,
                            "error",
                            "sticky"
                        );
                    }
                    this.isLoading = false;
                }
            })
            .catch((error) => {
                this.hasError = true;
                this.showToast("¡Error!", "Hubo un problema finalizando el caso principal", "error", "sticky");

                this.isLoading = false;
            });
    }

    showToast(title, messagge, variant, mode = "dismissible") {
        const event = new ShowToastEvent({
            title: title,
            message: messagge,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(event);
    }

    connectedCallback() {
        pubsub.register("omniscript_action", this._myPubSubHandlers);
    }

    disconnectedCallback() {
        pubsub.unregister("omniscript_action", this._myPubSubHandlers);
    }

    invokeWorkspaceAPI(methodName, methodArgs) {
        return new Promise((resolve, reject) => {
            const apiEvent = new CustomEvent("internalapievent", {
                bubbles: true,
                composed: true,
                cancelable: false,
                detail: {
                    category: "workspaceAPI",
                    methodName: methodName,
                    methodArgs: methodArgs,
                    callback: (err, response) => {
                        if (err) {
                            return reject(err);
                        }

                        return resolve(response);
                    }
                }
            });
            window.dispatchEvent(apiEvent);
            this.dispatchEvent(apiEvent);
        });
    }

    setTitleAndIcon() {
        this.invokeWorkspaceAPI("isConsoleNavigation")
            .then(
                (isConsole) => {
                    if (!isConsole) {
                        return;
                    }

                    this.invokeWorkspaceAPI("getFocusedTabInfo")
                        .then((focusedTab) => {
                            const url = new URL(focusedTab.url);
                            if(url.pathname.toUpperCase().includes("Nuevo_Caso_V2".toUpperCase())){
                                this.setTitle(focusedTab);
                                this.setIcon(focusedTab)
                            }
                        }
                    );
                }
            );
    }

    setTitle(focusedTab) {
        if("Cargando...".toUpperCase() === focusedTab.title.toUpperCase()){
            this.invokeWorkspaceAPI("setTabLabel", {
                tabId: focusedTab.tabId,
                label: "Registrar Contacto"
            });
        }
    }

    setIcon(focusedTab) {
        if("standard:generic_loading".toUpperCase() === focusedTab.icon.toUpperCase()){
            this.invokeWorkspaceAPI("setTabIcon", {
                tabId: focusedTab.tabId,
                icon: "utility:contact_request",
                iconAlt: "Registrar Contacto"
            });
        }
    }
}