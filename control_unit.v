`timescale 1ps/1ps

module control_unit (
    input clk, reset,
    input [15:0] instruction,   // instruction fetched from ROM
    input [15:0] A_bus          // A Bus (Address-A Data)
    input Z,                    // Z Flag | Signal
    output [3:0] DR, SA, SB,    // Instruction Register -> Destination Register, Source Register A, Source Register B
    output [5:0] PC,
    // Control Word
    output MB, MD, RW, MM, MW,  // MUX-B, MUX-D, Register Write, MUX-M, Memory Write
    output [3:0] FS             // Function Select - ALU
);

wire [3:0] opcode_bus;
// control word from control unit
wire [1:0] PS_bus;      // PC Select
wire NS_bus, pstate_bus, IL_bus;    // Next State | Instruction Load

program_counter PC (
    .SA(SA), .SB(SB),
    .A_bus(A_bus[5:0]),
    .PS(PS_bus),
    .clk(clk), .reset(reset),
    .PC(PC)
);

instruction_register IR (
    .instruction(instruction),
    .IL(IL_bus),
    .clk(clk), .reset(reset),
    .opcode(opcode_bus), .DR(DR), .SA(SA), .SB(SB)
);

control_logic CL (
    .state(pstate_bus),
    .Z(Z),
    .opcode(opcode_bus),
    .eoe(instruction[11:8]),
    .next_state(NS_bus),
    .FS(FS),
    .PS(PS_bus),
    .IL(IL_bus),
    .MB(MB), .MD(MD), .RW(RW), .MM(MM), .MW(MW)
);

control_state CS (
    .NS(NS_bus),
    .clk(clk), .reset(clk),
    .next_state(pstate_bus)
);

endmodule