module datapath(
    input clk,
    input reset,
    input [15:0] DataIN, //Data In from RAM
    input [3:0] DR,SA,SB,
    input [3:0] FS,
    input [5:0] PC,
    input MB, MM, MW, MD, WP, RW,
    output [15:0] D_OUT,
    output [15:0] Address_OUT,
    output V, C, N, Z
); 

wire [15:0] RF_B, RF_A, Bus_A, Bus_B, Bus_D, PC_A, F_out;


//MUX for Data in 
//not too sure about this
assign PC_A <= WP ? {10'b0, PC} : D; 


register_file RF(
    .DA(DR),
    .AA(SA),
    .BA(BA),
    .FS(FS),
    .D(PC_A),
    .RW(RW),
    .clk(clk),
    .reset(reset),
    .A(RF_A),
    .B(RF_B)
);


//MUX B
assign Bus_B <= MB ? {8'b0,SA,SB} : Bus_B; 

//Mux MM

assign Address_OUT <= MM ? PC_A : Bus_A;


/*
input [3:0] FS, //functional select
    input [15:0] A, //Rs -> source
    input [15:0] B, //Rt -> transfer
    output reg [15:0] F, //Rd -> destination
    output reg V,
    output reg C,
    output reg N,
    output reg Z //Z flag*/

alu ALU(
    .FS(FS),
    .A(Bus_A),
    .B(Bus_B), 
    .F(F_out),
    .V(V),
    .C(C),
    .N(N)
    .Z(Z)
);

//mux D

assign Bus_D <= MD ? DataIN : F_out;

endmodule; 