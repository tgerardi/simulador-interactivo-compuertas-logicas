let start;
while (true) {
    start = prompt("Ingrese START para comenzar\nIngrese la palabra ESC para salir.").toUpperCase();
    if (start == "ESC") break;
    let gate = parseInt(prompt("Seleccione una compuerta: \n1. AND\n2. OR\n3. XOR\n4. XNOR\n5. NOR\n6. NAND\n7. NOT"));
    let inputA = parseInt(prompt("Ingrese un valor [0:1] para A:"));
    let inputB = parseInt(prompt("Ingrese un valor [0:1] para B:"));

    // Generate Hardcoded data (only for the moment)
    const gates = [
        new Gate('AND', AND(inputA, inputB)),
        new Gate('OR', OR(inputA, inputB)),
        new Gate('XOR', XOR(inputA, inputB)),
        new Gate('XNOR', XNOR(inputA, inputB)),
        new Gate('NOR', NOR(inputA, inputB)),
        new Gate('NAND', NAND(inputA, inputB)),
        new Gate('NOT', NOT(inputA, inputB))
    ];

    if ((inputA == 0 || inputA == 1) && (inputB == 0|| inputB == 1)) { 
        alert("GATE: " + gates[gate-1].type + " OUTPUT: " + gates[gate-1].binaryOp);
    } else {
        gates[gate-1].error();
    }   
}
