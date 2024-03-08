
/* GATES */
const BUFFER = a => a;
const AND = (p, q) => p && q;
const OR = (p, q) => p || q;
const NOT = p => !p;
const XOR = (p, q) => (p !== q);
const NOR = (p, q) => !(p || q);
const NAND = (p, q) => !(p && q);
const XNOR = (p, q) => !XOR(p, q);

function activateSwitch(switchComponent) {
    if (switchComponent.hasClass("on"))
        switchComponent.removeClass("on");
    else
        switchComponent.addClass("on");

    $("#activateSwitchComponent").addClass("hover").delay(400).queue(function(next) {
        $(this).removeClass("hover");
        next();
    });
}