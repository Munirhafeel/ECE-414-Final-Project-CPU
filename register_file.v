`timescale 1ps/1ps

module register_file (
    // Instruction (DR, SA, SB - MSB = 0) or Control Word (DX, AX, BX - MSB = 1)
    input [3:0] DA, AA, BA, // Destination Address, A-Address, B-Address
    input [15:0] D, // D-Bus (Mux-D) - Data-Write to Destination Address
    input [3:0] FS, // Function Select
    input RW, // Register Write
    input clk, reset,
    output [15:0] A, B // A-Bus, B-Bus
);

reg [15:0] register[15:0]; // 16x16 register file

// BIZ (1011) - RA -> RD
// BNZ (1100) - RA -> RD
assign A = (FS == 4'b1011 || FS == 4'b1100) ? register[DA] : register[AA]; // destination register for others
assign B = register[BA];

always @ (posedge clk) begin
    // reset
    if (reset) begin
        register[0]  <= 16'b0;
        register[1]  <= 16'b0;
        register[2]  <= 16'b0;
        register[3]  <= 16'b0;
        register[4]  <= 16'b0;
        register[5]  <= 16'b0;
        register[6]  <= 16'b0;
        register[7]  <= 16'b0;
        register[8]  <= 16'b0;
        register[9]  <= 16'b0;
        register[10] <= 16'b0;
        register[11] <= 16'b0;
        register[12] <= 16'b0;
        register[13] <= 16'b0;
        register[14] <= 16'b0;
        register[15] <= 16'b0;
    end else begin
        // register write enable
        if (RW)
            register[DA] <= D;
    end
end

endmodule
