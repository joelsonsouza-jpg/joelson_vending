    
package vending_pkg;

    parameter WIDTH = 8;

  // Valores das moedas

  parameter COIN_0   = 8'd0;
  parameter COIN_25  = 8'd25;
  parameter COIN_50  = 8'd50;
  parameter COIN_100 = 8'd100;

  // Preços dos produtos

 parameter PRICE_CAFE  = 8'd25;
 parameter PRICE_AGUA  = 8'd50;
 parameter PRICE_SUCO  = 8'd75;
parameter PRICE_SNACK = 8'd100;


        // Estoque inicial
        
      parameter STOCK_CAFE  = 8'd5;
      parameter STOCK_AGUA  = 8'd5;
      parameter STOCK_SUCO  = 8'd3;
      parameter STOCK_SNACK = 8'd2;


      typedef enum logic [2:0] {
          IDLE     = 3'b000,
          COLLECT  = 3'b001,
          CHECK    = 3'b010,
          DISPENSE = 3'b011,
          CHANGE   = 3'b100,
          ERROR    = 3'b101

        } state_t;


    endpackage