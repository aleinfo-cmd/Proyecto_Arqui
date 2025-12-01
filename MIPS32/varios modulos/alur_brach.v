`timescale 1ns/1ns
//1.
module ALUBranch(
    input [31:0]A,
    input [31:0] B_shift_branch,
    output [31:0] resultado
    );
//2.Componentes internos NA
//3.Assing, bloques secuencialess

assign resultado = A + B_shift_branch;

endmodule