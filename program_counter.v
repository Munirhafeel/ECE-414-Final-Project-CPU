module program_counter(
    input DR, SB, // Source-B
    input D, // D-Bus (MUX-D) 0 = Load Immediate || 1 = Memory
    input [1:0] PS, // PS Signal from Control Word (Control Logic)
    input clk, reset,
    output [15:0] address;
);

reg [15:0] PC;

// sign extend SB, DR

always @ (posedge clk) begin
    if (reset) begin
        PC <= 16'b0'
    end else begin
        case (PS)
        2'b00:
        begin
            PC <= PC; // hold PC value
        end
        2'b01:
        begin
            PC <= PC + 1'b1; //
        end
        2'b10:
        begin
            PC <= PC + ; // 
        end
        2'b11:
        begin
            PC <= PC; // 
        end
        endcase
    end
    address <= PC;
end   

endmodule