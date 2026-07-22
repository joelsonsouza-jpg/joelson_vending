package vending_pkg;

    parameter int WIDTH = 8;

    // Moedas
    localparam logic [WIDTH-1:0] COIN_0   = 0;
    localparam logic [WIDTH-1:0] COIN_25  = 25;
    localparam logic [WIDTH-1:0] COIN_50  = 50;
    localparam logic [WIDTH-1:0] COIN_100 = 100;


    // Preços
    localparam logic [WIDTH-1:0] PRICE_CAFE  = 25;
    localparam logic [WIDTH-1:0] PRICE_AGUA  = 50;
    localparam logic [WIDTH-1:0] PRICE_SUCO  = 75;
    localparam logic [WIDTH-1:0] PRICE_SNACK = 100;


    // Estoque inicial
    localparam logic [WIDTH-1:0] STOCK_CAFE  = 5;
    localparam logic [WIDTH-1:0] STOCK_AGUA  = 5;
    localparam logic [WIDTH-1:0] STOCK_SUCO  = 3;
    localparam logic [WIDTH-1:0] STOCK_SNACK = 2;


    // Estados da FSM
    typedef enum logic [2:0] {

        IDLE     = 3'b000,
        COLLECT  = 3'b001,
        CHECK    = 3'b010,
        DISPENSE = 3'b011,
        CHANGE   = 3'b100,
        ERROR    = 3'b101

    } state_t;


endpackage