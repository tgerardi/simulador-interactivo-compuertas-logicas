
function start() {    
    let condToStart = true;
    while (condToStart) {
        condToStart = confirm("Input values for P and Q to generate the truth tables for each logic gate.\nEnter '1' for true or '0' for false for each input.\nPress the cancel button to exit.");
        if(!condToStart) break;

        let vp = prompt("P:").trim().toUpperCase() == "1" ? true : false;
        let vq = prompt("Q:").trim().toUpperCase() == "1" ? true : false;

        alert("NOT P: " + NOT(vp) + "\n" + "NOT Q: " + NOT(vq) + "\n" + AND(vp, vq) + "\n" + OR(vp, vq) + "\n" + NAND(vp, vq) + "\n" + NOR(vp, vq) + "\n" + XOR(vp, vq) + "\n" + XNOR(vp, vq));
    }
}

function AND(p, q) {
    return `AND: ${p && q ? 1 : 0}`;
}

function OR(p, q) {
    return `OR: ${p || q ? 1 : 0}`;
}

function XOR(p, q) {
    return `XOR: ${p !== q ? 1 : 0}`;
}

function XNOR(p, q) {
    return `XNOR: ${p === q ? 1 : 0}`;
}

function NOR(p, q) {
    return `NOR: ${!(p || q) ? 1 : 0}`;
}

function NAND(p, q) {
    return `NAND: ${!(p && q) ? 1 : 0}`;
}

function NOT(p) {
    return `${!p ? 1 : 0}`;
}