module alu(
    input [3:0] FS, //functional select
    input reg [15:0] SR, //Rs -> source
    input reg [15:0] TR, //Rt -> transfer
    output reg [15:0] DR, //Rd -> destiantion
    output reg Z //Z flag
);

always @ (*) //combinational logic
begin
    case(FS)
    4'h0: DR <= SR + TR; // 0000 -> ADD
    4'h1: DR <= SR - TR; // 0001 -> SUB
    4'h2: DR <= SR & TR; // 0010 -> AND
    4'h3: DR <= SR | TR; // 0011 -> OR
    4'h4: DR <= SR ^ TR; // 0100 -> XOR
    4'h5: DR <= ~ SR; //0101 -> NOT
    4'h6: DR <= SR <<< 1; //0110 -> SLA
    4'h7: DR <= SR >>> 1; //0111 -> SRA
    4'h8: DR <= SR; //1000 -> LI
    4'h9: DR <= SR; // 1001 -> LW
    4'hA: DR <= TR; //1010 -> SW
    4'hB: DR <= SR; //1011 -> BIZ
    4'hC: DR <= SR; //1100 -> BNZ
    4'hD: DR <= SR; //1101 -> JAL
    4'hE: DR <= DR; //1110 -> JMP
    4'hF: DR <= SR; //1111 -> JR
    default: DR <=DR; //EOE

    assign Z <= (DR == 16'b0) ? 1 : 0;
    
end
endmodule