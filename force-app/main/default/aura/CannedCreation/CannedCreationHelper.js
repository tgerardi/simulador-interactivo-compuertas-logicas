/**
 * @description       :
 * @author            : Victor M. Degano
 * @group             : Globant
 * @affected jiras    : EV-1686, EV-1778
 * @last modified on  : 04-07-2023
 * @last modified by  : Victor M. Degano
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   17-05-2023   Victor M. Degano   Initial Version
 * 1.0   23-05-2023   Victor M. Degano   Modificacion para precarga de asistencia por producto EV-1778
 **/
({
    getInitialValues: function (component) {
        const addressContext = LightningUtilities.getAddressableContext(component);
        const identifierCannedId = addressContext.attributes ? addressContext.attributes.recordId : "";
        const comeWithIdentifier = identifierCannedId && "" != identifierCannedId;

        LightningUtilities.callApex(component, "getInitialOptions", {
            cannedIdentifierId: identifierCannedId
        })
            .then((result) => this.handleInitValuesSuccess(component, result, comeWithIdentifier))
            .catch((errors) => this.handleInitValuesError(component, errors));
    },
    handleInitValuesSuccess: function (component, result, comeWithIdentifier) {
        LightningUtilities.setState(component, "v.state", {
            "options.trades": this.mapToOptions(result.tradeOptions),
            "options.products": this.mapToOptions(result.productOptions),
            "options.sponsors": this.mapToOptions(result.sponsorOptions),
            "options.useTypes": this.mapToOptions(result.useTypeOptions),
            "options.assistances": this.mapToOptions(result.assistanceOptions),
            "componentControls.comeWithIdentifier": comeWithIdentifier,
            "componentControls.hasTradeSelected": comeWithIdentifier,
            "componentControls.hasProductSelected": comeWithIdentifier,
            "componentControls.assistancePreloaded": "NO SELECTED" != result.assistanceDefaultValue.toUpperCase(),
            "componentControls.showWarningAlert": comeWithIdentifier && "NO SELECTED" == result.assistanceDefaultValue.toUpperCase(),
            useTypeSelected: result.usetTypeDefaultValue,
            tradeSelected: result.tradeDefaultValue,
            sponsorSelected: result.sponsorDefaultValue,
            productSelected: result.productDefaultValue,
            assistanceSelected: result.assistanceDefaultValue
        });
        this.handleCanContinue(component);
    },
    mapToOptions: function (values) {
        return Object.entries(values)
            .map((list) => {
                return { value: list[0], text: list[1] };
            })
            .sort((valueA, valueB) => {
                return this.sortOptions(valueA.text, valueB.text);
            });
    },
    handleInitValuesError: function (component, errors) {
        LightningUtilities.showToast(
            "¡Hubo un Error!",
            "sticky",
            "No se pudieron cargar algunas de las opciones, por favor reintente.",
            "error",
            "close"
        );
        component.set("v.state.componentControls.isLoading", false);
    },
    getProductValues: function (component, selectedTrade) {
        LightningUtilities.callApex(component, "getProductOptions", {
            trade: selectedTrade
        })
            .then((result) => {
                this.handleGetProductValuesSuccess(component, result);
            })
            .catch((errors) => {
                this.handleGetProductValuesError(component, errors);
            });
    },
    handleGetProductValuesSuccess: function (component, result) {
        LightningUtilities.setState(component, "v.state", {
            "options.products": this.mapToOptions(result.productOptions),
            "componentControls.hasProductSelected": false,
            "componentControls.assistancePreloaded":false,
            "componentControls.showWarningAlert": false,
            "componentControls.hasTradeSelected": true,
            productSelected: result.productDefaultValue,
            sponsorSelected: "No Selected",
            assistanceSelected: "No Selected",
            "componentControls.isLoading": false
        });
    },
    handleGetProductValuesError: function (component, errors) {
        LightningUtilities.showToast(
            "¡Hubo un Error!",
            "sticky",
            "No se pudieron obtener las opciones de productos, por favor reintente.",
            "error",
            "close"
        );
        component.set("v.state.componentControls.isLoading", false);
    },
    sortOptions: function (valueA, valueB) {
        if (valueA < valueB) {
            return -1;
        }
        if (valueA > valueB) {
            return 1;
        }
        return 0;
    },
    getAssistanceValues: function (component, selectedTrade, selectedProduct) {
        LightningUtilities.callApex(component, "getAssistanceAndSponsorOptions", {
            trade: selectedTrade,
            product: selectedProduct
        })
            .then((result) => {
                this.handleGetAssistanceValuesSuccess(component, result);
            })
            .catch((errors) => {
                this.handleGetAssistanceValuesError(component, errors);
            });
    },
    handleGetAssistanceValuesSuccess: function (component, result) {
        LightningUtilities.setState(component, "v.state", {
            "options.assistances": this.mapToOptions(result.assistanceOptions),
            "options.sponsors": this.mapToOptions(result.sponsorOptions),
            "componentControls.hasProductSelected": true,
            "componentControls.assistancePreloaded": "NO SELECTED" != result.assistanceDefaultValue.toUpperCase(),
            "componentControls.showWarningAlert": "NO SELECTED" == result.assistanceDefaultValue.toUpperCase(),
            assistanceSelected: result.assistanceDefaultValue,
            "componentControls.isLoading": false
        });
    },
    handleGetAssistanceValuesError: function (component, errors) {
        LightningUtilities.showToast(
            "¡Hubo un Error!",
            "sticky",
            "No se pudieron obtener las opciones de asistencias, por favor reintente.",
            "error",
            "close"
        );
        component.set("v.state.componentControls.isLoading", false);
    },
    continueToCreationPage: function (component) {
        const state = component.get("v.state");

        LightningUtilities.callApex(component, "prepareInfoToCreation", {
            request: {
                trade: state.tradeSelected,
                product: state.productSelected,
                sponsor: state.sponsorSelected,
                assistance: "NO SELECTED" != state.assistanceSelected.toUpperCase() ? state.assistanceSelected : "",
                useType: state.useTypeSelected
            }
        })
            .then((result) => this.handleContinueSuccess(component, state, result))
            .catch((error) => this.handleContinueError(component, error));
    },
    handleContinueSuccess: function (component, state, result) {
        LightningUtilities.fireEvent(component, "application", "e.force:createRecord", {
            entityApiName: "Enlatado__c",
            defaultFieldValues: {
                Identificador_de_Enlatado__c: result.cannedIdentifier,
                Codigo_Enlatado__c: result.cannedNumber,
                Id_Enlatado__c: result.cannedExternalId,
                Id_Identificador_Enlatado__c: result.cannedIdentifierExternalId,
                Asistencia__c: "NO SELECTED" != state.assistanceSelected.toUpperCase() ? state.assistanceSelected : "",
                Tipo_de_Uso__c: state.useTypeSelected,
                Tipo_de_Uso_Original__c: state.useTypeSelected
            }
        });
        component.set("v.state.componentControls.isLoading", false);
    },
    handleContinueError: function (component, error) {
        LightningUtilities.showToast(
            "¡Hubo un Error!",
            "sticky",
            "No se pudo continuar con la creación, por favor reintente.",
            "error",
            "close"
        );
        component.set("v.state.componentControls.isLoading", false);
    },
    handleCanContinue: function (component) {
        const state = component.get("v.state");

        const canContinue = [
            state.tradeSelected,
            state.productSelected,
            state.sponsorSelected,
            state.useTypeSelected
        ].every((element) => element && "NO SELECTED" != element.toUpperCase());

        const params = {
            "componentControls.isLoading": false
        };
        if (canContinue != state.componentControls.canContinue) {
            params["componentControls.canContinue"] = canContinue;
        }
        LightningUtilities.setState(component, "v.state", params);
    }
});