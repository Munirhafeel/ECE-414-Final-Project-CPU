module alu(
    input [3:0] FS, // Function Select
    input [15:0] A, // A-Bus -> Source-A - Register A
    input [15:0] B, // B-Bus -> Source-B - Register B
    output reg [15:0] data_out, // F-Bus - Output - Result
    output reg V, // V Flag
    output reg C, // C Flag -> overflow
    output reg N, // N Flag -> negative
    output reg Z  // Z Flag -> zero
);

parameter ADD = 4'h0;
parameter SUB = 4'h1;
parameter AND = 4'h2;
parameter OR  = 4'h3;
parameter XOR = 4'h4;
parameter NOT = 4'h5;
parameter SLA = 4'h6;
parameter SRA = 4'h7;

always @ (FS or A or B or data_out)
begin

    case(FS[3:0])
    ADD:
        begin
            {C,data_out} <= A + B;
            V = (!data_out[15] & A[15] & B[15]) | (data_out[15] & !A[15] & !B[15]);
        end
    SUB:
        begin
            {C,data_out} <= A - B;
            V = (!data_out[15] & A[15] & B[15]) | (data_out[15] & !A[15] & !B[15]);
        end
    AND:
        begin
            data_out <= A & B;
            C <= 0;
            V = 0;
        end
    OR:
        begin
            data_out <= A | B;
            C <= 0;
            V = 0;
        end
    XOR:
        begin
            data_out <= A ^ B;
            C <= 0;
            V = 0;
        end
    NOT:
        begin
            data_out <= ~A;
            C <= 0;
            V = 0;
        end
    SLA:
        begin
            data_out <= A <<< 1;
            C <= 0;
            V = 0;
        end
    SRA:
        begin
            data_out <= A >>> 1;
            C <= 0;
            V = 0;
        end
    default: 
        begin
            data_out <= 0;
            C <= 0;
            V = 0;
        end
    endcase

    Z <= (data_out == 16'b0) ? 1'b1 : 1'b0;
    N <= (data_out[15] == 0) ? 1'b1 : 1'b0;
    
end
endmodule