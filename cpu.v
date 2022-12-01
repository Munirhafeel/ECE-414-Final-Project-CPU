`timescale 1ns/1ps

module CPU (
    input clk, reset,
    input [15:0] data_from_rom,
    inout [15:0] data_ram,
    output [5:0] address_to_rom,
    output enable_to_rom,
    output [5:0] address_to_ram,
    output write_enable_to_ram,
    output read_enable_to_ram,
    output enable_ram_read  // enable signal for RAM read and UART module (end of execution - eoe)
                            // this signal indicates that all operations of the CPU are finished
);

wire [15:0] address_bus;
// control unit
wire [3:0] DR_bus, SA_bus, SB_bus;
wire MB_bus, MD_bus, RW_bus, MM_bus;
wire [3:0] FS_bus;
wire [5:0] PC_bus;
// datapath
wire V_bus, C_bus, N_bus, Z_bus;

assign address_to_rom = PC_bus;
assign enable_to_rom = 1'b1;
assign read_enable_to_ram = (FS_bus == 4'b1001) ? 1'b1 : 1'b0;              // opcode -> load word
assign enable_ram_read = ({FS_bus,DR_bus} == 8'b11111111) ? 1'b1 : 1'b0;    // eof signal
assign address_to_ram = address_bus[5:0];

control_unit control (
    .clk(clk), .reset(reset),
    .instruction(data_from_rom),
    .A_bus(address_bus),
    .V(V_bus), .C(C_bus), .N(N_bus), .Z(Z_bus),
    .DR(DR_bus), .SA(SA_bus), .SB(SB_bus),
    .PC(PC_bus),
    .MB(MB_bus), .MD(MD_bus), .RW(RW_bus), .MM(MM_bus), .MW(write_enable_to_ram),
    .FS(FS_bus)
);

datapath data_path (
    .clk(clk), .reset(reset),
    .data_in(data_ram),
    .PC(PC_bus),
    .DR(DR_bus), .SA(SA_bus), .SB(SB_bus),
    .MB(MB_bus), .MD(MD_bus), .RW(RW_bus), .MM(MM_bus),
    .FS(FS_bus),
    .data_out(data_ram),
    .address_out(address_bus),
    .V(V_bus), .C(C_bus), .N(N_bus), .Z(Z_bus)
);

endmodule
