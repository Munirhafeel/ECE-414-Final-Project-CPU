module control_state(
    input clk,
    input clear,
    input fed_state,
    output state

);

always @ (posedge clk)
begin
    if (clear)
        state <= 1'b0;
    else
        state <= fed_state;
end


//boilerplate