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
 * Get the offset of the element
 *  
 * @param {HTMLElemnt} element 
 * @returns {[offsetTop, offsetLeft]} 
 */
function getOffset(element) {
    let rect = element.getBoundingClientRect();
    let scrollLeft = window.scrollX || document.documentElement.scrollLeft;
    let scrollTop = window.scrollY || document.documentElement.scrollTop;

    return {
        top: rect.top + scrollTop,
        left: rect.left + scrollLeft
    };
}

/**
 * Get the coordinates of the pin
 * 
 * @param {HTMLElement}
 * @return {[x, y]}
 */
function getPinCoord(pin) {
    const container = document.getElementById("board");
    const containerRect = container.getBoundingClientRect();

    const scaleX = container.offsetWidth / containerRect.width;
    const scaleY = container.offsetHeight / containerRect.height;

    offset = pin.offset();
    const posX = (offset.left - containerRect.left) * scaleX;
    const posY = (offset.top - containerRect.top) * scaleY;

    return {
        x: posX + pin.width() / 2,
        y: posY + pin.height() / 2
    };
}

