module Write_Back (
    input selector,
    input [31:0] ReadData,
    input [31:0] Alu_result,
    output [31:0] WriteData
);

MUXes WB(
    .selector(selector),
    .A(ReadData),
    .B(Alu_result),
    .salida(WriteData)
);
    
endmodule