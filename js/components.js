const light_component =  `<div class="component light" id=""><div class="in-pins"><span class="pin input"></span></div></div> `;
const switch_component = `<div class="component switch" id=""><div class="out-pins"><span class="pin output"></span></div></div>`;
const buffer_component = `<div class="component buffer" id=""><div class="tooltip">BUFFER</div><div class="in-pins"><span class="pin input1"></span></div><div class="out-pins"><span class="pin output1"></span></div></div>`;
const not_component = `<div class="component not" id=""><div class="tooltip">NOT</div><div class="in-pins"><span class="pin input1"></span></div><div class="out-pins"><span class="pin output1"></span></div></div>`;
const and_component = `<div class="component and" id=""><div class="tooltip">AND</div><div class="in-pins"><span class="pin input1"></span><span class="pin input2"></span></div><div class="out-pins"><span class="pin output1"></span></div></div>`;
const nand_component = `<div class="component nand" id=""><div class="tooltip">NAND</div><div class="in-pins"><span class="pin input1"></span><span class="pin input2"></span></div><div class="out-pins"><span class="pin output1"></span></div></div>`;
const or_component = `<div class="component or" id=""><div class="tooltip">OR</div><div class="in-pins"><span class="pin input1"></span><span class="pin input2"></span></div><div class="out-pins"><span class="pin output1"></span></div></div>`;
const nor_component = `<div class="component nor" id=""><div class="tooltip">NOR</div><div class="in-pins"><span class="pin input1"></span><span class="pin input2"></span></div><div class="out-pins"><span class="pin output1"></span></div></div>`;
const xor_component = `<div class="component xor" id=""><div class="tooltip">XOR</div><div class="in-pins"><span class="pin input1"></span><span class="pin input2"></span></div><div class="out-pins"><span class="pin output1"></span></div></div>`;
const xnor_component = `<div class="component xnor" id=""><div class="tooltip">XNOR</div><div class="in-pins"><span class="pin input1"></span><span class="pin input2"></span></div><div class="out-pins"><span class="pin output1"></span></div></div>`;

localStorage.setItem("LIGHT", light_component);
localStorage.setItem("SWITCH", switch_component);
localStorage.setItem("BUFFER", buffer_component);
localStorage.setItem("NOT", not_component);
localStorage.setItem("AND", and_component);
localStorage.setItem("NAND", nand_component);
localStorage.setItem("OR", or_component);
localStorage.setItem("NOR", nor_component);
localStorage.setItem("XOR", xor_component);
localStorage.setItem("XNOR", xnor_component);