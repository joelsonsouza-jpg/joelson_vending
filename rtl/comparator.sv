//-------------------------------------
// MODULO DO COMPARADOR
//-------------------------------------
import vending_pkg::*;

module comparator #(
    parameter WIDTH = 8
)(
    input  logic [WIDTH-1:0] credit,
    input  logic [WIDTH-1:0] price,
    input  logic [WIDTH-1:0] stock,

    output logic can_sell
);
     assign can_sell = (credit >= price) && (stock > 8'b0);
endmodule