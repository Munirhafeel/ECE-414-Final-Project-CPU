`timescale 1ps/1ps

module control_unit (
    input clk, reset,
    input [15:0] instruction, // instruction fetched from ROM
    input [15:0] bus_A // bus_A (Address-A Data)
    input Z, // Z Flag | Signal
    output [3:0] DR, SA, SB, // Instruction Register -> Destination Register, Source Register A, Source Register B
    // DX, AX, BX
    output [5:0] PC,
    // output MB, MM, MD, MW, RW, MP, // Control Word
    // Control Word
    output MB, MD, RW, MM, MW, // MUX-B, MUX-D, Register Write, MUX-M, Memory Write
    output FS // Function Select - ALU
);

wire [3:0] opcode; // instruction from instruction register
// control word from control unit
wire [1:0] PS; // PC Select
wire NS, IL; // Next State | Instruction Load

program_counter PC (
    .DR(), .SB().   // Source-B
    .D(),           // D-Bus (MUX-D) 0 = Load Immediate || 1 = Memory
    .PS(),          // PS Signal from Control Word (Control Logic)
    .clk(), .reset(),
    .address()
);

instruction_register IR (
    .instruction(),                 // instruction fetched from ROM
    .IL(),                          // instruction load
    .clk(), .reset(),
    .opcode(), .DR(), .SA(), .SB()  // Destination Register, Source Register A, Source Register B
);

control_logic CL (
    .state(), 
    .Z(), //zero from ALU
    .opcode(),
    .eoe(), //pseudo end of execution
    .next_state(),
    .FS(),
    .PS(),
    .IL(), 
    .MB(), 
    .MD(), 
    .RW(), 
    .MM(), 
    .MW(), 
    .WP(), // Write PC
);

control_state CS (
    .NS(),
    .clk(), .reset(),
    .next_state()
);

endmodule