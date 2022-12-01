module datapath (
    input clk, reset,
    input [15:0] data_in, // data in from RAM
    input [5:0] PC, // Address to RAM
    input [3:0] DR, SA, SB,
    input MB, MD, RW, MM, MW,
    input [3:0] FS,
    output [15:0] data_out, // data to RAM
    output [15:0] address_out, // RA - Address A
    output V, C, N, Z
); 

wire [15:0] A_bus, B_bus, MB_bus, F_Bus, D_Bus, M_Bus;

register_file RF (
    .DA(DR), .AA(SA), .BA(BA),
    .D(M_Bus),
    .FS(FS),
    .RW(RW),
    .clk(clk), .reset(reset),
    .A(A_bus), .B(B_bus)
);

//MUX B
assign MB_bus = MB ? {8'b0,SA,SB} : Bus_B;

alu ALU (
    .FS(FS),
    .A(Bus_A),
    .B(MB_bus),
    .data_out(F_Bus),
    .V(V),
    .C(C),
    .N(N)
    .Z(Z)
);

// MUX D
assign D_Bus = MD ? data_in : F_Bus;

//Mux MM
assign M_Bus = MM ? ({10'b0,PC} + 1'b1) : D_Bus;

assign data_out = MB_bus;

assign address_out = Bus_A;

endmodule; 