module instruction_register (
    input [15:0] instruction, // instruction fetched from ROM
    input IL, // instruction load
    input clk, reset,
    output reg [3:0] opcode, DR, SA, SB // Destination Register, Source Register A, Source Register B
);

reg [15:0] instruction_reg;

always @ (negedge clk) begin
    if (reset) begin
        instruction_reg <= 16'b0;
    end else begin
        if (IL) begin
            instruction_reg <= instruction;
        end else begin
            instruction_reg <= instruction_reg;
        end
    end

    opcode <= instruction_reg[15:12];
    DR     <= instruction_reg[11:8];
    SA     <= instruction_reg[7:4];
    SB     <= instruction_reg[3:0];
end

endmodule