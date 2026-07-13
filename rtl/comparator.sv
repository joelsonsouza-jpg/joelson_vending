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
        
     always @(*) begin
        if(credit >= price  &&  stock != 8'd0) begin
          can_sell <= 1 ; 
        end 
          else  begin
          can_sell <= 0;

        end
   end

endmodule 