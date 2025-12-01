//1.
`timescale 1ns/1ns
module ALU(
    input [31:0]A,
    input [31:0]B,
    input [3:0]alu_control,
    output reg[31:0] resultado,
    output zero
    );
//2.Componentes internos NA
//3.Assing, bloques secuencialess

assign zero = !(A - B);

//initial, always - no assigns, solo reg
always@(*)
begin
    case (alu_control)
        4'b0000: resultado = A & B;     //AND
        //4'b0001: resultado = ;        
        4'b0010: resultado = A + B;     //ADD
        4'b0001: resultado = A | B;     //OR
        //4'b0100: resultado = A ^ B;
        //4'b0101: resultado = A == B;
        4'b0110: resultado = A - B;     //SUB
        4'b0111: resultado = (A < B) ? 32'd1 : 32'd0; 
        4'b0011: resultado = A ^ B;     // XOR / XORI
    endcase
end
endmodule