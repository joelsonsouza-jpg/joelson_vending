/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : X-2025.06-SP2
// Date      : Wed Jul 22 16:29:05 2026
/////////////////////////////////////////////////////////////


module control_unit_WIDTH8 ( clk, rst, coin_in, confirm, cancel, can_sell, 
        change, credit, credit_load, mem_read, mem_write, dispense, error, 
        change_out, state_out );
  input [1:0] coin_in;
  input [7:0] change;
  input [7:0] credit;
  output [7:0] change_out;
  output [2:0] state_out;
  input clk, rst, confirm, cancel, can_sell;
  output credit_load, mem_read, mem_write, dispense, error;
  wire   dispense, mem_ready_q, n22, n34, n35, n36, n37, n38, n39, n40, n41,
         n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16
;
  wire   [2:0] next_state;
  assign mem_write = dispense;

  DFFARX1_RVT \state_reg[0]  ( .D(next_state[0]), .CLK(clk), .RSTB(n22), .Q(
        state_out[0]), .QN(n15) );
  DFFARX1_RVT \state_reg[2]  ( .D(next_state[2]), .CLK(clk), .RSTB(n22), .Q(
        state_out[2]), .QN(n14) );
  DFFARX1_RVT \state_reg[1]  ( .D(next_state[1]), .CLK(clk), .RSTB(n22), .Q(
        state_out[1]), .QN(n16) );
  DFFARX1_RVT mem_ready_q_reg ( .D(mem_read), .CLK(clk), .RSTB(n22), .Q(
        mem_ready_q) );
  DFFARX1_RVT \change_r_reg[7]  ( .D(n41), .CLK(clk), .RSTB(n22), .Q(
        change_out[7]) );
  DFFARX1_RVT \change_r_reg[6]  ( .D(n40), .CLK(clk), .RSTB(n22), .Q(
        change_out[6]) );
  DFFARX1_RVT \change_r_reg[5]  ( .D(n39), .CLK(clk), .RSTB(n22), .Q(
        change_out[5]) );
  DFFARX1_RVT \change_r_reg[4]  ( .D(n38), .CLK(clk), .RSTB(n22), .Q(
        change_out[4]) );
  DFFARX1_RVT \change_r_reg[3]  ( .D(n37), .CLK(clk), .RSTB(n22), .Q(
        change_out[3]) );
  DFFARX1_RVT \change_r_reg[2]  ( .D(n36), .CLK(clk), .RSTB(n22), .Q(
        change_out[2]) );
  DFFARX1_RVT \change_r_reg[1]  ( .D(n35), .CLK(clk), .RSTB(n22), .Q(
        change_out[1]) );
  DFFARX1_RVT \change_r_reg[0]  ( .D(n34), .CLK(clk), .RSTB(n22), .Q(
        change_out[0]) );
  INVX2_RVT U3 ( .A(rst), .Y(n22) );
  NAND3X0_RVT U4 ( .A1(state_out[1]), .A2(n15), .A3(n14), .Y(n8) );
  INVX0_RVT U5 ( .A(n8), .Y(mem_read) );
  NAND3X0_RVT U6 ( .A1(state_out[0]), .A2(state_out[2]), .A3(n16), .Y(n5) );
  INVX0_RVT U7 ( .A(n5), .Y(error) );
  NAND3X0_RVT U8 ( .A1(state_out[1]), .A2(state_out[0]), .A3(n14), .Y(n6) );
  INVX0_RVT U9 ( .A(n6), .Y(dispense) );
  OA222X1_RVT U10 ( .A1(n16), .A2(mem_ready_q), .A3(n16), .A4(n15), .A5(
        state_out[0]), .A6(n14), .Y(n3) );
  NAND2X0_RVT U11 ( .A1(n15), .A2(n16), .Y(n1) );
  OR3X1_RVT U12 ( .A1(coin_in[0]), .A2(coin_in[1]), .A3(n1), .Y(n2) );
  NAND2X0_RVT U13 ( .A1(cancel), .A2(n1), .Y(n10) );
  NAND3X0_RVT U14 ( .A1(state_out[0]), .A2(confirm), .A3(n14), .Y(n7) );
  NAND4X0_RVT U15 ( .A1(n3), .A2(n2), .A3(n10), .A4(n7), .Y(n11) );
  INVX0_RVT U16 ( .A(n11), .Y(next_state[0]) );
  NAND3X0_RVT U17 ( .A1(state_out[1]), .A2(mem_ready_q), .A3(n14), .Y(n4) );
  NAND4X0_RVT U18 ( .A1(n10), .A2(n6), .A3(n5), .A4(n4), .Y(next_state[2]) );
  OA221X1_RVT U19 ( .A1(state_out[0]), .A2(state_out[2]), .A3(n15), .A4(n14), 
        .A5(n16), .Y(credit_load) );
  OAI22X1_RVT U20 ( .A1(mem_ready_q), .A2(n8), .A3(state_out[1]), .A4(n7), .Y(
        n9) );
  AND2X1_RVT U21 ( .A1(n10), .A2(n9), .Y(next_state[1]) );
  NAND2X0_RVT U22 ( .A1(n11), .A2(next_state[2]), .Y(n12) );
  INVX0_RVT U23 ( .A(n12), .Y(n13) );
  AO22X1_RVT U24 ( .A1(n13), .A2(credit[7]), .A3(n12), .A4(change_out[7]), .Y(
        n41) );
  AO22X1_RVT U25 ( .A1(n13), .A2(credit[6]), .A3(n12), .A4(change_out[6]), .Y(
        n40) );
  AO22X1_RVT U26 ( .A1(n13), .A2(credit[5]), .A3(n12), .A4(change_out[5]), .Y(
        n39) );
  AO22X1_RVT U27 ( .A1(n13), .A2(credit[4]), .A3(n12), .A4(change_out[4]), .Y(
        n38) );
  AO22X1_RVT U28 ( .A1(n13), .A2(credit[3]), .A3(n12), .A4(change_out[3]), .Y(
        n37) );
  AO22X1_RVT U29 ( .A1(n13), .A2(credit[2]), .A3(n12), .A4(change_out[2]), .Y(
        n36) );
  AO22X1_RVT U30 ( .A1(n13), .A2(credit[1]), .A3(n12), .A4(change_out[1]), .Y(
        n35) );
  AO22X1_RVT U31 ( .A1(n13), .A2(credit[0]), .A3(n12), .A4(change_out[0]), .Y(
        n34) );
