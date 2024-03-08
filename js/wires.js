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

$(document).on("mousedown", ".out-pins", function (e) {
    if (!isWired && $(e.target).hasClass("pin")) {
        startPin = $(e.target).attr("class").split(' ')[1];
        startComponent = $(e.target).parent().parent().attr("id");
        isWired = true;
        wireCoords.x = e.pageX;
        wireCoords.y = e.pageY;
    }
});

$(document).mousemove(function (e) {
    if (isWired) {
        wireCoords.x = e.pageX;
        wireCoords.y = e.pageY;
    }
});

$(document).on("click", function (e) {
    if (isWired && !$(e.target).hasClass("pin")) isWired = false;
});

$(document).on("mouseup click", ".in-pins", function (e) {
    if (isWired && $(e.target).hasClass("pin"))
        handleWiringComponentsEvent(e);
});

function handleWiringComponentsEvent(e) {
    endPin = $(e.target).attr("class").split(' ')[1];
    endComponent = $(e.target).parent().parent().attr("id");

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

function draw() {
    paper.width = $('#wires').outerWidth();
    paper.height = $('#wires').outerHeight();
    pen.lineWidth = 4;
    pen.clearRect(0, 0, paper.width, paper.height);


    if (isWired) {
        const container = document.getElementById('board');
        const containerRect = container.getBoundingClientRect();

        const scaleX = container.offsetWidth / containerRect.width;
        const scaleY = container.offsetHeight / containerRect.height;

        const end = {
            x: (wireCoords.x - containerRect.left) * scaleX,
            y: (wireCoords.y - containerRect.top) * scaleY
        };

        const wireStartCoords = getPinCoord($(`#${startComponent}`).find(`.${startPin}`));

        pen.strokeStyle = wireActive;
        pen.beginPath();
        pen.moveTo(wireStartCoords.x, wireStartCoords.y);
        pen.lineTo(end.x, end.y);
        pen.stroke();
    }

    for (const component in diagram) {
        for (const output in diagram[component].outputs) {
            const start = getPinCoord($(`#${component}`).find(`.${output}`));
            const { state } = diagram[component].outputs[output];
            
            console.log("STATE", state);

            if (state == 1) {
                pen.strokeStyle = wireColorOn;
            } else {
                pen.strokeStyle = wireColorOff;
            }

            for (const input of diagram[component].outputs[output].to) {
                if ($(`#${input.component}`).length) {
                    const end = getPinCoord($(`#${input.component}`).find(`.${input.pin}`));
                    pen.beginPath();
                    pen.moveTo(start.x, start.y);
                    if (end.x > start.x) {
                        pen.lineTo(end.x - (Math.abs(start.x - end.x) / 2), start.y);
                        pen.lineTo(end.x - (Math.abs(start.x - end.x) / 2), end.y);
                    } else {
                        pen.lineTo(start.x, end.y - (Math.abs(start.y - end.y) / 2));
                        pen.lineTo(end.x, end.y - (Math.abs(start.y - end.y) / 2));
                    }
                    pen.lineTo(end.x, end.y);
                    pen.stroke();
                }
            }
        }
    }
    requestAnimationFrame(draw);
}

draw();