module alu(
    input [3:0] FS, //functional select
    input reg [15:0] SR, //Rs -> source
    input reg [15:0] TR, //Rt -> transfer
    output reg [15:0] DR, //Rd -> destination
    output reg V,
    output reg C,
    output reg N,
    output reg Z //Z flag
);

always @ (FS or SR or TR or DR)
begin

    case(FS[2:0])
    4'h0: // 0000 -> ADD
        begin
            {C,DR} = SR + TR;
            V = (!DR[15] & SR[15] & TR[15]) | (DR[15] & !SR[15] & !TR[15]);
        end
    4'h1: // 0001 -> SUB
        begin
            {C,DR} = SR - TR;
            V = (!DR[15] & SR[15] & TR[15]) | (DR[15] & !SR[15] & !TR[15]);
        end
    4'h2: // 0010 -> AND
        begin
            DR <= SR & TR;
            C <= 0;
            V <= 0;
        end
    4'h3: // 0011 -> OR
        begin
            DR <= SR | TR;
            C <= 0;
            V <= 0;
        end
    4'h4: // 0100 -> XOR
        begin
            DR <= SR ^ TR;
            C <= 0;
            V <= 0;
        end
    4'h5: //0101 -> NOT
        begin
            DR <= ~SR;
            C <= 0;
            V <= 0;
        end
    4'h6: //0110 -> SLA
        begin
            DR <= SR <<< 1;
            C <= 0;
            V <= 0;
        end
    4'h0: //0111 -> SRA
        begin
            DR <= SR >>> 1;
            C <= 0;
            V <= 0;
        end
    default: 
        begin
            DR <= 0;
            C <= 0;
            V <= 0;
        end


    assign Z <= (DR == 16'b0) ? 1 : 0;
    assign N <= (DR[15] == 0) ? 1 : 0;
    
end
endmodule
