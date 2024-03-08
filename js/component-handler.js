/* ----- COMPONENT HANDLER ----- */

let isDragging = false;
let componentDelay = false;
let isNewDragging = false;
let selectedComponent = "";
let draggedComponent;
let hover = "";

/* Switch Activation */
$("#activateSwitchComponent").click( (e) => {
    activateSwitch(selectedComponent);
});

$(document).dblclick(".component", (e) => {
    if (!$(e.target).hasClass("pin") && $(e.target).hasClass("switch"))
        activateSwitch($(e.target));
});

/* Preventing the switch to turn off if the pin has been clicked */
$(document).on("contextmenu", ".switch", (e) => {
    if(!$(e.target).hasClass("pin"))
        activateSwitch($(this));
});

/* Unselect components */
$("#board").on("click", (e) => {
    if (selectedComponent !== "" && selectedComponent.attr("id") !== $(e.target).attr("id")) {
        $(".selected").removeClass("selected");
        selectedComponent = "";
    }
});

/* Select component */
$(document).on("mousedown", ".component", (e) => {
    if (e.button === 0) {
        if ($(this).hasClass("selected")) {
            $(".selected").removeClass("selected");
            selectedComponent = "";
        } else {
            $(".selected").removeClass("selected");
            $(this).addClass("selected");
            selectedComponent = $(this);
            if (selectedComponent.hasClass("switch"))
                $("#activateSwitchComponent").removeClass("ignored");
            else
                $("#activateSwitchComponent").addClass("ignored");
        }
    }
});

/* Dragging Logic */
document.addEventListener("mousedown", (e) => {
    /* Dragging components */
    if (e.target.classList.contains("component")) {
        if (!e.target.classList.contains("pin")) {
            if (e.type === "mousedown" && e.button !== 0) {
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

/* Components movements */
document.addEventListener("mousemove", (e) => {
    if (isDragging || isNewDragging) {
        let x, y;
        x = e.pageX;
        y = e.pageY

        const [posX, posY] = mousePositionToCoordinates(x, y, draggedComponent);

        if (posY > 0 && posY < boardSize) {
            draggedComponent.style.top = posY + "px";
            if (!isNewDragging)
                diagram[draggedComponent.id].y = posY;
        }
        if (posX > 0 && posX < boardSize) {
            draggedComponent.style.left = posX + "px";
            if (!isNewDragging) 
                diagram[draggedComponent.id].x = posX;
        }
    }
});

document.getElementById("panel").addEventListener("mouseup", (e) => {
    if (isNewDragging) {
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

/* Switch hover */
$(document).on('mouseover', '.switch', () => {
    hover = $(this);
});

$(document).on('mouseout', '.switch', () => {
    hover = '';
});

// TODO!! Ver por que el id de selectedComponent es undefined
function deleteComponent() {
    let id;
    console.log("selected component", selectedComponent)
    id = selectedComponent.id;
    delete diagram[id];
    document.getElementById(id).remove()
    setDiagram();
}