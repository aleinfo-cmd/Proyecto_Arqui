`timescale 1ns/1ns
module ALUcontrol (
    input [5:0]instruccion_FNC,
    input [1:0]ALUop,
    output reg [3:0] sal_alu_control
);
    
always @(*) 
begin
    case(ALUop)
        2'b00: sal_alu_control= 4'b0010; // lw sw hacen add
        2'b01: sal_alu_control= 4'b0110; // beq para restar y ver si son iguales si dan 0
        2'b11: //I
            begin
            case(instruccion_FNC)
            6'b001000: sal_alu_control = 4'b0010; // ADDI
            6'b001100: sal_alu_control = 4'b0000; // ANDI
            6'b001101: sal_alu_control = 4'b0001; // ORI
            6'b001110: sal_alu_control = 4'b0011; // XORI
            6'b001010: sal_alu_control = 4'b0111; // SLTI
            endcase
            end
        2'b10: 
        begin // Tipo R
            case(instruccion_FNC)
                6'b100000: sal_alu_control = 4'b0010; // ADD
                6'b100010: sal_alu_control = 4'b0110; // SUB
                6'b100100: sal_alu_control = 4'b0000; // AND
                6'b100101: sal_alu_control = 4'b0001; // OR
                6'b100110: sal_alu_control = 4'b0011; // XOR
                6'b101010: sal_alu_control = 4'b0111; // SLT
                default:   sal_alu_control = 4'b0010;
            endcase

        end
            
        default: sal_alu_control = 4'b0010; // ADD por default si ninguna 
    endcase
end
endmodule