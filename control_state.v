`timescale 1ps/1ps

module control_state(
    input NS, // NS (next-state) control word
    input clk, reset,
    output reg next_state
);

always @ (posedge clk) begin
    if (reset)
        next_state <= 1'b0;
    else
        next_state <= ~NS;
end

endmodule