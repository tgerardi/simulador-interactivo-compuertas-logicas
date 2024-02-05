/* ----- COMPONENT HANDLER ----- */

let isDragging = false;
let componentDelay = false;
let isNewDragging = false;
let selectedComponent = "";
let draggedComponent;

/* Selected components */
document.addEventListener("mousedown", (e) => {
    if (e.target.classList.contains("component")) {
        let clickedComponent = e.target;
        if (clickedComponent.classList.contains("selected")) {
            clickedComponent.classList.remove("selected");
            selectedComponent = "";
        } else {
            let selectedComponents = document.querySelectorAll(".selected");
            selectedComponents.forEach((selected) => {
                selected.classList.remove("selected");
            });

            clickedComponent.classList.add("selected");
            selectedComponent = clickedComponent;

            let switchComponent = document.getElementById("activateSwitchComponent");
            if (selectedComponent.classList.contains("switch"))
                switchComponent.classList.remove("ignored");
            else
                switchComponent.classList.add("ignored");
        }
    }
});

/* Switch Activation */
let activateSwitchComponent = document.getElementById("activateSwitchComponent");
activateSwitchComponent.addEventListener("click", (e) => {
    activateSwitch(selectedComponent);
});

document.addEventListener("dblclick", (e) => {
    if (e.target.classList.contains("component")) {
        if (!e.target.classList.contains("pin") && e.target.classList.contains("switch")) {
            activateSwitch(e.target)
        }
    }
})

/* Unselect components */
let unselectComponent = document.getElementById("board");
unselectComponent.addEventListener("click", (e) => {
    if (selectedComponent !== "" && selectedComponent.id !== e.target.id) {
        let selected = document.getElementsByClassName("selected")[0];
        selected.classList.remove("selected");
        selectedComponent = "";
    }
})

document.addEventListener("mousedown", (e) => {
    /* Dragging components */
    if (e.target.classList.contains("component")) {
        if (!e.target.classList.contains("pin")) {
            if (e.type === "mousedown") {
                return;
            }
            isDragging = true;
            draggedComponent = e.target;
        }
    }

    /* Adding components */
    if (e.target.classList.contains("add-component")) {
        if (isDragging || isNewDragging || componentDelay) return;

        const gate = e.target.innerText.trim();
        // TODO!! Ver por que el BUFFER me lo trae sin imagen
        const html = localStorage.getItem(gate).replace(`id=""`, `id="component${componentCounter}"`);

        const componentsContainer = document.querySelector(".components");
        componentsContainer.insertAdjacentHTML("beforeend", html);

        draggedComponent = document.getElementById(`component${componentCounter}`);

        componentCounter += 1;

        let x, y;
        x = e.pageX;
        y = e.pageY;

        const [posX, posY] = mousePositionToCoordinates(x, y, draggedComponent);
        isNewDragging = true;
        draggedComponent.style.left = posX + "px";
        draggedComponent.style.top = posY + "px";

        componentDelay = true;
        setTimeout(() => {
            componentDelay = false;
        }, 250);
    }
});

document.addEventListener("mousemove", (e) => {
    if (isDragging || isNewDragging) {
        let x, y;
        x = e.pageX;
        y = e.pageY

        const [posX, posY] = mousePositionToCoordinates(x, y, draggedComponent);

        if (posY > 0 && posY < boardSize) {
            draggedComponent.style.top = posY + "px";
            if (!isNewDragging) { // TODO!! Ver por que no entra a este if, este if cumple la funcionalidad de arrastrar componentes dentro el tablero
                console.log("enrte")
                diagram[draggedComponent.id].y = posY;
            }
        }
        if (posX > 0 && posX < boardSize) {
            draggedComponent.style.left = posX + "px";
            console.log(diagram[draggedComponent.id]);
            if (!isNewDragging) { // TODO!! Ver por que no entra a este if, este if cumple la funcionalidad de arrastrar componentes dentro el tablero
                console.log("enrte")
                diagram[draggedComponent.id].x = posX;
            }
        }
    }
});

document.getElementById("panel").addEventListener("mouseup", (e) => {
    if (isNewDragging) {
        console.log("enter")
        let [x, y] = mousePositionToCoordinates(window.innerWidth / 2, window.innerHeight / 2, draggedComponent);
        let overlaping = true;
        while (overlaping) {
            overlaping = false;
            for (const component in diagram) {
                if (Math.abs(x - diagram[component].x) < 20 && Math.abs(y - diagram[component].y) < 20) {
                    x += 75;
                    y += 75;
                    overlaping = true;
                }
            }
        }

        draggedComponent.style.left = x + "px";
        draggedComponent.style.top = y + "px";
        isDragging = false;
        isNewDragging = false;
        draggedComponent = false;
        setDiagram();
    }
});

document.addEventListener("mouseup", (e) => {
    isDragging = false;
    if (isNewDragging)
        setDiagram();

    isNewDragging = false;
    draggedComponent = false;
});

/**
 * Converts the mouse coordinates to relative coordinates for a container
 * 
 * @param {number} x 
 * @param {number} y 
 * @param {HTMLElement} component
 * @returns {[Number, Number]}
 */
function mousePositionToCoordinates(x, y, component) {
    const container = document.getElementById("board");
    const containerRect = container.getBoundingClientRect();
    const componentRect = component.getBoundingClientRect();
    const scaleX = container.offsetWidth / containerRect.width;
    const scaleY = container.offsetHeight / containerRect.height;
    let posX = (x - containerRect.left) * scaleX;
    let posY = (y - containerRect.top) * scaleY;
    posX -= (componentRect.width / 2)
    posY -= (componentRect.height / 2)

    return [posX, posY];
}

/**
 * JS and CSS of the switch (ON / OFF)
 * 
 * @param {HTMLElement} switchComponent 
 */
function activateSwitch(switchComponent) {
    if (switchComponent.classList.contains("on"))
        switchComponent.classList.remove("on");
    else
        switchComponent.classList.add("on");
    let activateSwitchComponent = document.getElementById("activateSwitchComponent");
    activateSwitchComponent.classList.add("hover");

    setTimeout(() => {
        activateSwitchComponent.classList.remove("hover");
    }, 400);
}