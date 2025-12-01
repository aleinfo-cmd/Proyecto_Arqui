`timescale 1ns/1ns
module MEM_WB (
    input clock, reset,
    input memtoreg, regwrite,
    input [31:0] ReadData_IN, 
    input [31:0] ALUResult_IN,
    input [4:0] RegDst_IN,
    output reg [31:0] ReadData_OUT, ALUResult_OUT,
    output reg [4:0] RegDst_OUT,
    output reg o_memtoreg, o_regwrite
);

always @(posedge clock) begin
    if (reset)
    begin
        ReadData_OUT <= 32'd0;
        ALUResult_OUT <= 32'd0;
        RegDst_OUT <= 5'd0;
        o_memtoreg <= 0;
        o_regwrite <= 0;
    end
    else begin
        ReadData_OUT <= ReadData_IN;
        ALUResult_OUT <= ALUResult_IN;
        RegDst_OUT <= RegDst_IN;
        o_memtoreg <= memtoreg;
        o_regwrite <= regwrite;
    end
end
   
endmodule