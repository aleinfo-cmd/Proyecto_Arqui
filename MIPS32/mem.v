`timescale 1ns/1ns
module MemoryAccess (
    input MemWrite,
    input MemRead,
    input clk,
    input [31:0] Address,
    input [31:0] WriteData,
    output [31:0] ReadData
);

//memoria de datos
MemoriaDatos MD(
    .clk(clk),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .Address(Address),
    .WriteData(WriteData),
    .ReadData(ReadData)
);

endmodule