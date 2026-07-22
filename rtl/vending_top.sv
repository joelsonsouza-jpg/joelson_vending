    //---------------------------------------------------------------------
    // TOP-LEVEL MODULE (CORRIGIDO E CONECTADO COM O DATAPATH)
    //---------------------------------------------------------------------
    import vending_pkg::*;

    module vending_top #(
        parameter WIDTH = 8
    )(
        input  logic             clk,
        input  logic             rst,
        input  logic [1:0]       coin_in,
        input  logic [1:0]       sel_item,
        input  logic             confirm,
        input  logic             cancel,

        output logic             dispense,
        output logic [WIDTH-1:0] change_out,
        output logic             error,
        output logic [WIDTH-1:0] display,
        output state_t           state_out

    );

        // Sinais internos de interconexão
        logic [WIDTH-1:0] credit;
        logic [WIDTH-1:0] price;
        logic [WIDTH-1:0] stock;
        logic [WIDTH-1:0] change_r; // Renomeado para evitar conflitos de escopo

        logic credit_load;
        logic mem_read;
        logic mem_write;
        logic can_sell;

        // 1. UNIDADE DE CONTROLE (FSM)
        control_unit #(.WIDTH(WIDTH)) u_control (
            .clk        (clk),
            .rst        (rst),
            .coin_in    (coin_in),
           // .sel_item   (sel_item),
            .confirm    (confirm),
            .cancel     (cancel),
            .can_sell   (can_sell),
            .change     (change_r),    // Recebe o valor calculado pelo subtrator
            .credit     (credit),        // Entrada adicionada para permitir devolução total no erro
            .credit_load(credit_load),
            .mem_read   (mem_read),
            .mem_write  (mem_write),
            .dispense   (dispense),
            .error      (error),
            .change_out (change_out),    // Saída registrada oficial para o mundo externo
            .state_out  (state_out)
        );

        // 2. REGISTRADOR DE CRÉDITO (ACUMULADOR)
        credit_reg #(.WIDTH(WIDTH)) u_credit (
            .clk        (clk),
            .rst        (rst),
            .cancel     (cancel),
            .coin_in    (coin_in),
            .credit_load(credit_load),
            .state      (state_out),
            .credit     (credit)
        );

        // 3. MEMÓRIA SÍNCRONA DE DADOS
        memory #(.WIDTH(WIDTH)) u_memory (
            .clk        (clk),
            .sel_item   (sel_item),
            .mem_read   (mem_read),
            .mem_write  (mem_write),
            .price      (price),
            .stock      (stock)
        );

        // 4. COMPARADOR COMBINACIONAL
        comparator u_comp (
            .credit     (credit),
            .price      (price),
            .stock      (stock),
            .can_sell   (can_sell)
        );

        // 5. SUBTRATOR COMBINACIONA
        subtractor #(.WIDTH(WIDTH)) u_sub (
            .credit     (credit),
            .price      (price),
            .change     (change_r)
        );

        // Atribuições Contínuas
        assign display = credit;

    endmodule
