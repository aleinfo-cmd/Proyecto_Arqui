`timescale 1ns/1ns
//1.Definicion del modulo
module MemoriaDatos(
    input clk,
    input MemWrite,
    input MemRead,
    input [31:0]Address,
    input [31:0]WriteData, //dr2
    output reg [31:0]ReadData
);
//2.Componentes internos
reg [31:0] MEM_DATOS [0:63]; 
//3.Cuerpo del modulo
initial
	begin
		MEM_DATOS [0] =8'd20; //monedas
		MEM_DATOS [1] =8'd10;
		MEM_DATOS [2] =8'd5;
		MEM_DATOS [3] =8'd2;
		MEM_DATOS [4] =8'd1;    //monedas fin
		MEM_DATOS [5] =8'd47;   //monto
		MEM_DATOS [6] =8'd0;    //cambio de 20
		MEM_DATOS [7] =8'd0;    //cambio de 10 etc
		MEM_DATOS [8] =8'd0; 
		MEM_DATOS [9] =8'd0;
		MEM_DATOS [10] =8'd0;
        MEM_DATOS [20] =32'b1000;

	end 

always @(*) begin
    if (MemRead)
    begin
        ReadData = MEM_DATOS[Address[31:0]];
    end 
    else begin
        ReadData <= 32'b0;
    end
end


always @(posedge clk) begin
    if (MemWrite) 
    begin
        MEM_DATOS[Address[31:2]] <= WriteData;
    end
end


always @(*) begin
    if (MemRead) 
        $display("MEM_READ: Address=%d, Data=%d", Address, ReadData);
    if (MemWrite) 
        $display("MEM_WRITE: Address=%d, Data=%d", Address, WriteData);
end

endmodule