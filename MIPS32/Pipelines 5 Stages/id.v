`timescale 1ns/1ns
module Instruction_Decode(
    input RegWrite,
    input [4:0] WriteRegisterID,
    input [31:0] WriteData,
    input [31:0] instruccion,
    output [31:0] DR1,
    output [31:0] DR2,
    output [31:0] salida_SE
);

//banco de registros
BR BancoRegistros( //relleno
	.AR1(instruccion[25:21]),
	.AR2(instruccion[20:16]),
	.WriteRegister(WriteRegisterID),
	.WriteData(WriteData), //viene de otro multiplexor de hasta la derecha
	.RegWrite(RegWrite), //viene de control
	.DR1(DR1), //salidas
	.DR2(DR2)
	);

//abajo
SignExtend sign_extend(
    .instruccion(instruccion[15:0]),
    .sign_extended(salida_SE)
);

endmodule