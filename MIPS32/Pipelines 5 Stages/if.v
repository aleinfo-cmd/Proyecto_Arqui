`timescale 1ns/1ns
module Instruction_Fetch(
	input clk, reset,
	input branch,
	input [31:0] next,
	input [31:0] PCmux_A, 
	input [31:0] PCmux_B,
	output [31:0] InstQ,
	output [31:0] prox_dir,
	output [31:0] muxPC_salida
);

wire [31:0] C1;

//instancias

PC program_counter(.clk(clk), .next(next), .InstActual(C1), .reset(reset));

MemInstrucciones memoria_inst(.Dir(C1), .InstActual(InstQ));

add adder_dir(.op1(4), .op2(C1), .resultado(prox_dir));

MUXes muxPC(.selector(branch), .A(PCmux_A), .B(PCmux_B), .salida(muxPC_salida));

endmodule