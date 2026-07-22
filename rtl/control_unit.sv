//---------------------------------------------------------------------
// MODULO DA UNIDADE DE CONTROLE
//---------------------------------------------------------------------
import vending_pkg::*;

module control_unit #(
    parameter WIDTH = 8
)(
    input  logic             clk,
    input  logic             rst,

    input  logic [1:0]       coin_in,
   // input  logic [1:0]       sel_item,
    input  logic             confirm,
    input  logic             cancel,

    input  logic             can_sell,
    input  logic [WIDTH-1:0] change,
    input  logic [WIDTH-1:0] credit,

    output logic             credit_load,
    output logic             mem_read,
    output logic             mem_write,
    output logic             dispense,
    output logic             error,
    output logic [WIDTH-1:0] change_out,
    output state_t           state_out
);

    state_t state, next_state;

    // Saídas registradas
    logic [WIDTH-1:0] change_r;

    // Flag de controle síncrono para esperar 1 ciclo da memória síncrona
    logic mem_ready_q;

    //-------------------------------------
    // Bloco Sequencial (FSM & Saídas Registradas)
    //-------------------------------------
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            change_r     <= '0;
            mem_ready_q  <= 1'b0;

        end else begin
            state <= next_state;

            // Alinhamento síncrono: mem_ready_q vira 1 APÓS a FSM passar 1 ciclo em CHECK
            if (state == CHECK) begin
                mem_ready_q <= 1'b1;
            end else begin
                mem_ready_q <= 1'b0;
            end

            // Registra o troco na transição para o estado CHANGE
            if (next_state == CHANGE) begin
                // Se houve erro ou se o usuário cancelou: Devolve o saldo total inserido (Ex: 200 centavos)
                if (state == ERROR || cancel)
                    change_r <= credit;
                else
                    change_r <= change; // Compra bem-sucedida: Retorna o troco (credit - price)
            end
        end
    end

    //-------------------------------------
    // Lógica Combinacional de Próximo Estado
    //-------------------------------------
    always_comb begin
        next_state = state;

        // Cancelamento global síncrono
        if (cancel && state != IDLE && state != CHANGE) begin
            next_state = CHANGE;

        end else begin
            case(state)
                IDLE: begin
                    if (coin_in != 2'b00)
                        next_state = COLLECT;

                end

                COLLECT: begin
                    if (confirm)
                        next_state = CHECK;
                end

                CHECK: begin
                    // IMPORTANTE: Só toma a decisão se o ciclo de leitura da memória já passou
                    if (!mem_ready_q) begin
                        next_state = CHECK;
                    end else begin
                        if (can_sell)
                            next_state = DISPENSE;
                        else
                            next_state = ERROR;
                    end
                end

                DISPENSE: begin
                    next_state = CHANGE; // Avança imediatamente (pulso de 1 ciclo no estado)
                end

                CHANGE: begin
                    next_state = IDLE;
                end

                ERROR: begin
                    // Aguarda cancel do usuário para voltar
                    if (cancel)
                        next_state = CHANGE;
                end

                default: next_state = IDLE;
            endcase
        end
    end 

    //-------------------------------------
    // Lógica Combinacional de Saídas da FSM
    //-------------------------------------
    always_comb begin
        // Valores default seguros para evitar Latches indesejados
        credit_load = 1'b0;
        mem_read    = 1'b0;
        mem_write   = 1'b0;
        dispense    = 1'b0; // Saída combinacional
        error       = 1'b0; // Saída combinacional
        change_out  = change_r;

        case(state)
            IDLE: begin
                // Estado de espera, saídas zeradas
            end

            COLLECT: begin
                // Mantém estável em 1 durante todo o estado. O módulo credit_reg
                // se encarrega de capturar e acumular no momento da transição.
                credit_load = 1;
            end

            CHECK: begin
                mem_read = 1'b1; // Mantém a leitura síncrona ativa
            end

            DISPENSE: begin
                dispense  = 1'b1; // Pulso combinacional puro durando todo o ciclo de DISPENSE
                mem_write = 1'b1; // Sinaliza o decremento de estoque
            end

            CHANGE: begin
                credit_load = 1'b1; // Ativa para zerar o acumulador de crédito
            end

            ERROR: begin
                error = 1'b1; // Sinalização combinacional de erro ativa no estado ERROR
            end
        endcase
    end

    // Saída de estado registrada para o Testbench/Waveform
    assign state_out = state;

endmodule
