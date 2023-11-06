/**
 * @description       :
 * @author            : Victor M. Degano
 * @group             : Globant
 * @affected jiras    : EV-1686, EV-1778
 * @last modified on  : 03-07-2023
 * @last modified by  : Victor M. Degano
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   23-05-2023   Victor M. Degano   Initial Version
 * 1.0   23-05-2023   Victor M. Degano   Modificacion para precarga de asistencia por producto EV-1778
 **/
({
    initialize: function (component, event, helper) {
        LightningUtilities.executeWithSpinner(
            component,
            "v.state.componentControls.isLoading",
            () => {
                helper.getInitialValues(component);
            },
            true
        );
    },
    handleTradeSelectChange: function (component, event, helper) {
        LightningUtilities.executeWithSpinner(
            component,
            "v.state.componentControls.isLoading",
            () => {
                const selectedTrade = component.get("v.state.tradeSelected");

                if ("NO SELECTED" === selectedTrade.toUpperCase()) {
                    LightningUtilities.setState(component, "v.state", {
                        "componentControls.hasTradeSelected": false,
                        "componentControls.hasProductSelected": false,
                        "componentControls.assistancePreloaded": false,
                        "componentControls.showWarningAlert": false,
                        productSelected: "No Selected",
                        sponsorSelected: "No Selected",
                        assistanceSelected: "No Selected",
                        "componentControls.isLoading": false
                    });
                    return;
                }

                helper.getProductValues(component, selectedTrade);
            },
            true
        );
    },
    handleProductSelectChange: function (component, event, helper) {
        LightningUtilities.executeWithSpinner(
            component,
            "v.state.componentControls.isLoading",
            () => {
                const selectedProduct = component.get("v.state.productSelected");
                const selectedTrade = component.get("v.state.tradeSelected");

                if ("NO SELECTED" === selectedProduct.toUpperCase()) {
                    LightningUtilities.setState(component, "v.state", {
                        "componentControls.hasProductSelected": false,
                        "componentControls.assistancePreloaded": false,
                        "componentControls.showWarningAlert": false,
                        assistanceSelected: "No Selected",
                        sponsorSelected: "No Selected",
                        "componentControls.isLoading": false
                    });
                    return;
                }

                helper.getAssistanceValues(component, selectedTrade, selectedProduct);
            },
            true
        );
    },
    handleCanContinue: function (component, event, helper) {
        LightningUtilities.executeWithSpinner(
            component,
            "v.state.componentControls.isLoading",
            () => helper.handleCanContinue(component),
            true
        );
    },
    handleContinue: function (component, event, helper) {
        LightningUtilities.executeWithSpinner(
            component,
            "v.state.componentControls.isLoading",
            () => helper.continueToCreationPage(component),
            true
        );
    },
    handleClose: function (component, event, helper) {
        const workspaceAPI = component.find("workspaceAPI");

        workspaceAPI
            .getFocusedTabInfo()
            .then(function (response) {
                const focusedTabId = response.tabId;
                workspaceAPI.closeTab({ tabId: focusedTabId });
            })
            .catch(function (error) {
                LightningUtilities.showToast(
                    "¡No se pudo cerrar!",
                    "sticky",
                    "No se pudo cerrar la pestaña, por favor cierre desde la pestaña.",
                    "error",
                    "close"
                );
            });
    }
});