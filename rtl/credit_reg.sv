    //---------------------------------------------------------------------
    // REGISTRADOR DE CRÉDITO (VERSÃO COMPLETA ESTABILIZADA)
    //---------------------------------------------------------------------
    import vending_pkg::*;
module credit_reg #(
        parameter WIDTH = 8
    )(
        input  logic              clk,
        input  logic              rst,
        input  logic              cancel,
        input  logic [1:0]        coin_in,
        input  logic              credit_load,
        input  state_t            state,
        output logic [WIDTH-1:0]  credit
    );

        logic [WIDTH-1:0] coin_value;

        // Decodificação combinacional da moeda
        always_comb begin
            case (coin_in)
                2'b01  : coin_value = COIN_25;  // R$ 0,25
                2'b10  : coin_value = COIN_50;  // R$ 0,50
                2'b11  : coin_value = COIN_100; // R$ 1,00
                default: coin_value = COIN_0;   // Sem moeda
            endcase
        end

        // Acumulador síncrono robusto
        always_ff @(posedge clk or posedge rst) begin

            if (rst  || cancel ) begin
                credit <= '0;

            end else begin


                if (state == CHANGE && credit_load ==1) begin


                    credit <= '0; // Zera o crédito acumulado ao final do ciclo


                end else if ( credit_load && state == COLLECT) begin
                    credit <= credit+ coin_value;
                    

                end
            end
        end
    endmodule
