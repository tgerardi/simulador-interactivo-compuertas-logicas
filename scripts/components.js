class Gate {
    constructor(type, binaryOp) {
        this.type = type;
        this.binaryOp = binaryOp;
    }

    output() {
        return this.binaryOp;
    }

    error() {
        alert("Error en los valores ingresados!!");
    }
}

// Binary Operations (Hardcoded)
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

