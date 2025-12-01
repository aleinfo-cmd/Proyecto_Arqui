`timescale 1ns/1ns
module BR_mux(
    input [4:0] rt,
    input [4:0] rd,
    input RegDst, // para elegir rt o rd
    output [4:0] WriteRegister
);

assign WriteRegister = RegDst ? rd : rt;

endmodule