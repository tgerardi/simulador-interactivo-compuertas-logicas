/**
 * @description       :
 * @author            : Victor M. Degano
 * @group             : Globant
 * @affected jiras    : VD-878, EV-2041
 * @last modified on  : 12-13-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   15-05-2023   Victor M. Degano   Initial Version
 * 1.0   03-10-2023   Victor M. Degano   Se agrego la asignacion de sumas para retencion de Movilidad
 **/
({
    //Metodo que revisa si el producto esta habilitado para poder enviar un email de preventa.
    checkDisplayPresaleEmail: function (component, profileName, ramoCode, productCode) {
        let isHogar = ramoCode === "2" && (productCode === "212" || productCode === "213" || productCode === "214");

        let isVida = ramoCode === "19" && productCode === "312";

        let isAp = ramoCode === "18" && productCode === "211";

        let isNewSalud = ramoCode === "20" && productCode === "007";

        let isBienesMoviles = ramoCode === "9" && productCode === "253";

        if (profileName !== "Comunidad Nominal HP PL" && (isHogar || isVida || isAp || isBienesMoviles || isNewSalud)) {
            component.set("v.needPresaleEmail", true);
        }
    },
    checkDisplayChecklist: function (component, ramoCode, productCode) {
        let isVida = ramoCode === "19" && productCode === "312";

        if (isVida) {
            component.set("v.showChecklist", true);
        }
    },
    //Metodo que revisa si el producto esta habilitado para poder enviar un email de preventa.
    checkDisplaySumSection: function (component, ramoCode) {
        if (ramoCode != "18") {
            component.set("v.showSumSection", true);
        }
    },
    checkDisplayCuponSection: function (component, ramoCode, productCode, sponsor) {
        if (ramoCode === "2" && productCode === "212" && (sponsor === "MA" || sponsor === "509")) {
            component.set("v.showCuponSection", true);
        }
    },
    //Deprecado por JIRA EV-1424(13/01/2023): Borrar al pasar los 2/3 meses
    // checkDisplayTelemedicinaButton: function (component, accountId){
    //     var action = component.get("c.validateContractedTelemedicinaService");

    //     action.setParams({
    //         accountId : accountId
    //     });

    //     // var action = component.get("v.policy");

    //     action.setCallback(this, function (response) {
    //         var state = response.getState();
    //         if (state === "SUCCESS") {

    //             let result = response.getReturnValue();

    //             if(result.length === 0){
    //                 this.showTelemedicinaButton(component);
    //             }
    //         } else {
    //             //Metodo que muestra un mensaje de error y evita la utilizacion del cotizador
    //             this.displayError(component, "No fue posible validar los servicios contratados de la cuenta.");
    //         }
    //     });

    //     $A.enqueueAction(action);
    // },
    //Metodo que busca la oferta de la poliza.
    searchPolicyCoverages: function (component, profileName, execution, policy) {
        var action = component.get("c.getInitialWrappers");

        action.setParams({
            aPolicy: policy
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var coverages = response.getReturnValue();

                if (coverages && coverages.length > 0) {
                    //Metodo que setea las coberturas.
                    this.setCoverages(component, coverages);

                    //Metodo que calculatoria la sumatoria de coberturas.
                    this.calcCoveragesSum(component, coverages);

                    var getCoveragesCode =
                        policy.Ramo_IdBHSeg__c === "9" ||
                        policy.Ramo_IdBHSeg__c === "09" ||
                        policy.Ramo_IdBHSeg__c === "19";

                    var params = {
                        profile: profileName,
                        sponsorCode: policy.Productor_IdBHSeg__c,
                        ramoCode: policy.Ramo_IdBHSeg__c,
                        productCode: policy.Producto_IdBHSeg__c,
                        useType: execution,
                        coveragesCodes: getCoveragesCode ? this.getCoveragesCodes(component, coverages, policy) : "", //Metodo que retorna los codigos de cobertura de la poliza para la busqueda de enlatados.
                        prize: policy.Premio__c
                    };

                    //Metodo que busca los enlatados.
                    this.searchEnlatados(component, params);
                } else {
                    //Metodo que muestra un mensaje de error y evita la utilizacion del cotizador
                    this.displayError(component, "No fue posible sincronizar las coberturas de la póliza.");
                }
            } else {
                //Metodo que muestra un mensaje de error y evita la utilizacion del cotizador
                this.displayError(component, "No fue posible sincronizar las coberturas de la póliza.");
            }
        });

        $A.enqueueAction(action);
    },
    //Metodo que busca los enlatados precargados.
    searchEnlatados: function (component, params) {
        var action = component.get("c.searchEnlatados");

        action.setParams({
            profile: params.profileName ? params.profileName : "",
            sponsor: params.sponsor ? params.sponsor : "",
            sponsorCode: params.sponsorCode ? params.sponsorCode : "",
            ramoCode: params.ramoCode ? params.ramoCode : "",
            productCode: params.productCode ? params.productCode : "",
            age: params.age ? params.age : 0,
            tipoDeUso: params.useType ? params.useType : "",
            coveragesCodes: params.coveragesCodes ? params.coveragesCodes : ""
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var enlatados = response.getReturnValue();

                if (enlatados !== null && enlatados !== undefined && Object.values(enlatados).length > 0) {
                    if (JSON.parse(Object.values(enlatados)[0]).ambientes !== "0") {
                        //Metodo que setea las picklist de ambientes.
                        this.setAmbientes(component, Object.values(enlatados));

                        if (params.data && params.data.ambientes !== "" && params.data.combo !== "") {
                            //Metodo que setea el ambiente seleccionado.
                            this.setAmbiente(component, params.data.ambientes);

                            //Metodo que setea las picklist de combos.
                            this.setCombos(component, params.data.ambientes, Object.values(enlatados));

                            //Metodo que setea el combo seleccionado.
                            this.setCombo(component, params.data.combo);

                            //Metodo que habilita la picklist de combos.
                            this.availableCombos(component);
                        }

                        component.set("v.needAmbientes", true);
                    } else {
                        var canneds = Object.keys(enlatados);

                        if (params.useType === "Retencion") {
                            //Metodo que carga una opcion enlatada actual.
                            canneds = this.loadCannedActualOption(component, Object.keys(enlatados), params.prize);
                        }

                        component.set("v.enlatados", canneds);

                        if (params.data && params.data.description !== "") {
                            //Metodo que setea el enlatado.
                            this.setEnlatado(component, params.data.description);
                        }
                    }

                    component.set("v.enlatadosObjects", enlatados);
                } else {
                    if (params.useType === "Retencion") {
                        //Metodo que muestra un mensaje de error y evita la utilizacion del cotizador
                        this.displayError(component, "No se encontraron enlatados para el producto.");
                    } else {
                        //Metodo que lanza un toast.
                        this.showToast("Error!", "No se encontraron enlatados para el producto.", "Error");
                    }
                }
            } else {
                if (params.useType === "Retencion") {
                    //Metodo que muestra un mensaje de error y evita la utilizacion del cotizador
                    this.displayError(component, "No se encontraron enlatados para el producto.");
                } else {
                    //Metodo que lanza un toast.
                    this.showToast("Error!", "No se encontraron enlatados para el producto.", "Error");
                }
            }
        });

        $A.enqueueAction(action);
    },
    //Metodo que carga una opcion enlatada actual.
    loadCannedActualOption: function (component, canneds, prize) {
        var result = [];

        var premio = "";

        result.push("$" + Math.floor(prize) + " | Poliza Actual");

        for (let canned of canneds) {
            premio = canned.split(" | ")[0].substring(1, canned.split(" | ")[0].length);
            if (parseInt(premio) <= parseInt(prize) - 1 || parseInt(premio) >= parseInt(prize) + 1) {
                result.push(canned);
            }
        }

        return result;
    },
    //Metodo que setea las picklist de ambientes.
    setAmbientes: function (component, cannedValues) {
        var ambientes = [];
        for (let cannedValue of cannedValues) {
            if (!ambientes.includes(JSON.parse(cannedValue).ambientes)) {
                ambientes.push(JSON.parse(cannedValue).ambientes);
            }
        }
        component.set("v.ambientes", ambientes.sort());
    },
    //Metodo que setea las picklist de combos.
    setCombos: function (component, ambiente, cannedValues) {
        var combos = [];
        for (let cannedValue of cannedValues) {
            if (JSON.parse(cannedValue).ambientes == ambiente) {
                combos.push(JSON.parse(cannedValue).combo);
            }
        }
        component.set("v.combos", combos.sort());
    },
    //Metodo que setea el ambiente seleccionado.
    setAmbiente: function (component, ambiente) {
        component.set("v.ambiente", ambiente);
    },
    //Metodo que setea el combo seleccionado.
    setCombo: function (component, combo) {
        component.set("v.combo", combo);
    },
    // Metodo que revisa si el ID proviniente en el Lead corresponde con alguno de los Enlatados del producto.
    checkEnlatadoId: function (component, cannedId, canneds) {
        for (var key in canneds) {
            if (JSON.parse(canneds[key]).id === cannedId) {
                return true;
            }
        }
        return false;
    },
    //Metodo que retorna los codigos de cobertura de la poliza para la busqueda de enlatados.
    getCoveragesCodes: function (component, coverages, policy) {
        var coveragesCodes = "";

        for (let coverage of coverages) {
            switch (policy.Ramo_IdBHSeg__c) {
                case "9":
                case "09":
                    if (
                        policy.Producto_IdBHSeg__c !== "201" &&
                        policy.Producto_IdBHSeg__c !== "202" &&
                        this.coberturaContratada(coverage)
                    ) {
                        coveragesCodes += coverage.codigoCobertura + ",";
                    }

                    break;
                case "19":
                    if (coverage.codigoCobertura === "005" && this.coberturaContratada(coverage)) {
                        coveragesCodes = "005";
                    }

                    break;
                default:
                    break;
            }
        }

        //remove last ',' from coverages
        if (coveragesCodes.charAt(coveragesCodes.length - 1) === ",") {
            coveragesCodes = coveragesCodes.slice(0, -1);
        }

        return coveragesCodes;
    },
    //Metodo que obtiene la descripcion del enlatado en base al ambiente y combo seleccionado.
    getEnlatadoDescription: function (component, ambiente, combo, enlatadosObjects) {
        for (var key in enlatadosObjects) {
            if (
                JSON.parse(enlatadosObjects[key]).ambientes === ambiente &&
                JSON.parse(enlatadosObjects[key]).combo === combo
            ) {
                return key;
            }
        }
        return "";
    },
    //Metodo que setea las coberturas y  el premio en base al enlatado seleccionado.
    searchCoveragesByEnlatado: function (component, params, methodName) {
        var action = component.get("c." + methodName + "");

        action.setParams(params);

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var coverages = response.getReturnValue();

                if (coverages && coverages.length > 0) {
                    //Metodo que setea las coberturas.
                    this.setCoverages(component, coverages);

                    //Metodo que setea los addons que podran ser agregados.
                    this.setAddons(component, coverages);

                    //Metodo que calculatoria la sumatoria de coberturas.
                    this.calcCoveragesSum(component, coverages);

                    this.updateInsurabilityQuestions(component, coverages, params);
                } else {
                    //Metodo que setea las coberturas.
                    this.setCoverages(component, []);

                    //Metodo que lanza un toast.
                    this.showToast("Error!", "No se encontraron coberturas para el enlatado seleccionado.", "Error");
                }
            } else {
                //Metodo que lanza un toast.
                this.showToast("Error!", "No se encontraron coberturas para el enlatado seleccionado.", "Error");
            }
        });

        $A.enqueueAction(action);
    },

    updateInsurabilityQuestions: function (component, coverages, params) {
        if (
            (params.ramoCode === "19" && params.productCode === "312") ||
            (params.ramoCode === "20" && params.productCode === "007")
        ) {
            //generar la lista con los codigos de cobertura
            let coveragesCodes = [];
            //preguntar aca
            coverages.forEach((element) => {
                if (
                    element.cotizacionActual > 0 ||
                    (element.isAddon && element.addonSelected && element.addonSelected.monto > 0)
                ) {
                    coveragesCodes.push(element.codigoCobertura);
                }
            });
            //Metodo que lanza el evento UpdateInsurabilityQuestionsEvent.
            this.fireUpdateInsurabilityQuestionsEvent(
                component,
                component.get("v.age"),
                component.get("v.genero"),
                coverages[0].cotizacionAjustada,
                coveragesCodes
            );
        }
    },

    //Metodo que valida lo ingresado/seleccionado en el componente.
    validateComponent: function (component, componentsList) {
        return componentsList.reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get("v.validity").valueMissing && inputCmp.get("v.value") !== "";
        }, true);
    },
    //Metodo que revisa si es necesario agregar un Add-On dependiente.
    checkAddonDependecies: function (component, codigoCobertura, codigoAddonOption, coverages, addonsWithDependency) {
        for (let addonWithDependency of addonsWithDependency) {
            var coberturaPadre = addonWithDependency.coberturaPadre.split("-");
            if (coberturaPadre[2] === codigoCobertura && coberturaPadre[3] === codigoAddonOption) {
                for (let coverage of coverages) {
                    var idOpcion = addonWithDependency.idOpcion.split("-");
                    if (coverage.codigoCobertura === idOpcion[2]) {
                        coverage.addonSelected = addonWithDependency;
                        coverage.addonSelectedFijo = true;
                    }
                }
            }
        }
        return coverages;
    },
    //Metodo que agrega un Add-On a la lista.
    addAddon: function (component, addon, addonOption, addonOptions, coverages) {
        var codigoAddonSelected = "";

        var codigoAddonOptionSelected = "";

        var premioAddonMensual = 0;

        var premioAddonDiario = 0;

        for (let coverage of coverages) {
            if (coverage.descripcionCorta === addon) {
                for (let option of addonOptions) {
                    if (option.nombre === addonOption) {
                        //Assign Add-On selected.
                        coverage.addonSelected = option;

                        //Save other values of the Add-On selected.
                        codigoAddonSelected = coverage.codigoCobertura;
                        codigoAddonOptionSelected = option.idOpcion.split("-")[3];
                        premioAddonMensual = Math.ceil(option.premioMensual);
                        premioAddonDiario = Math.ceil(option.premioDiario);

                        break;
                    }
                }

                /*if(coverage.codigoCobertura === '033'){
                    //Metodo que oculta el alert para el agregado del Add-On TRE.
                    this.hideTREAlert(component);
                }*/

                break;
            }
        }

        return {
            coverages: coverages,
            codigoAddonSelected: codigoAddonSelected,
            codigoAddonOptionSelected: codigoAddonOptionSelected,
            premioAddonMensual: premioAddonMensual,
            premioAddonDiario: premioAddonDiario
        };
    },
    //Metodo que agregar HP al ProductWrapper.
    addEnlatadoToNewProduct: function (
        component,
        cannedCode,
        enlatado,
        ambiente,
        combo,
        asistance,
        coverages,
        /*existingPolicy,*/ premioBase,
        cupon
    ) {
        var params = {
            cannedCode: cannedCode,
            enlatadoDescription: enlatado,
            enlatadoAmbiente: ambiente,
            enlatadoCombo: combo,
            asistencia: asistance,
            coberturas: coverages,
            /** 
             * !Deprecated VD-18
            existingPolicy: existingPolicy,
            **/
            basePrize: premioBase,
            cupon: cupon
        };

        //Metodo que lanza el evento CotizadorEnlatadoDataEvent.
        this.fireCotizadorEnlatadoDataEvent(component, params);
    },
    //Metodo que actualiza las coberturas.
    updateCoverages: function (component, coverages) {
        //Metodo que resetea las coberturas.
        this.resetCoverages(component);

        //Metodo que setea las coberturas.
        this.setCoverages(component, coverages);

        //Metodo que calculatoria la sumatoria de coberturas.
        this.calcCoveragesSum(component, coverages);
    },
    //Delete Add-On from the picklist.
    deleteAddonFromPicklist: function (component, addon, addons) {
        addons.splice(addons.indexOf(addon), 1);
        component.set("v.addon", "");
        component.set("v.addons", addons);
    },
    //Metodo que calculatoria la sumatoria de coberturas.
    calcCoveragesSum: function (component, coverages) {
        let sum = 0;

        for (let coverage of coverages) {
            if (coverage.isAddon) {
                sum += parseFloat(coverage.addonSelected.monto);
            } else {
                //TODO: Revisar porque no genera completo el wrapper de la coberturas no encontradas.
                if (coverage.cotizacionAjustada) {
                    sum += parseFloat(coverage.cotizacionAjustada);
                }
            }
        }

        component.set("v.sum", sum != 0 ? sum : "");
    },
    //Calcular los premios con Add-Ons.
    calcularPremiosWithAddons: function (component, premioMensual, ramoCode, productCode, coverages) {
        if (ramoCode && ["2", "02", "19"].includes(ramoCode)) {
            var action = component.get("c.calcularPremiosWithAddons");

            action.setParams({
                coverages: coverages,
                ramoCode: ramoCode,
                productCode: productCode
            });

            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    this.handleEditedPrizeChange(component, premioMensual, response.getReturnValue());
                    // var premio = response.getReturnValue();

                    // if (Math.ceil(premio) === parseInt(premioMensual)) {
                    //     //Metodo que resetea los premios con Add-Ons.
                    //     this.resetPremiosEditados(component);

                    //     //Metodo que oculta la seccion de premios editados.
                    //     this.hideEditedPrize(component);
                    // } else {
                    //     //Metodo que setea los premios en base a la cotizacion realizada.
                    //     this.setPremiosEditados(component, Math.ceil(premio));

                    //     //Metodo que muestra la seccion de premios editados.
                    //     this.showEditedPrize(component);
                    // }
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                } else {
                    console.log("Something went wrong, Please check with your admin");
                }
            });

            $A.enqueueAction(action);
        } else {
            const premioMensualMasAddons = coverages.reduce((accumulator, element) => {
                return element.isAddon && element.addonSelected.premioMensual > 0
                    ? accumulator + element.addonSelected.premioMensual
                    : accumulator;
            }, premioMensual);

            this.handleEditedPrizeChange(component, premioMensual, premioMensualMasAddons);
        }
    },
    handleEditedPrizeChange: function (component, premioMensual, premioMensualMasAddons) {
        const nuevoPremio = Math.ceil(premioMensualMasAddons);
        if (nuevoPremio === parseInt(premioMensual)) {
            //Metodo que resetea los premios con Add-Ons.
            this.resetPremiosEditados(component);

            //Metodo que oculta la seccion de premios editados.
            this.hideEditedPrize(component);
        } else {
            //Metodo que setea los premios en base a la cotizacion realizada.
            this.setPremiosEditados(component, nuevoPremio);

            //Metodo que muestra la seccion de premios editados.
            this.showEditedPrize(component);
        }
    },
    checkSellosCalcs: function (component, params) {
        let age = params.age ? params.age : component.get("v.age");

        let gender = params.gender ? params.gender : component.get("v.genero");

        let enlatado = params.enlatado ? params.enlatado : component.get("v.enlatado");

        let provinceCode = params.provinceCode ? params.provinceCode : component.get("v.provinceCode");

        let coverages = params.coverages ? params.coverages : component.get("v.coverages");

        let completeTaxesChecklist =
            gender !== "" &&
            gender !== null &&
            gender !== undefined &&
            age !== "" &&
            age !== null &&
            age !== undefined &&
            enlatado !== "" &&
            enlatado !== null &&
            enlatado !== undefined &&
            provinceCode !== "" &&
            provinceCode !== null &&
            provinceCode !== undefined &&
            coverages.length > 0;

        if (completeTaxesChecklist) {
            let calcParams = {
                ramoCode: params.ramoCode,
                productCode: params.productCode,
                age: age,
                gender: gender,
                provinceCode: provinceCode,
                coverages: coverages,
                execution: params.execution
            };

            //Metodo que calcula las coberturas en base a los datos ingresados.
            this.calcularSellos(component, calcParams);
        }
    },
    //Metodo que calcula el premio en base a los datos ingresados.
    calcularSellos: function (component, params) {
        var action = component.get("c.calcularSellos");

        action.setParams({
            request: {
                coberturas: params.coverages,
                ramo_idbhseg: params.ramoCode,
                producto_idbhseg: params.productCode,
                productor_idbhseg: "",
                edad: params.age,
                sexo: params.gender,
                codigoProvincia: params.provinceCode,
                useType: params.execution
            }
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();

                this.setPremios(component, parseFloat(result.premioMensualSinSellos));

                component.set("v.sellos", parseFloat(result.sellos));
                component.set("v.primerCuota", parseFloat(result.primeraCuotaMasSellos));
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            } else {
                console.log("Something went wrong, Please check with your admin");
            }
        });

        $A.enqueueAction(action);
    },
    //Metodo que agrega a la picklist de Add-Ons el eliminado.
    restoreAddonDeletedToPicklist: function (component, addon, addons, coverages) {
        for (let coverage of coverages) {
            if (coverage.codigoCobertura === addon) {
                addons.push(coverage.descripcionCorta);

                /*if(coverage.codigoCobertura === '033'){
                    //Metodo que muestra el alert para el agregado del Add-On TRE.
                    this.showTREAlert(component);
                }*/

                break;
            }
        }
        component.set("v.addons", addons.sort());
    },
    //Metodo que muestra la asistencia del enlatado seleccionado.
    showAsistencia: function (component, asistencia) {
        component.set("v.asistance", asistencia);
        component.set("v.needAsistance", true);
    },
    //Metodo que oculta la asistencia.
    hideAsistencia: function (component) {
        //component.set("v.subtitleSize", 12);
        component.set("v.asistance", "");
        component.set("v.needAsistance", false);
    },
    //Metodo que muestra la seccion de premios editados.
    showEditedPrize: function (component) {
        component.set("v.showEditedPrize", true);
    },
    //Metodo que muestra el boton de ciberseguridad.
    showCiberseguridadButton: function (component) {
        component.set("v.showCibersecurityButton", true);
    },
    //Metodo que muestra el boton de telemedicina.
    showTelemedicinaButton: function (component) {
        component.set("v.showTelemedicinaButton", true);
    },
    //Metodo que oculta la seccion de premios editados.
    hideEditedPrize: function (component) {
        component.set("v.showEditedPrize", false);
    },
    //Metodo que setea los datos de la poliza en los atributos del componente.
    setPolicyData: function (component, policy) {
        component.set("v.product", policy.Ramo__c + "|" + policy.Ramo_IdBHSeg__c);
        component.set("v.productCode", policy.Producto_IdBHSeg__c);
        component.set("v.sponsorCode", policy.Productor_IdBHSeg__c);
    },
    //Metodo que setea el enlatado.
    setEnlatado: function (component, enlatado) {
        component.set("v.enlatado", enlatado);
    },
    //Metodo que setea las coberturas.
    setCoverages: function (component, coverages) {
        component.set("v.coverages", coverages);
        //console.log("@@@@@1" + JSON.stringify(coverages));

        //Metodo que lanza el evento ValidateClientEmailEvent.
        //console.log("@@@v2");
        this.fireSendCoveragesWhenItChange(component, coverages);
    },

    //Metodo que lanza el evento sendCoveragesWhenItChange
    fireSendCoveragesWhenItChange: function (component, params) {
        //console.log("@@@v3");
        var appEvent = $A.get("e.c:sendCoveragesWhenItChange");
        appEvent.setParams({
            coverturas: params
        });
        //console.log("@@@v4");
        appEvent.fire();
    },

    //Metodo que setea las coberturas iniciales.
    setInitCoverages: function (component, coverages) {
        component.set("v.initCoverages", coverages);
        //console.log("@@@@@2" + JSON.stringify(coverages));
    },
    //Metodo que setea los addons que podran ser agregados.
    setAddons: function (component, coverages) {
        var addons = [];
        var addonsWithDependency = [];
        for (let coverage of coverages) {
            if (coverage.isAddon && coverage.addonOptions.length !== 0) {
                if (coverage.addonOptions[0].coberturaPadre === "") {
                    if (coverage.addonSelected.nombre === "Seleccionar") {
                        addons.push(coverage.descripcionCorta);
                        /*if(coverage.codigoCobertura === '033'){
                            //Metodo que muestra el alert para el agregado del Add-On TRE.
                            this.showTREAlert(component);
                        }*/
                    }
                } else {
                    addonsWithDependency = addonsWithDependency.concat(coverage.addonOptions);
                }
            }
        }
        component.set("v.addons", addons.sort());
        component.set("v.addonsWithDependency", addonsWithDependency);
    },
    //Metodo que setea las opciones en base al addon seleccionado.
    setAddonOptions: function (component, addon, coverages) {
        for (let coverage of coverages) {
            if (coverage.descripcionCorta === addon) {
                var options = JSON.parse(JSON.stringify(coverage.addonOptions));
                component.set("v.addonOptions", options.sort());
                component.set("v.disabledAddonOptions", false);
                break;
            }
        }
    },
    //Metodo que setea los premios en base a las coberturas.
    setPremios: function (component, premio) {
        component.set("v.premioMensual", premio);

        //Metodo que setea el premio diario.
        this.setPremioDiario(component, premio);
    },
    //Metodo que setea el premio diario.
    setPremioDiario: function (component, premio) {
        var premioDiario = premio / 30;

        component.set("v.premioDiario", premioDiario);

        return premioDiario;
    },
    //Metodo que setea los premios en base a la cotizacion realizada.
    setPremiosEditados: function (component, premio) {
        component.set("v.premioCotizadoMensual", premio);
        component.set("v.premioCotizadoDiario", premio / 30);
    },
    //Metodo que setea el premio con Add-Ons al ProductWrapper.
    setPremioWithEnlatadoToNewProduct: function (component, premio) {
        component.set("v.premioMensual", premio);
    },
    //Metodo que setea el codigo del enlatado seleccionado.
    setCannedCode: function (component, cannedCode) {
        component.set("v.selectedCannedCode", cannedCode);
    },
    //Metodo que setea el mensaje a renderizarse en el modal de confirmación.
    setConfirmationModalMessage: function (component, buttonPressed) {
        switch (buttonPressed) {
            case "Modifica":
                component.set("v.confirmationModalMessage", "¿Está seguro que desea MODIFICAR las sumas aseguradas?");

                break;
            case "CambioSA":
                component.set("v.confirmationModalMessage", "¿Está seguro que desea CAMBIAR las sumas aseguradas?");

                break;
            case "Mantiene":
                component.set("v.confirmationModalMessage", "¿Está seguro que desea MANTENER las sumas aseguradas?");

                break;
            case "Baja":
                component.set(
                    "v.confirmationModalMessage",
                    "¿Está seguro que desea ser redireccionado para realizar la baja de la póliza?"
                );

                break;

            case "Ciberseguridad":
                component.set(
                    "v.confirmationModalMessage",
                    "¿Está seguro que desea MANTENER las sumas aseguradas agregando el servicio de Ciberseguridad?"
                );

                break;
            case "Telemedicina":
                let difPorcentual = component.get("v.difPorcentual");

                component.set(
                    "v.confirmationModalMessage",
                    "¿Está seguro que desea " +
                        (difPorcentual === 0 ? "MANTENER" : "MODIFICAR") +
                        " las sumas aseguradas agregando el servicio de Telemedicina?"
                );

                break;
            default:
                break;
        }
    },
    //Metodo que habilita la picklist de combos.
    availableCombos: function (component) {
        component.set("v.disabledCombos", false);
    },
    //Metodo que habilita el boton de agregar un Add-On.
    availableAddButton: function (component) {
        component.set("v.disabledAgregarAddon", false);
    },
    //Metodo que habilita el boton para mantener la cobertura del cliente.
    availableMantieneButton: function (component) {
        component.set("v.disabledMantieneButton", false);
    },
    //Metodo que habilita los botones para modificar la cobertura del cliente.
    availableModificaButtons: function (component) {
        component.set("v.disabledModificaButtons", false);
    },
    //Metodo que deshabilita la picklist de combos.
    disabledCombos: function (component) {
        component.set("v.disabledCombos", true);
    },
    //Metodo que deshabilita la picklist de las opciones por Add-On.
    disabledAddonOptions: function (component) {
        component.set("v.disabledAddonOptions", true);
    },
    //Metodo que deshabilita el boton de agregar un Add-On.
    disabledAddButton: function (component) {
        component.set("v.disabledAgregarAddon", true);
    },
    //Metodo que deshabilita el boton para mantener la cobertura del cliente.
    disabledMantieneButton: function (component) {
        component.set("v.disabledMantieneButton", true);
    },
    //Metodo que deshabilita los botones para modificar la cobertura del cliente.
    disabledModificaButtons: function (component) {
        component.set("v.disabledModificaButtons", true);
    },
    //Metodo que lanza el evento ValidityChildComponentEvent.
    fireValidityChildComponentEvent: function (component, isUsed, isValid) {
        var compEvents = component.getEvent("ValidityChildComponentEvent");
        compEvents.setParams({
            componentName: "cotizadorEnlatado",
            isUsed: isUsed,
            isValid: isValid
        });
        compEvents.fire();
    },
    //Metodo que lanza el evento CotizadorEnlatadoDataEvent.
    fireCotizadorEnlatadoDataEvent: function (component, params) {
        var compEvents = component.getEvent("CotizadorEnlatadoDataEvent");
        compEvents.setParams({
            cannedCode: params.cannedCode ? params.cannedCode : "",
            cannedDescription: params.enlatadoDescription ? params.enlatadoDescription : "",
            cannedRooms: params.enlatadoAmbiente ? params.enlatadoAmbiente : "",
            cannedCombo: params.enlatadoCombo ? params.enlatadoCombo : "",
            asistance: params.asistencia ? params.asistencia : "",
            coverages: params.coberturas ? params.coberturas : [],
            existingPolicy: params.existingPolicy ? params.existingPolicy : "", //!Deprecated VD-18
            basePrize: params.basePrize ? params.basePrize : "",
            cupon: params.cupon ? params.cupon : "",
            componentName: "cotizadorEnlatado"
        });
        compEvents.fire();
    },
    //Metodo que resetea la sumatoria de coberturas.
    resetCoveragesSum: function (component) {
        component.set("v.sum", "");
    },
    //Metodo que resetea las coberturas.
    resetCoverages: function (component) {
        component.set("v.coverages", []);
    },
    //Metodo que resetea los premios base.
    resetPremios: function (component) {
        component.set("v.premioMensual", "");
        component.set("v.premioDiario", "");
    },
    //Metodo que resetea los premios con Add-Ons.
    resetPremiosEditados: function (component) {
        component.set("v.premioCotizadoMensual", "");
        component.set("v.premioCotizadoDiario", "");
    },
    //Metodo que resetea el codigo del enlatado seleccionado.
    resetCannedCode: function (component) {
        component.set("v.selectedCannedCode", "");
    },
    //Metodo que resetea los ambientes de la picklist.
    resetAmbientes: function (component) {
        component.set("v.ambiente", "");
        component.set("v.ambientes", []);
    },
    //Metodo que resetea los combos de la piclklist.
    resetCombos: function (component) {
        component.set("v.combo", "");
        component.set("v.combos", []);
    },
    //Metodo que resetea los Add-Ons de la piclklist.
    resetAddons: function (component) {
        component.set("v.addon", "");
        component.set("v.addons", []);
    },
    //Metodo que resetea las opciones de Add-Ons de la picklist.
    resetAddonsOptions: function (component) {
        component.set("v.addonOption", "");
        component.set("v.addonOptions", []);
    },
    //Metodo que resetea la forma de mostrar los combos a seleccionar.
    resetNeedAmbientes: function (component) {
        component.set("v.needAmbientes", false);
    },
    //Metodo que resetea la forma de mostrar los combos a seleccionar.
    resetTaxes: function (component) {
        component.set("v.sellos", 0);
    },
    //Metodo que resetea la forma de mostrar los combos a seleccionar.
    resetFirstFee: function (component) {
        component.set("v.primerCuota", 0);
    },
    //Metodo que resetea el cotizador completo.
    resetCotizador: function (component) {
        //Metodo que resetea los premios base.
        this.resetPremios(component);

        //Metodo que resetea los premios con Add-Ons.
        this.resetPremiosEditados(component);

        //Metodo que resetea la forma de mostrar los combos a seleccionar.
        this.resetNeedAmbientes(component);

        //Metodo que resetea los ambientes de la picklist.
        this.resetAmbientes(component);

        //Metodo que resetea los combos de la piclklist.
        this.resetCombos(component);

        //Metodo que deshabilita la picklist de combos.
        this.disabledCombos(component);

        //Metodo que resetea los Add-Ons de la piclklist.
        this.resetAddons(component);

        //Metodo que resetea las opciones de Add-Ons de la picklist.
        this.resetAddonsOptions(component);

        //Metodo que deshabilita la picklist de las opciones por Add-On.
        this.disabledAddonOptions(component);

        //Metodo que deshabilita el boton de agregar un Add-On.
        this.disabledAddButton(component);

        //Metodo que resetea las coberturas.
        this.resetCoverages(component);

        //Metodo que resetea la sumatoria de coberturas.
        this.resetCoveragesSum(component);

        component.set("v.enlatadosObjects", []);

        component.set("v.enlatado", "");

        component.set("v.ambiente", "");

        component.set("v.combo", "");
    },
    //Calcula la diferencia entre el premio actual del cliente y el premio de la cotizacion realizada.
    calcularDiferenciaPremios: function (component, premioMensualActual, premioMensualCotizacion) {
        var difMonto = premioMensualCotizacion - premioMensualActual;
        var difPorcentual = Math.round((difMonto * 100) / premioMensualActual);

        if (difMonto < 0) {
            difMonto = difMonto * -1;
        }

        if (difPorcentual === 0) {
            //Metodo que habilita el boton para mantener la cobertura del cliente.
            this.availableMantieneButton(component);

            //Metodo que deshabilita los botones para modificar la cobertura del cliente.
            this.disabledModificaButtons(component);

            this.disableCiberseguridad(component, false);

            //this.disableTelemedicina(component, false);
        } else {
            //Metodo que deshabilita el boton para mantener la cobertura del cliente.
            this.disabledMantieneButton(component);

            //Metodo que habilita los botones para modificar la cobertura del cliente.
            this.availableModificaButtons(component);

            this.disableCiberseguridad(component, true);

            //this.disableTelemedicina(component, true);
        }

        component.set("v.difPorcentual", difPorcentual);
        component.set("v.difMonto", difMonto);
    },
    //Asigna los valores necesarios para seguir con el flujo cuando se quiere mantener las sumas aseguradas.
    mantiene: function (component, ramoCode, coverages, buttonPressed) {
        //Asignacion Coberturas.
        this.asignarCoberturas(component, ramoCode, coverages, buttonPressed);

        //Asignacion Tipo de Cotizacion.
        component.set("v.tipoCotizacion", "Mantiene");

        //Metodo que ejecuta una accion determinada para realizar en el flujo.
        this.flowAction(component);
    },
    //Asigna los valores necesarios para seguir con el flujo cuando se quiere modificar las sumas aseguradas.
    modifica: function (component, ramoCode, coverages, buttonPressed) {
        //Asignacion Coberturas.
        this.asignarCoberturas(component, ramoCode, coverages, buttonPressed);

        //Asignacion Tipo de Cotizacion.
        component.set("v.tipoCotizacion", "Cotizacion Enlatada");

        //Metodo que ejecuta una accion determinada para realizar en el flujo.
        this.flowAction(component);
    },
    //Metodo que ejecuta una accion determinada para realizar en el flujo.
    flowAction: function (component) {
        var navigate = component.get("v.navigateFlow");
        navigate("NEXT");
    },
    //Asignacion Coberturas.
    asignarCoberturas: function (component, ramoCode, coverages, buttonPressed) {
        coverages.forEach((element) => {
            switch (ramoCode) {
                case ("09", "9"): {
                    //Asignacion Coberturas ATM / BM / MOVILIDAD.
                    this.asignarCoberturaATM(component, element, buttonPressed);
                    this.asignarCoberturaBienesMoviles(component, element, buttonPressed);
                    this.asignarCoberturasMovilidad(component, element, buttonPressed);
                    break;
                }
                case "17": {
                    //Asignacion Coberturas Compra Protegida.
                    this.asignarCoberturaCompraProtegida(component, element, buttonPressed);
                    break;
                }
                case "18": {
                    //Asignacion Coberturas Accidentes Personales.
                    this.asignarCoberturaAccidentesPersonales(component, element, buttonPressed);
                    break;
                }
                case "19": {
                    //Asignacion Coberturas Vida/Salud.
                    this.asignarCoberturaVidaSalud(component, element, buttonPressed);
                    break;
                }
                case "20": {
                    //Asignacion Coberturas Salud Integral.
                    this.asignarCoberturaSaludIntegral(component, element, buttonPressed);
                    break;
                }
            }
        });
    },
    //Asignacion Coberturas ATM.
    asignarCoberturaATM: function (component, coverage, buttonPressed) {
        switch (coverage.codigoCobertura) {
            case "001": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual01", coverage.cotizacionActual);
                    component.set("v.sumaCotizada01", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual01", coverage.cotizacionActual);
                    component.set("v.sumaCotizada01", coverage.cotizacionAjustada);
                }
                break; // Robo en cajero 1 (Cobertura 001)
            }
            case "002": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual02", coverage.cotizacionActual);
                    component.set("v.sumaCotizada02", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual02", coverage.cotizacionActual);
                    component.set("v.sumaCotizada02", coverage.cotizacionAjustada);
                }
                break; // Robo en cajero 2 (Cobertura 002)
            }
            case "003": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual05", coverage.cotizacionActual);
                    component.set("v.sumaCotizada05", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual05", coverage.cotizacionActual);
                    component.set("v.sumaCotizada05", coverage.cotizacionAjustada);
                }
                break; // Reposicion Documentos (Cobertura 003)
            }
            case "011": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual03", coverage.cotizacionActual);
                    component.set("v.sumaCotizada03", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual03", coverage.cotizacionActual);
                    component.set("v.sumaCotizada03", coverage.cotizacionAjustada);
                }
                break; // Robo en cajero H1 (Cobertura 011)
            }
            case "012": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual04", coverage.cotizacionActual);
                    component.set("v.sumaCotizada04", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual04", coverage.cotizacionActual);
                    component.set("v.sumaCotizada04", coverage.cotizacionAjustada);
                }
                break; // Robo en cajero H2 (Cobertura 012)
            }
        }
    },
    //Asignacion Coberturas Bienes Moviles.
    asignarCoberturaBienesMoviles: function (component, coverage, buttonPressed) {
        switch (coverage.codigoCobertura) {
            case "004": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual06", coverage.cotizacionActual);
                    component.set("v.sumaCotizada06", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual06", coverage.cotizacionActual);
                    component.set("v.sumaCotizada06", coverage.cotizacionAjustada);
                }
                break; //
            }
            case "005": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual07", coverage.cotizacionActual);
                    component.set("v.sumaCotizada07", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual07", coverage.cotizacionActual);
                    component.set("v.sumaCotizada07", coverage.cotizacionAjustada);
                }
                break; //
            }
            case "006": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual08", coverage.cotizacionActual);
                    component.set("v.sumaCotizada08", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual08", coverage.cotizacionActual);
                    component.set("v.sumaCotizada08", coverage.cotizacionAjustada);
                }
                break;
            }
            case "007": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual09", coverage.cotizacionActual);
                    component.set("v.sumaCotizada09", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual09", coverage.cotizacionActual);
                    component.set("v.sumaCotizada09", coverage.cotizacionAjustada);
                }
                break; //
            }
            case "008": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual10", coverage.cotizacionActual);
                    component.set("v.sumaCotizada10", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual10", coverage.cotizacionActual);
                    component.set("v.sumaCotizada10", coverage.cotizacionAjustada);
                }
                break; //
            }
            case "009": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual11", coverage.cotizacionActual);
                    component.set("v.sumaCotizada11", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual11", coverage.cotizacionActual);
                    component.set("v.sumaCotizada11", coverage.cotizacionAjustada);
                }
                break; //
            }
            case "010": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual12", coverage.cotizacionActual);
                    component.set("v.sumaCotizada12", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual12", coverage.cotizacionActual);
                    component.set("v.sumaCotizada12", coverage.cotizacionAjustada);
                }
                break; //
            }
            case "013": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual13", coverage.cotizacionActual);
                    component.set("v.sumaCotizada13", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual13", coverage.cotizacionActual);
                    component.set("v.sumaCotizada13", coverage.cotizacionAjustada);
                }
                break; //
            }
            case "014": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual14", coverage.cotizacionActual);
                    component.set("v.sumaCotizada14", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual14", coverage.cotizacionActual);
                    component.set("v.sumaCotizada14", coverage.cotizacionAjustada);
                }
                break; //
            }
            case "015": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual15", coverage.cotizacionActual);
                    component.set("v.sumaCotizada15", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual15", coverage.cotizacionActual);
                    component.set("v.sumaCotizada15", coverage.cotizacionAjustada);
                }
                break; //
            }
            case "016": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual16", coverage.cotizacionActual);
                    component.set("v.sumaCotizada16", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual16", coverage.cotizacionActual);
                    component.set("v.sumaCotizada16", coverage.cotizacionAjustada);
                }
                break; //
            }
        }
    },
    //Asignacion Coberturas Movilidad
    asignarCoberturasMovilidad: function (component, coverage, buttonPressed) {
        const mantiene = buttonPressed.includes("Mantiene");
        switch (coverage.codigoCobertura) {
            case "018": {
                // Robo Total
                component.set("v.sumaActual01", coverage.cotizacionActual);
                component.set("v.sumaCotizada01", mantiene ? coverage.cotizacionActual : coverage.cotizacionAjustada);
                break;
            }
            case "019": {
                // Adicional Hurto en su Vivienda Particular
                component.set("v.sumaActual02", coverage.cotizacionActual);
                component.set("v.sumaCotizada02", mantiene ? coverage.cotizacionActual : coverage.cotizacionAjustada);
                break;
            }
            case "020": {
                // Adicional Daños como Consecuencia de Robo o su Tentativa
                component.set("v.sumaActual03", coverage.cotizacionActual);
                component.set("v.sumaCotizada03", mantiene ? coverage.cotizacionActual : coverage.cotizacionAjustada);
                break;
            }
            case "021": {
                // Pérdida Total por Incendio y/o Daños por Accidente
                component.set("v.sumaActual04", coverage.cotizacionActual);
                component.set("v.sumaCotizada04", mantiene ? coverage.cotizacionActual : coverage.cotizacionAjustada);
                break;
            }
            case "022": {
                // Adicional Pérdida Parcial por Incendio
                component.set("v.sumaActual05", coverage.cotizacionActual);
                component.set("v.sumaCotizada05", mantiene ? coverage.cotizacionActual : coverage.cotizacionAjustada);
                break;
            }
            case "023": {
                // Responsabilidad Civil
                component.set("v.sumaActual06", coverage.cotizacionActual);
                component.set("v.sumaCotizada06", mantiene ? coverage.cotizacionActual : coverage.cotizacionAjustada);
                break;
            }
            case "024": {
                // Muerte o Invalidez Total y Permanente
                component.set("v.sumaActual07", coverage.cotizacionActual);
                component.set("v.sumaCotizada07", mantiene ? coverage.cotizacionActual : coverage.cotizacionAjustada);
                break;
            }
            case "025": {
                // Adicional por Invalidez Parcial Permanente
                component.set("v.sumaActual08", coverage.cotizacionActual);
                component.set("v.sumaCotizada08", mantiene ? coverage.cotizacionActual : coverage.cotizacionAjustada);
                break;
            }
        }
    },
    //Asignacion Coberturas Compra Protegida.
    asignarCoberturaCompraProtegida: function (component, coverage, buttonPressed) {
        switch (coverage.codigoCobertura) {
            case "002": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual01", coverage.cotizacionActual);
                    component.set("v.sumaCotizada01", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual01", coverage.cotizacionActual);
                    component.set("v.sumaCotizada01", coverage.cotizacionAjustada);
                }
                break; // Robo-Daño accidental - primer evento (Cobertura 002)
            }
            case "003": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual02", coverage.cotizacionActual);
                    component.set("v.sumaCotizada02", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual02", coverage.cotizacionActual);
                    component.set("v.sumaCotizada02", coverage.cotizacionAjustada);
                }
                break; // Robo-Daño accidental - segundo evento (Cobertura 003)
            }
            case "004": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual03", coverage.cotizacionActual);
                    component.set("v.sumaCotizada03", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual03", coverage.cotizacionActual);
                    component.set("v.sumaCotizada03", coverage.cotizacionAjustada);
                }
                break; // Robo-Daño accidental - tercer evento (Cobertura 004)
            }
        }
    },
    //Asignacion Coberturas Accidentes Personales.
    asignarCoberturaAccidentesPersonales: function (component, coverage, buttonPressed) {
        switch (coverage.codigoCobertura) {
            case "001": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual01", coverage.cotizacionActual);
                    component.set("v.sumaCotizada01", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual01", coverage.cotizacionActual);
                    component.set("v.sumaCotizada01", coverage.cotizacionAjustada);
                }
                break; // Muerte accidental (Cobertura 001)
            }
            case "002": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual02", coverage.cotizacionActual);
                    component.set("v.sumaCotizada02", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual02", coverage.cotizacionActual);
                    component.set("v.sumaCotizada02", coverage.cotizacionAjustada);
                }
                break; // Invalidez total y permanente (Cobertura 002)
            }
            case "003": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual03", coverage.cotizacionActual);
                    component.set("v.sumaCotizada03", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual03", coverage.cotizacionActual);
                    component.set("v.sumaCotizada03", coverage.cotizacionAjustada);
                }
                break; // Renta por hospitalizacion hasta (Cobertura 003)
            }
            case "004": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual04", coverage.cotizacionActual);
                    component.set("v.sumaCotizada04", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual04", coverage.cotizacionActual);
                    component.set("v.sumaCotizada04", coverage.cotizacionAjustada);
                }
                break; // Asistencia medica hasta (Cobertura 004)
            }

            /** 
             * case cobre la cobertura nueva
             * preguntarle a zappi a que sa se guarda la cobertura
             * v.sumaActual09
             * v.sumaCotizada09
             */

            case "006": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual05", coverage.cotizacionActual);
                    component.set("v.sumaCotizada05", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual05", coverage.cotizacionActual);
                    component.set("v.sumaCotizada05", coverage.cotizacionAjustada);
                }
                break; // Muerte en accidente de transito (Cobertura 006)
            }
            case "008": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual06", coverage.cotizacionActual);
                    component.set("v.sumaCotizada06", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual06", coverage.cotizacionActual);
                    component.set("v.sumaCotizada06", coverage.cotizacionAjustada);
                }
                break; // Invalidez total temporaria por accidente (Cobertura 008)
            }
            case "009": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual07", coverage.cotizacionActual);
                    component.set("v.sumaCotizada07", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual07", coverage.cotizacionActual);
                    component.set("v.sumaCotizada07", coverage.cotizacionAjustada);
                }
                break; // Fractura de huesos por accidente (Cobertura 009)
            }
            case "010": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual08", coverage.cotizacionActual);
                    component.set("v.sumaCotizada08", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual08", coverage.cotizacionActual);
                    component.set("v.sumaCotizada08", coverage.cotizacionAjustada);
                }
                break; // Indemnizacion por quemaduras por accidente (Cobertura 010)
            }
        }
    },
    //Asignacion Coberturas Vida/Salud.
    asignarCoberturaVidaSalud: function (component, coverage, buttonPressed) {
        switch (coverage.codigoCobertura) {
            case "001": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual01", coverage.cotizacionActual);
                    component.set("v.sumaCotizada01", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual01", coverage.cotizacionActual);
                    component.set("v.sumaCotizada01", coverage.cotizacionAjustada);
                }
                break; // Muerte (Cobertura 001)
            }
            case "004": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual02", coverage.cotizacionActual);
                    component.set("v.sumaCotizada02", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual02", coverage.cotizacionActual);
                    component.set("v.sumaCotizada02", coverage.cotizacionAjustada);
                }
                break; // Muerte Accidental (Cobertura 004)
            }
            case "005": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual03", coverage.cotizacionActual);
                    component.set("v.sumaCotizada03", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual03", coverage.cotizacionActual);
                    component.set("v.sumaCotizada03", coverage.cotizacionAjustada);
                }
                break; // Diagnostico de enfermedad critica (Cobertura 005)
            }
            case "006": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual04", coverage.cotizacionActual);
                    component.set("v.sumaCotizada04", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual04", coverage.cotizacionActual);
                    component.set("v.sumaCotizada04", coverage.cotizacionAjustada);
                }
                break; // Renta diaria por internacion (Cobertura 006)
            }
            case "008": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual05", coverage.cotizacionActual);
                    component.set("v.sumaCotizada05", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual05", coverage.cotizacionActual);
                    component.set("v.sumaCotizada05", coverage.cotizacionAjustada);
                }
                break; // Muerte conyuge (Cobertura 008)
            }
            case "009": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual06", coverage.cotizacionActual);
                    component.set("v.sumaCotizada06", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual06", coverage.cotizacionActual);
                    component.set("v.sumaCotizada06", coverage.cotizacionAjustada);
                }
                break; // Muerte accidental conyuge (Cobertura 009)
            }
            case "011": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual07", coverage.cotizacionActual);
                    component.set("v.sumaCotizada07", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual07", coverage.cotizacionActual);
                    component.set("v.sumaCotizada07", coverage.cotizacionAjustada);
                }
                break; // Cuidado prolongados (Cobertura 011)
            }
            case "013": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual08", coverage.cotizacionActual);
                    component.set("v.sumaCotizada08", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual08", coverage.cotizacionActual);
                    component.set("v.sumaCotizada08", coverage.cotizacionAjustada);
                }
                break; // Gasto de sepelio (Cobertura 013)
            }
        }
    },
    //Asignacion Coberturas Vida/Salud.
    asignarCoberturaSaludIntegral: function (component, coverage, buttonPressed) {
        switch (coverage.codigoCobertura) {
            case "002": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual01", coverage.cotizacionActual);
                    component.set("v.sumaCotizada01", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual01", coverage.cotizacionActual);
                    component.set("v.sumaCotizada01", coverage.cotizacionAjustada);
                }
                break;
            }
            case "003": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual02", coverage.cotizacionActual);
                    component.set("v.sumaCotizada02", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual02", coverage.cotizacionActual);
                    component.set("v.sumaCotizada02", coverage.cotizacionAjustada);
                }
                break;
            }
            case "004": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual03", coverage.cotizacionActual);
                    component.set("v.sumaCotizada03", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual03", coverage.cotizacionActual);
                    component.set("v.sumaCotizada03", coverage.cotizacionAjustada);
                }
                break;
            }
            case "005": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual04", coverage.cotizacionActual);
                    component.set("v.sumaCotizada04", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual04", coverage.cotizacionActual);
                    component.set("v.sumaCotizada04", coverage.cotizacionAjustada);
                }
                break;
            }
            case "006": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual05", coverage.cotizacionActual);
                    component.set("v.sumaCotizada05", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual05", coverage.cotizacionActual);
                    component.set("v.sumaCotizada05", coverage.cotizacionAjustada);
                }
                break;
            }
            case "007": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual06", coverage.cotizacionActual);
                    component.set("v.sumaCotizada06", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual06", coverage.cotizacionActual);
                    component.set("v.sumaCotizada06", coverage.cotizacionAjustada);
                }
                break;
            }
            case "008": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual07", coverage.cotizacionActual);
                    component.set("v.sumaCotizada07", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual07", coverage.cotizacionActual);
                    component.set("v.sumaCotizada07", coverage.cotizacionAjustada);
                }
                break;
            }
            case "009": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual08", coverage.cotizacionActual);
                    component.set("v.sumaCotizada08", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual08", coverage.cotizacionActual);
                    component.set("v.sumaCotizada08", coverage.cotizacionAjustada);
                }
                break;
            }
            case "010": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual09", coverage.cotizacionActual);
                    component.set("v.sumaCotizada09", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual09", coverage.cotizacionActual);
                    component.set("v.sumaCotizada09", coverage.cotizacionAjustada);
                }
                break;
            }
            case "011": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual10", coverage.cotizacionActual);
                    component.set("v.sumaCotizada10", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual10", coverage.cotizacionActual);
                    component.set("v.sumaCotizada10", coverage.cotizacionAjustada);
                }
                break;
            }
            case "012": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual11", coverage.cotizacionActual);
                    component.set("v.sumaCotizada11", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual11", coverage.cotizacionActual);
                    component.set("v.sumaCotizada11", coverage.cotizacionAjustada);
                }
                break;
            }
            case "013": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual12", coverage.cotizacionActual);
                    component.set("v.sumaCotizada12", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual12", coverage.cotizacionActual);
                    component.set("v.sumaCotizada12", coverage.cotizacionAjustada);
                }
                break;
            }
            case "014": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual13", coverage.cotizacionActual);
                    component.set("v.sumaCotizada13", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual13", coverage.cotizacionActual);
                    component.set("v.sumaCotizada13", coverage.cotizacionAjustada);
                }
                break;
            }
            case "015": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual14", coverage.cotizacionActual);
                    component.set("v.sumaCotizada14", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual14", coverage.cotizacionActual);
                    component.set("v.sumaCotizada14", coverage.cotizacionAjustada);
                }
                break;
            }
            case "016": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual15", coverage.cotizacionActual);
                    component.set("v.sumaCotizada15", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual15", coverage.cotizacionActual);
                    component.set("v.sumaCotizada15", coverage.cotizacionAjustada);
                }
                break;
            }
            case "017": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual16", coverage.cotizacionActual);
                    component.set("v.sumaCotizada16", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual16", coverage.cotizacionActual);
                    component.set("v.sumaCotizada16", coverage.cotizacionAjustada);
                }
                break;
            }
            case "018": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual17", coverage.cotizacionActual);
                    component.set("v.sumaCotizada17", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual17", coverage.cotizacionActual);
                    component.set("v.sumaCotizada17", coverage.cotizacionAjustada);
                }
                break;
            }
            case "019": {
                if (buttonPressed.includes("Mantiene")) {
                    component.set("v.sumaActual18", coverage.cotizacionActual);
                    component.set("v.sumaCotizada18", coverage.cotizacionActual);
                } else {
                    component.set("v.sumaActual18", coverage.cotizacionActual);
                    component.set("v.sumaCotizada18", coverage.cotizacionAjustada);
                }
                break;
            }
        }
    },
    //Metodo que lanza un toast.
    showToast: function (title, message, type) {
        $A.get("e.force:showToast")
            .setParams({
                title: title,
                type: type,
                message: message
            })
            .fire();
    },
    //Metodo que muestra el alerta.
    showAlert: function (component, title, message, type) {
        component.set("v.alertType", type);
        component.set("v.alertTitle", title);
        component.set("v.alertMessage", message);
        component.set("v.showAlert", true);
    },
    //Metodo que oculta el alerta.
    hideAlert: function (component) {
        component.set("v.alertType", "");
        component.set("v.alertTitle", "");
        component.set("v.alertMessage", "");
        component.set("v.showAlert", false);
    },
    //Metodo que lanza el evento PresaleEmailQuoteDataValidityEvent.
    firePresaleEmailQuoteDataValidityEvent: function (component, params) {
        var appEvent = $A.get("e.c:PresaleEmailQuoteDataValidityEvent");
        appEvent.setParams({
            coverages: params.coverages,
            prize: params.prize,
            dataOrigin: "quoteData",
            isValid: params.isValid
        });
        appEvent.fire();
    },
    coberturaContratada: function (cobertura) {
        return (
            cobertura.cotizacionActual !== 0 || cobertura.cotizacionInicial !== 0 || cobertura.cotizacionAjustada !== 0
        );
    },
    disableCiberseguridad: function (component, disabled) {
        component.set("v.disabledCiberseguridad", disabled);
    },
    /**disableTelemedicina : function(component, disabled) {
        component.set('v.disabledTelemedicina', disabled);
    },**/
    //!Metodo que controla la botonera del componente.
    buildConfirmationModal: function (component, buttonPressed) {
        //Seteo del titulo
        component.set("v.confirmationModalTitle", "Confirmación");

        //Metodo que setea el mensaje a renderizarse en el modal de confirmación.
        this.setConfirmationModalMessage(component, buttonPressed);

        //Seteo del mensaje de alerta
        component.set(
            "v.confirmationModalWarningMessage",
            "Tenga en cuenta que al confirmar se hará efectivo el cambio."
        );
    },
    validateCupon: function (component, cupon) {
        var action = component.get("c.validarCupon");
        action.setParams({
            cupon: cupon
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retunrValue = response.getReturnValue();
                if (retunrValue == "Cupón Invalido") {
                    component.set("v.showErrorCupon", true);
                    component.set("v.textoValidador", "Cupón Invalido");
                    var myCmp = component.find("inputCuponLay");
                    $A.util.addClass(myCmp, "slds-form-element slds-has-error");
                    component.set("v.cupon", "");
                    var text = component.find("input-ok");
                    $A.util.removeClass(text, "input-text");
                } else {
                    component.set("v.showErrorCupon", false);
                    component.set("v.textoValidador", "Cupón Valido");
                    var myCmp = component.find("inputCuponLay");
                    var myInput = component.find("inputCupon");
                    var text = component.find("input-ok");

                    $A.util.removeClass(myCmp, "slds-form-element");
                    $A.util.removeClass(myCmp, "slds-has-error");
                    $A.util.addClass(myInput, "input-color");
                    $A.util.addClass(text, "input-text");

                    // $A.util.addClass(myCmp, "slds-input:active");
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            } else {
                console.log("Something went wrong, Please check with your admin");
            }
        });

        $A.enqueueAction(action);
    },
    //Metodo que abre el modal de confirmación.
    openConfrimationModal: function (component) {
        component.set("v.openConfirmationModal", true);
    },
    //Metodo que abre el modal de ciberseguridad.
    openCiberseguridadModal: function (component) {
        component.set("v.openCiberseguridadModal", true);
    },
    //Metodo que muestra un mensaje de error y evita la utilizacion del cotizador
    displayError: function (component, message) {
        component.set("v.errorMessage", message);
        component.set("v.hasError", true);

        //Metodo que ejecuta una accion determinada para realizar en el flujo.
        this.flowAction(component);
    },
    //!Metodos de vida individual
    //Metodo que lanza el evento UpdateInsurabilityQuestionsEvent.
    fireUpdateInsurabilityQuestionsEvent: function (component, age, gender, coverageAmount, coveragesCodes) {
        var appEvent = $A.get("e.c:UpdateInsurabilityQuestionsEvent");
        appEvent.setParams({
            age: age,
            gender: gender,
            coverageAmount: coverageAmount,
            lotesCobertura: coveragesCodes
        });
        appEvent.fire();
    },
    //Metodo que realiza promesas para concatenar llamadas apex.
    apex: function (component, apexAction, params) {
        return new Promise(
            $A.getCallback(function (resolve, reject) {
                var action = component.get("c." + apexAction + "");
                action.setParams(params);
                action.setCallback(this, function (callbackResult) {
                    if (callbackResult.getState() === "SUCCESS") {
                        resolve(callbackResult.getReturnValue());
                    }
                    if (callbackResult.getState() === "ERROR") {
                        console.log("ERROR", callbackResult.getError());
                        reject(callbackResult.getError());
                    }
                });
                $A.enqueueAction(action);
            })
        );
    }
});