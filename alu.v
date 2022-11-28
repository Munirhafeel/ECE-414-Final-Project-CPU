module alu(
    input [3:0] FS, //functional select
    input [15:0] A, //Rs -> source
    input [15:0] B, //Rt -> transfer
    output reg [15:0] F, //Rd -> destination
    output reg V,
    output reg C,
    output reg N,
    output reg Z //Z flag
);

always @ (FS or A or B or F)
begin

    case(FS[2:0])
    4'h0: // 0000 -> ADD
        begin
            {C,F} = A + B;
            V = (!F[15] & A[15] & B[15]) | (F[15] & !A[15] & !B[15]);
        end
    4'h1: // 0001 -> SUB
        begin
            {C,F} = A - B;
            V = (!F[15] & A[15] & B[15]) | (F[15] & !A[15] & !B[15]);
        end
    4'h2: // 0010 -> AND
        begin
            F <= A & B;
            C <= 0;
            V <= 0;
        end
    4'h3: // 0011 -> OR
        begin
            F <= A | B;
            C <= 0;
            V <= 0;
        end
    4'h4: // 0100 -> XOR
        begin
            F <= A ^ B;
            C <= 0;
            V <= 0;
        end
    4'h5: //0101 -> NOT
        begin
            F <= ~A;
            C <= 0;
            V <= 0;
        end
    4'h6: //0110 -> SLA
        begin
            F <= A <<< 1;
            C <= 0;
            V <= 0;
        end
    4'h0: //0111 -> AA
        begin
            F <= A >>> 1;
            C <= 0;
            V <= 0;
        end
    default: 
        begin
            F <= 0;
            C <= 0;
            V <= 0;
        end
    endcase

    assign Z <= (F == 16'b0) ? 1 : 0;
    assign N <= (F[15] == 0) ? 1 : 0;
    
end
endmodule