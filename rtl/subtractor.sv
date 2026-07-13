module subtractor #( 
    parameter WIDTH = 8
)(
    input  logic [WIDTH-1:0] credit,
    input  logic [WIDTH-1:0] price,
    output logic [WIDTH-1:0] change
);
    assign change = (credit >= price) ? (credit - price) : credit;
endmodule
