const paper = document.getElementById("wires");
const pen = paper.getContext("2d");
const wireColorOff = rootStyles.getPropertyValue("--discreettext");
const wireColorOn = rootStyles.getPropertyValue("--primary");
const wireActive = rootStyles.getPropertyValue("--accent");

let startPin;
let startComponent;
let endPin;
let endComponent;
let isWired = false;

let wireCoords = {
    x: 0,
    y: 0
};

document.addEventListener("mousedown", (e) => {
    if (!isWired && e.target.classList.contains("pin")) {
        startPin = e.target.className.split(' ')[1];
        startComponent = e.target.parentElement.parentElement.id;
        isWired = true;
        wireCoords.x = e.pageX;
        wireCoords.y = e.pageY;
    }
});

document.addEventListener("mousemove", (e) => {
    if (isWired) {
        wireCoords.x = e.pageX;
        wireCoords.y = e.pageY;
    }
});

document.addEventListener("click", (e) => {
    if (isWired && !e.target.classList.contains("pin"))
        isWired = false;
    
    //if (e.target.classList.contains("in-pins"))
        handleWiringComponentsEvent(e);
});

document.addEventListener("mouseup", (e) => {
    console.log(e.target.classList)
    //if (e.target.classList.contains("in-pins"))
        handleWiringComponentsEvent(e);
});

function handleWiringComponentsEvent(e) {
    if (isWired && e.target.classList.contains("pin")) {
        endPin = e.target.className.split(' ')[1];
        endComponent = e.target.parentElement.parentElement.id;

        console.log(startComponent);
        console.log(endComponent);

        console.log(diagram[endComponent].outputs[startPin])
        console.log(diagram[endComponent].inputs[endPin])

        const arrayToOutput = diagram[startComponent].outputs[startPin].to;
        const arrayFromInput = diagram[endComponent].inputs[endPin].from;
        const connectionToOutput = {
            component: endComponent,
            pin: endPin
        };
        const connectionFromOutput = {
            component: startComponent,
            pin: startPin
        };
        const exists = arrayToOutput.find(obj => obj.component === connectionToOutput.component && obj.pin === connectionToOutput) !== undefined;
        
        if (exists) return;

        arrayToOutput.push(connectionToOutput);
        arrayFromInput.push(connectionFromOutput);
        isWired = false;
    }
}

function draw() {
    paper.width = document.getElementById("wires").offsetWidth;
    paper.height = document.getElementById("wires").offsetHeight;
    pen.lineWidth = 4;
    pen.clearRect(0, 0, paper.width, paper.height);

    if (isWired) {
        const container = document.getElementById("board");
        const containerRect = container.getBoundingClientRect();

        const scaleX = container.offsetWidth / containerRect.width;
        const scaleY = container.offsetHeight / containerRect.height;

        const endCoords = {
            x: (wireCoords.x - containerRect.left) * scaleX,
            y: (wireCoords.y - containerRect.top) * scaleY
        }

        let cmpStartPin = document.getElementById(startComponent).querySelector("."+startPin);
        const startCoords = getPinCoord(cmpStartPin);

        pen.strokeStyle = wireActive;
        pen.beginPath();
        pen.moveTo(startCoords.x, startCoords.y);
        pen.lineTo(endCoords.x, startCoords.y);
        pen.stroke();
    }

    for (const component in diagram) {
        for (const output in diagram[component].outputs) {
            let outputCmp = document.getElementById(component).querySelector("."+output);
            const startCoords = getPinCoord(outputCmp);
            const { state } = diagram[component].outputs[output];

            if (state === 1)
                pen.strokeStyle = wireColorOn;
            else
                pen.strokeStyle = wireColorOff;

                for (const input of diagram[component].outputs[output].to) {
                    if (document.getElementById(input.component).length) {
                        let inpCmp = document.getElementById(input.component).querySelector("."+input.pin);
                        console.log("ENTRE ACA", inpCmp);
                        const endCoords = getPinCoord(document.getElementById(input.component).querySelector("."+input.pin));

                        pen.beginPath();
                        pen.moveTo(startCoords.x, startCoords.y);
                        if (endCoords.x > startCoords.x) {
                          pen.lineTo(endCoords.x - (Math.abs(startCoords.x - endCoords.x) / 2), startCoords.y);
                          pen.lineTo(endCoords.x - (Math.abs(startCoords.x - endCoords.x) / 2), endCoords.y);
                        } else {
                          pen.lineTo(startCoords.x, endCoords.y - (Math.abs(startCoords.y - endCoords.y) / 2));
                          pen.lineTo(endCoords.x, endCoords.y - (Math.abs(startCoords.y - endCoords.y) / 2));
                        }
                        pen.lineTo(endCoords.x, endCoords.y);
                        pen.stroke();
                    }
                }
        }
    }

    requestAnimationFrame(draw);
}


draw();