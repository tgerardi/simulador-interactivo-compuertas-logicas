/* ----- GLOBALS ----- */
const rootStyles = getComputedStyle(document.documentElement);
const boardSize = Number(rootStyles.getPropertyValue('--boardSize').slice(0, -2));
let componentCounter = 0;

/* ----- DIAGRAM ----- */
let diagram = {};
function setDiagram() {
    const components = document.querySelectorAll(".component");
    components.forEach((component) => {
        const id = component.id;
        if (diagram[id] != undefined) return;

        const type = component.classList[1].toUpperCase();

        let x = parseFloat(component.style.left.replace("px", "")) || 0;
        let y = parseFloat(component.style.top.replace("px", "")) || 0;
        
        diagram[id] = {
            type: type,
            x: x,
            y: y,
            rotation: 0,
            inputs: {},
            outputs: {}
        };

        // For each output pin
        let outputPins = component.querySelector(".out-pins");
        if (outputPins) {
            let pins = outputPins.querySelectorAll(".pin");
            pins.forEach((pin) => {
                let name = pin.classList[1];
                diagram[id].outputs[name] = { state: 0, to: []}
            });
        }

        // For each input pin
        let inputPins = component.querySelector(".in-pins");
        if (inputPins) {
            let pins = inputPins.querySelectorAll(".pin");
            pins.forEach((pin) => {
                let name = pin.classList[1];
                diagram[id].inputs[name] = { state: 0, from: []}
            });
        }
    });
}

setDiagram();