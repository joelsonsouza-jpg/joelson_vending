//-------------------------------------
// MODULO DA MEMORIA
//-------------------------------------
import vending_pkg::*;

module memory #(
    parameter WIDTH = 8
)(
    input  logic             clk,
    input  logic [1:0]       sel_item,
    input  logic             mem_read,
    input  logic             mem_write,
    output logic [WIDTH-1:0] price,
    output logic [WIDTH-1:0] stock
);

logic [15:0] mem [0:3];

// Inicialização da memória
initial begin
    mem[0] = {PRICE_CAFE , STOCK_CAFE};
    mem[1] = {PRICE_AGUA , STOCK_AGUA};
    mem[2] = {PRICE_SUCO , STOCK_SUCO};
    mem[3] = {PRICE_SNACK, STOCK_SNACK};
end

// Leitura e escrita síncronas
always @(posedge clk) begin

    if (mem_read) begin
        price <= mem[sel_item][15:8];
        stock <= mem[sel_item][7:0];
    end

    if (mem_write && mem[sel_item][7:0] != 0)
        mem[sel_item][7:0] <= mem[sel_item][7:0] - 1;

end

endmodule