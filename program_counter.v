`timescale 1ps/1ps

module program_counter (
    input [3:0] SA, SB, // Source-A Source-B
    input [5:0] A_bus, // Address - Bus A
    input [1:0] PS, // PS Signal from Control Word (Control Logic)
    input clk, reset,
    output reg [5:0] PC; // program counter register
);

always @ (posedge clk) begin
    if (reset) begin
        PC <= 6'b0;
    end else begin
        case (PS)
        2'b00:
        begin
            PC <= PC; // hold PC value
        end
        2'b01:
        begin
            PC <= PC + 1'b1; // next instruction
        end
        2'b10:
        begin
            PC <= PC + 1'b1 + ({SA[1:0], SB}); // offset
        end
        2'b11:
        begin
            PC <= A_bus;
        end
        endcase
    end
    address <= PC;
end   

endmodule