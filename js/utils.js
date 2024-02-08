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