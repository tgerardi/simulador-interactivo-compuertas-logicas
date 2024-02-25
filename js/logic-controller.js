
/* Switches */
const BUFFER = a => a;

const AND = (p, q) => p && q;

const OR = (p, q) => p || q;

const NOT = p => !p;

const XOR = (p, q) => (p !== q);

const NOR = (p, q) => !(p || q);

const NAND = (p, q) => !(p && q);

const XNOR = (p, q) => !XOR(p, q);

function process() {
    for (const component in diagram) {
        /* LIGHT */
        if (diagram[component] === "LIGHT") {
            const inputs = Object.values(diagram[component].inputs).map(input => input.state);
            if (inputs.includes(1))
                document.getElementById(component).classList.add("on");
            else
                document.getElementById(component).classList.remove("on");
        }
        
        /* SWITCH */
        if (diagram[component] === "SWITCH") {
            let cmpOn = document.getElementById(component).classList.contains("on");
            if (cmpOn)
                diagram[component].outputs.output.state = 1;
            else
                diagram[component].outputs.output.state = 0;

            result = diagram[component].outputs.output.state;

            for (const input of diagram[component].outputs.output.to) {
                let cmpInput = document.getElementById(input.component);
                if (cmpInput.length) {
                    diagram[input.component].inputs[input.pin].state = result;
                } else {
                    const arrayOutput = digram[component].outputs.output.to;
                    const indexOutput = arrayOutput.indexOf(input);
                    arrayOutput.splice(indexOutput, 1);
                }
            }
        } else {
            for (const output in diagram[component].outputs) {
                const inputs = Object.values(diagram[component].inputs).map(input => input.state);
                const result = window[diagram[component].type](...inputs);
                
                diagram[component].outputs[output].state = result;

                if (result === 1) 
                    document.getElementById(component).getElementsByClassName(output)[0].classList.add("on");
                else 
                    document.getElementById(component).getElementsByClassName(output)[0].classList.remove("on");

                for (const input of diagram[component].outputs[output].to) {
                    let cmpInput = document.getElementById(input.component);
                    if (cmpInput.length) {
                        diagram[input.component].inputs[input.pin].state = result;
                    } else {
                        const arrayOutput = diagram[component].outputs[output].to;
                        const indexOutput = arrayOutput.indexOf(input);
                        arrayOutput.splice(indexOutput, 1);
                    }
                }
            }
        }
    }
}