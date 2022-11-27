`timescale 1ns/1ps

module control_logic(
    input state, 
    input Z, //zero from ALU
    input [3:0] opcode,
    input [3:0] eoe, //pseudo end of execution
    output reg next_state,
    output reg [3:0] FS,
    output reg [1:0] PS,
    output reg IL, 
    output reg MB, 
    output reg MD, 
    output reg RW, 
    output reg MM, 
    output reg MW, 
    output reg WP, //Write PC

);

always @(*) 
    begin
        next_state <= state;
        FS <= opcode;
        if (state == 1'b0) //INF
            begin
                IL <= 1'b1;
                PS <= 2'b00;
                MB <= 1'b0;
                MD <= 1'b0;
                RW <= 1'b0;
                MM <= 1'b1;
                MW <= 1'b0;
                MW <= 1'b0;
                WP <= 1'b0;
            end
        else if (state == 1'b1) //EX0
            begin
                IL <= 1'b0;
                if (FS[3] == 1'b0) //ADD through SRA
                    begin
                        PS <= 2'b01;
                        MB <= 1'b0;
                        MD <= 1'b0;
                        RW <= 1'b1;
                        MM <= 1'b0;
                        MW <= 1'b0;
                        WP <= 1'b0;
                    end
                else if (FS[3]==1'b1)
                    begin
                        case (FS[2:0])
                            3'b000: //LI
                                begin
                                    PS <= 2'b01;
                                    MB <= 1'b1;
                                    MD <= 1'b0;
                                    RW <= 1'b1;
                                    MM <= 1'b0;
                                    MW <= 1'b0;
                                    WP <= 1'b0;
                                end
                            3'b001: //LW
                                begin
                                    PS <= 2'b01;
                                    MB <= 1'b0;
                                    MD <= 1'b1;
                                    RW <= 1'b1;
                                    MM <= 1'b0;
                                    MW <= 1'b0;
                                    WP <= 1'b0;
                                end
                            3'b010: //SW
                                begin
                                    PS <= 2'b01;
                                    MB <= 1'b0;
                                    MD <= 1'b0;
                                    RW <= 1'b0;
                                    MM <= 1'b0;
                                    MW <= 1'b1;
                                    WP <= 1'b0;
                                end
                            3'b011: //BIZ
                                begin
                                    PS <= Z? 1'b10:1'b01;
                                    MB <= 1'b0;
                                    MD <= 1'b0;
                                    RW <= 1'b0;
                                    MM <= 1'b0;
                                    MW <= 1'b0;
                                    WP <= 1'b0;
                                end
                            3'b100: //BNZ
                                begin
                                    PS <= Z? 1'b01:1'b10;
                                    MB <= 1'b0;
                                    MD <= 1'b0;
                                    RW <= 1'b0;
                                    MM <= 1'b0;
                                    MW <= 1'b0;
                                    WP <= 1'b0;
                                end
                            3'b101: //JAL
                                begin 
                                    PS <= 2'b01;
                                    MB <= 1'b0;
                                    MD <= 1'b0;
                                    RW <= 1'b1;
                                    MM <= 1'b0;
                                    MW <= 1'b0;
                                    WP <= 1'b1;
                                end
                            3'b110: //JMP
                                begin
                                    PS <= 2'b01;
                                    MB <= 1'b0;
                                    MD <= 1'b0;
                                    RW <= 1'b0;
                                    MM <= 1'b0;
                                    MW <= 1'b0;
                                    WP <= 1'b0;
                                end
                            3'b111: //JR
                                begin
                                    if (eoe == 4'b0000)
                                        begin
                                            PS <= 2'b11;
                                            MB <= 1'b0;
                                            MD <= 1'b0;
                                            RW <= 1'b0;
                                            MM <= 1'b0;
                                            MW <= 1'b0;
                                            WP <= 1'b0;
                                        end
                                    else if (eoe == 4'b1111)
                                        begin
                                            PS <= 2'b00;
                                            MB <= 1'b0;
                                            MD <= 1'b0;
                                            RW <= 1'b0;
                                            MM <= 1'b0;
                                            MW <= 1'b0;
                                            WP <= 1'b0;
                                        end
                                end
                    end
            end
        
    end
endmodule