endmodule


module credit_reg_WIDTH8 ( clk, rst, cancel, coin_in, credit_load, state, 
        credit );
  input [1:0] coin_in;
  input [2:0] state;
  output [7:0] credit;
  input clk, rst, cancel, credit_load;
  wire   n9, n10, n11, n12, n13, n14, n15, n16, n17, \intadd_0/B[1] ,
         \intadd_0/B[0] , \intadd_0/CI , \intadd_0/SUM[2] , \intadd_0/SUM[1] ,
         \intadd_0/SUM[0] , \intadd_0/n3 , \intadd_0/n2 , \intadd_0/n1 , n1,
         n2, n3, n4, n5, n6, n7, n8, n18, n19, n20, n21, n22, n23, n24, n25,
         n26, n27, n28, n29, n30, n31, n32, n33, n34, n35;

  DFFARX1_RVT \credit_reg[7]  ( .D(n10), .CLK(clk), .RSTB(n9), .Q(credit[7])
         );
  DFFARX1_RVT \credit_reg[6]  ( .D(n11), .CLK(clk), .RSTB(n9), .Q(credit[6]), 
        .QN(n35) );
  DFFARX1_RVT \credit_reg[5]  ( .D(n12), .CLK(clk), .RSTB(n9), .Q(credit[5])
         );
  DFFARX1_RVT \credit_reg[4]  ( .D(n13), .CLK(clk), .RSTB(n9), .Q(credit[4])
         );
  DFFARX1_RVT \credit_reg[3]  ( .D(n14), .CLK(clk), .RSTB(n9), .Q(credit[3])
         );
  DFFARX1_RVT \credit_reg[2]  ( .D(n15), .CLK(clk), .RSTB(n9), .Q(credit[2])
         );
  DFFARX1_RVT \credit_reg[1]  ( .D(n16), .CLK(clk), .RSTB(n9), .Q(credit[1])
         );
  DFFARX1_RVT \credit_reg[0]  ( .D(n17), .CLK(clk), .RSTB(n9), .Q(credit[0])
         );
  FADDX1_RVT \intadd_0/U4  ( .A(\intadd_0/B[0] ), .B(credit[3]), .CI(
        \intadd_0/CI ), .CO(\intadd_0/n3 ), .S(\intadd_0/SUM[0] ) );
  FADDX1_RVT \intadd_0/U3  ( .A(\intadd_0/B[1] ), .B(credit[4]), .CI(
        \intadd_0/n3 ), .CO(\intadd_0/n2 ), .S(\intadd_0/SUM[1] ) );
  FADDX1_RVT \intadd_0/U2  ( .A(coin_in[1]), .B(credit[5]), .CI(\intadd_0/n2 ), 
        .CO(\intadd_0/n1 ), .S(\intadd_0/SUM[2] ) );
  INVX2_RVT U3 ( .A(rst), .Y(n9) );
  INVX0_RVT U4 ( .A(coin_in[0]), .Y(n24) );
  OR2X1_RVT U5 ( .A1(n24), .A2(coin_in[1]), .Y(n26) );
  INVX0_RVT U6 ( .A(n26), .Y(\intadd_0/B[0] ) );
  NAND2X0_RVT U7 ( .A1(coin_in[1]), .A2(coin_in[0]), .Y(n27) );
  AO22X1_RVT U8 ( .A1(coin_in[1]), .A2(n24), .A3(\intadd_0/B[0] ), .A4(
        credit[0]), .Y(n19) );
  NAND2X0_RVT U9 ( .A1(n19), .A2(credit[1]), .Y(n18) );
  NAND2X0_RVT U10 ( .A1(n27), .A2(n18), .Y(n22) );
  NAND2X0_RVT U11 ( .A1(credit[2]), .A2(n22), .Y(n21) );
  INVX0_RVT U12 ( .A(n21), .Y(\intadd_0/CI ) );
  INVX0_RVT U13 ( .A(cancel), .Y(n3) );
  NAND2X0_RVT U14 ( .A1(state[0]), .A2(credit_load), .Y(n1) );
  NOR4X1_RVT U15 ( .A1(state[2]), .A2(cancel), .A3(state[1]), .A4(n1), .Y(n32)
         );
  INVX0_RVT U16 ( .A(n32), .Y(n2) );
  AND2X1_RVT U17 ( .A1(n3), .A2(n2), .Y(n7) );
  INVX0_RVT U18 ( .A(state[1]), .Y(n4) );
  NAND3X0_RVT U19 ( .A1(credit_load), .A2(state[2]), .A3(n4), .Y(n5) );
  OR2X1_RVT U20 ( .A1(n5), .A2(state[0]), .Y(n6) );
  AND2X1_RVT U21 ( .A1(n7), .A2(n6), .Y(n34) );
  HADDX1_RVT U22 ( .A0(credit[0]), .B0(\intadd_0/B[0] ), .SO(n8) );
  AO22X1_RVT U23 ( .A1(credit[0]), .A2(n34), .A3(n8), .A4(n32), .Y(n17) );
  OA21X1_RVT U24 ( .A1(n19), .A2(credit[1]), .A3(n18), .Y(n20) );
  AO22X1_RVT U25 ( .A1(n32), .A2(n20), .A3(credit[1]), .A4(n34), .Y(n16) );
  OA21X1_RVT U26 ( .A1(credit[2]), .A2(n22), .A3(n21), .Y(n23) );
  AO22X1_RVT U27 ( .A1(n32), .A2(n23), .A3(credit[2]), .A4(n34), .Y(n15) );
  AO22X1_RVT U28 ( .A1(n32), .A2(\intadd_0/SUM[0] ), .A3(n34), .A4(credit[3]), 
        .Y(n14) );
  NAND2X0_RVT U29 ( .A1(coin_in[1]), .A2(n24), .Y(n25) );
  NAND2X0_RVT U30 ( .A1(n26), .A2(n25), .Y(\intadd_0/B[1] ) );
  AO22X1_RVT U31 ( .A1(n32), .A2(\intadd_0/SUM[1] ), .A3(n34), .A4(credit[4]), 
        .Y(n13) );
  AO22X1_RVT U32 ( .A1(n32), .A2(\intadd_0/SUM[2] ), .A3(n34), .A4(credit[5]), 
        .Y(n12) );
  INVX0_RVT U33 ( .A(n27), .Y(n30) );
  AO22X1_RVT U34 ( .A1(n30), .A2(n35), .A3(n27), .A4(credit[6]), .Y(n28) );
  HADDX1_RVT U35 ( .A0(\intadd_0/n1 ), .B0(n28), .SO(n29) );
  AO22X1_RVT U36 ( .A1(n32), .A2(n29), .A3(n34), .A4(credit[6]), .Y(n11) );
  AO222X1_RVT U37 ( .A1(n30), .A2(credit[6]), .A3(n30), .A4(\intadd_0/n1 ), 
        .A5(credit[6]), .A6(\intadd_0/n1 ), .Y(n31) );
  HADDX1_RVT U38 ( .A0(credit[7]), .B0(n31), .SO(n33) );
  AO22X1_RVT U39 ( .A1(credit[7]), .A2(n34), .A3(n33), .A4(n32), .Y(n10) );
endmodule


module vending_top ( clk, rst, coin_in, sel_item, confirm, cancel, dispense, 
        change_out, error, display, state_out );
  input [1:0] coin_in;
  input [1:0] sel_item;
  output [7:0] change_out;
  output [7:0] display;
  output [2:0] state_out;
  input clk, rst, confirm, cancel;
  output dispense, error;
  wire   credit_load, net840, net841, net842, net843, net844, net845, net846,
         net847, net848;

  control_unit_WIDTH8 u_control ( .clk(clk), .rst(rst), .coin_in(coin_in), 
        .confirm(confirm), .cancel(cancel), .can_sell(net840), .change({net841, 
        net842, net843, net844, net845, net846, net847, net848}), .credit(
        display), .credit_load(credit_load), .dispense(dispense), .error(error), .change_out(change_out), .state_out(state_out) );
  credit_reg_WIDTH8 u_credit ( .clk(clk), .rst(rst), .cancel(cancel), 
        .coin_in(coin_in), .credit_load(credit_load), .state(state_out), 
        .credit(display) );
endmodule

