`timescale 1ns/1ps

module control_logic (
    input state, 
    input V, C, N, Z, // zero from ALU
    input [3:0] opcode,
    input [3:0] eoe, // pseudo end of execution
    output reg next_state,
    output reg [3:0] FS,
    output reg [1:0] PS,
    output reg IL, 
    output reg MB, 
    output reg MD, 
    output reg RW, 
    output reg MM, 
    output reg MW,
);

always @(*) 
    begin
        next_state <= state;
        FS <= opcode;
        if (state == 1'b0) // INF
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
        else if (state == 1'b1) // EX0
            begin
                IL <= 1'b0;
                if (FS[3] == 1'b0) // ADD through SRA - ALU Microoperations
                    begin
                        PS <= 2'b01;
                        MB <= 1'b0;
                        MD <= 1'b0;
                        RW <= 1'b1;
                        MM <= 1'b0;
                        MW <= 1'b0;
                    end
                else if (FS[3] == 1'b1)
                    begin
                        case (FS[2:0])
                            3'b000: // LI - load immediate
                                begin
                                    PS <= 2'b01;
                                    MB <= 1'b1;
                                    MD <= 1'b0;
                                    RW <= 1'b1;
                                    MM <= 1'b0;
                                    MW <= 1'b0;
                                end
                            3'b001: // LW - load word - memory
                                begin
                                    PS <= 2'b01;
                                    MB <= 1'b0;
                                    MD <= 1'b1;
                                    RW <= 1'b1;
                                    MM <= 1'b0;
                                    MW <= 1'b0;
                                end
                            3'b010: // SW - store word
                                begin
                                    PS <= 2'b01;
                                    MB <= 1'b0;
                                    MD <= 1'b0;
                                    RW <= 1'b0;
                                    MM <= 1'b0;
                                    MW <= 1'b1;
                                end
                            3'b011: // BIZ - branch if zero
                                begin
                                    PS <= Z ? 1'b10 : 1'b01;
                                    MB <= 1'b0;
                                    MD <= 1'b0;
                                    RW <= 1'b0;
                                    MM <= 1'b0;
                                    MW <= 1'b0;
                                end
                            3'b100: // BNZ - branch if not zero
                                begin
                                    PS <= Z ? 1'b01 : 1'b10;
                                    MB <= 1'b0;
                                    MD <= 1'b0;
                                    RW <= 1'b0;
                                    MM <= 1'b0;
                                    MW <= 1'b0;
                                end
                            3'b101: // JAL - jump and link
                                begin 
                                    PS <= 2'b10;
                                    MB <= 1'b0;
                                    MD <= 1'b0;
                                    RW <= 1'b1;
                                    MM <= 1'b1;
                                    MW <= 1'b0;
                                end
                            3'b110: // JMP - jump
                                begin
                                    PS <= 2'b10;
                                    MB <= 1'b0;
                                    MD <= 1'b0;
                                    RW <= 1'b0;
                                    MM <= 1'b0;
                                    MW <= 1'b0;
                                    WP <= 1'b0;
                                end
                            3'b111: // JR - jump return
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
                                    else if (eoe == 4'b1111) // end of execution signal
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
                        endcase
                    end
            end
    end
endmodule