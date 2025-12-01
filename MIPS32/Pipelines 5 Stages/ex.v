`timescale 1ns/1ns
module Execution (
    input RegDst, AluSrc,
    input [3:0] ALU_control,
    input [4:0] rt,
    input [4:0] rd,
    input [31:0] prox_dir,
    input [31:0] ALU_A,
    input [31:0] DR2,
    input [31:0] sign_extend,
    output zero,
    output [31:0] proxdir_result,
    output [31:0] ALU_result,
    output [4:0] WriteRegister_OEX
);

wire [31:0] C1,C2;

//alu
ALU alu(
	.A(ALU_A),
	.B(C2),
	.alu_control(ALU_control), //para decidir que hacer segun el ALUop de control, se lo pasa ALUcontrol
	.resultado(ALU_result),
    .zero(zero)
	);

//branch
add ADD_branch(
    .op1(prox_dir),
    .op2(C1),
    .resultado(proxdir_result)
);

MUXes mux_ALUSrc( //para LW, SW
    .selector(AluSrc),
    .A(sign_extend),
    .B(DR2),
    .salida(C2)
);

shift_l2_branch sl2(
    .sign_extend(sign_extend),
    .shift_branch_salida(C1)
);

BR_mux mux_RegDst(
    .rd(rd), //rd
    .rt(rt), //rt
    .RegDst(RegDst),
    .WriteRegister(WriteRegister_OEX)
);

endmodule