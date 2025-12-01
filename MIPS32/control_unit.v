`timescale 1ns/1ns
module control (
    input [5:0]opcode, //instruccion del [31:26]
    output reg RegDst,
    output reg Jump,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg [1:0] ALUop,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite
);


always@(*)
begin
    case(opcode)
        6'b000000: 
        begin // Tipo R
            RegDst = 1;    //usar rd
            Jump = 0;
            Branch = 0;
            MemRead = 0;
            MemtoReg = 0;
            ALUop = 2'b10;
            MemWrite = 0;
            ALUSrc = 0;
            RegWrite = 1;
        end

        6'b001000:
        begin // ADDI
            RegDst = 0;    //usar rt para guardar   
            Jump = 0;
            Branch = 0;
            MemRead = 0;
            MemtoReg = 0;
            ALUop = 2'b00;
            MemWrite = 0;
            ALUSrc = 1; //tomar los 16 bits del inmediato
            RegWrite = 1;//escribir resultado en BR
        end
        
        6'b100011:
        begin // lw
            RegDst = 0;
            Jump = 0;
            Branch = 0;
            MemRead = 1;
            MemtoReg = 1;
            ALUop = 2'b00;
            MemWrite = 0;
            ALUSrc = 1;
            RegWrite = 1;
        end
        
        6'b101011:
        begin // sw
            RegDst = 0;
            Jump = 0;
            Branch = 0;
            MemRead = 0;
            MemtoReg = 0;
            ALUop = 2'b00;
            MemWrite = 1;
            ALUSrc = 1;
            RegWrite = 0;
        end
        
        6'b000100:
        begin // beq    -   branch on equal, si los registros son iguales, salta a otro lado, sino se sigue con la sig instruccion que diga el PC
            RegDst = 0;
            Jump = 0;
            Branch = 1;
            MemRead = 0;
            MemtoReg = 0;
            ALUop = 2'b01;
            MemWrite = 0;
            ALUSrc = 0;
            RegWrite = 0;
        end

        6'b000010:
	begin
	    RegDst = 0;
        Jump = 1;
        Branch = 0;
        MemRead = 0;
        MemtoReg = 0;
        ALUop = 2'b01;
        MemWrite = 0;
        ALUSrc = 0;
        RegWrite = 0;
end
    6'b001100: begin // ANDI
        RegDst = 0; ALUSrc = 1; ALUop = 2'b11; RegWrite = 1;
    end
    6'b001101: begin // ORI
        RegDst = 0; ALUSrc = 1; ALUop = 2'b11; RegWrite = 1;
    end
    6'b001110: begin // XORI
        RegDst = 0; ALUSrc = 1; ALUop = 2'b11; RegWrite = 1;
    end
    6'b001010: begin // SLTI
        RegDst = 0; ALUSrc = 1; ALUop = 2'b11; RegWrite = 1;
    end

    endcase
end
    
endmodule