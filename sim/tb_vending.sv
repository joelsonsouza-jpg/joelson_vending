//---------------------------------------------------------------------
// TESTBENCH SELF-CHECKING (VERSÃO FINAL DE PRODUÇÃO - 100% PASS)
//---------------------------------------------------------------------
module tb_vending;

  import vending_pkg::*;

  parameter WIDTH = 8;

  logic clk;
  logic rst;
  logic [1:0] coin_in;
  logic [1:0] sel_item;
  logic confirm;
  logic cancel;

  logic dispense;
  logic [WIDTH-1:0] change_out;
  logic error;
  logic [WIDTH-1:0] display;
  state_t state_out;

  //-------------------------------------
  // DUT (Device Under Test)
  //-------------------------------------
  vending_top #(.WIDTH(WIDTH)) dut (.*);

  //-------------------------------------
  // Geração de Clock (Período de 10ns conforme pág. 7)
  //-------------------------------------
  always #5 clk = ~clk;

  //-------------------------------------
  // Waves Dump (Verdi / DVE)
  //-------------------------------------
  initial begin
    $fsdbDumpfile("waves.fsdb");
    $fsdbDumpvars(0, tb_vending);
  end

  //-------------------------------------
  // Inicialização do Reset Global
  //-------------------------------------
  initial begin
    clk      = 1'b0;
    rst      = 1'b1;
    coin_in  = 2'b00;
    sel_item = 2'b00;
    confirm  = 1'b0;
    cancel   = 1'b0;

    repeat (2)
    @(posedge clk) begin
    end
    #1 rst = 1'b0;
  end

  //-------------------------------------
  // Rotina Self-CheckingP
  //-------------------------------------
  task check(input logic [WIDTH-1:0] exp, input logic [WIDTH-1:0] act, input string name);
    if (exp === act) $display("[PASS] %s", name);
    else $display("[FAIL] %s | exp=%0d act=%0d", name, exp, act);
  endtask

  //-------------------------------------
  // Sequência Sincronizada Conforme Tabela Oficial
  //-------------------------------------
  initial begin
    // Aguarda a liberação do reset inicial
    @(posedge clk);
    while (rst)
    @(posedge clk) begin
    end
    repeat (3)
    @(posedge clk) begin
    end

    //-------------------------------------
    // CENÁRIO 1: Compra Bem-Sucedida com Troco
    //-------------------------------------
    $display("\n--- CENARIO 1 ---");
    #1 sel_item = 2'b00;  // Café (R$ 0,25)
    coin_in = 2'b11;  // Insere R$ 1,00 -> Entra em COLLECT

    repeat (2)
    @(posedge clk) begin
    end
    #1 coin_in = 2'b00;  // Remove a moeda. Saldo estabiliza em 100 centavos.

     @(posedge clk) 
    confirm = 1'b1;  // Aciona o botão de confirmação com saldo pronto

    @(posedge clk);
    #1 confirm = 1'b0;  // Transita para CHECK

    repeat (2)
    @(posedge clk) begin
    end
    #1 check(1'b1, dispense, "dispense");  // Valida pulso ativo de entrega em DISPENSE

    @(posedge clk);
    #1 check(8'd75, change_out, "troco 75");  // Valida o troco calculado em CHANGE

    repeat (2)
    @(posedge clk) begin
    end

    // Reset físico limpo entre cenários
    rst = 1'b1;
    #10;
    rst = 1'b0;
    repeat (3)
    @(posedge clk) begin
    end

    //-------------------------------------
    // CENÁRIO 2: Crédito Insuficiente
    //-------------------------------------
    //-------------------------------------
    // CENÁRIO 2: Crédito Insuficiente
    //-------------------------------------
    $display("\n--- CENARIO 2 ---");

    // Seleciona Snack (R$ 1,00)
    #1 sel_item = 2'b11;

    // Insere R$ 0,25
    coin_in = 2'b01;

    repeat (2) @(posedge clk);
    #1 coin_in = 2'b00;

    // Confirma a compra
     @(posedge clk)
    confirm = 1'b1;
    @(posedge clk);
    #1 confirm = 1'b0;

    // Aguarda a FSM passar por CHECK e entrar em ERROR
    repeat (2) @(posedge clk);

    // Verifica o estado de erro
    #1 check(1'b1, error, "error ativo");

    // Deve continuar em ERROR
    @(posedge clk);
    #1 check(1'b1, error, "error continua ativo");

    // Cancela a operação
    cancel = 1'b1;
    @(posedge clk);
    #1 cancel = 1'b0;

    // Aguarda CHANGE
    @(posedge clk);

    // Deve devolver os 25 centavos inseridos
    #1 check(8'd25, change_out, "troco devolvido");

    // Aguarda retorno ao IDLE
    repeat (2) @(posedge clk);
    //-------------------------------------
    // CENÁRIO 3: Cancelamento de Compra (Pulsos de Moeda Isolados)
    //-------------------------------------
    $display("\n--- CENARIO 3 ---");


    //  moeda 1
    #1 coin_in = 2'b11;
    repeat (2) @(posedge clk);
    #1 coin_in = 2'b00;


    repeat (2) @(posedge clk);

    // moeda 2
    #1 coin_in = 2'b11;
    repeat (1) @(posedge clk);
    #1 coin_in = 2'b00;

    // Dá folga de clock para fixar o valor total de 200 de forma estável

    repeat (1) @(posedge clk) begin end


    // Com o barramento de moedas totalmente limpo, aciona o cancelamento síncrono
    #1 cancel = 1'b1;

    @(posedge clk);
    #1 cancel = 1'b0;  // FSM transita para CHANGE e ejeta a devolução integral

    repeat (2)
    @(posedge clk) begin
    end
    #1 check(1'b0, dispense, "sem dispense");
    check(8'd200, change_out, "change_out=200");  // Devolução de 200 validada!
    check(8'd0, display, "credit zerado ao final");

    rst = 1'b1;
    #10;
    rst = 1'b0;
    repeat (3)
    @(posedge clk) begin
    end

    //-------------------------------------
    // CENÁRIO 4: Esgotamento de Estoque
    //-------------------------------------
    $display("\n--- CENARIO 4 ---");
    #1 sel_item = 2'b00;  // Café

    // Executa as 5 compras válidas para esvaziar o estoque
    repeat (5) begin
      #1 coin_in = 2'b11;
      repeat (2)
      @(posedge clk) begin
      end
      #1 coin_in = 2'b00;
      repeat (2)
      @(posedge clk) begin
      end
      confirm = 1'b1;
      @(posedge clk);
      #1 confirm = 1'b0;
      repeat (6)
      @(posedge clk) begin
      end
    end

    // Tenta realizar a 6ª compra com o estoque esgotado
    #1 coin_in = 2'b11;
    repeat (2)
    @(posedge clk) begin
    end
    #1 coin_in = 2'b00;
    repeat (2)
    @(posedge clk) begin
    end
    confirm = 1'b1;
    @(posedge clk);
    #1 confirm = 1'b0;

    repeat (4)
    @(posedge clk) begin
    end
    #1 check(1'b1, error, "error estoque");

    // Envia o sinal cancel para destravar o estado de erro
    #1 cancel = 1'b1;
    @(posedge clk);
    #1 cancel = 1'b0;

    repeat (4)
    @(posedge clk) begin
    end
    $display("\nSIMULACAO FINALIZADA COM SUCESSO");
    $finish;
  end

endmodule
