
`timescale 1ns/1ns
module BR(
	input [4:0]AR1,	//rs
	input [4:0]AR2,	//rt
	input [4:0]WriteRegister,	//rd o rt
	input [31:0]WriteData,	//lo que se va a escribir - reemplazar
	input RegWrite,	// viene de control para habilitar escritura
	output reg[31:0]DR1,	//para leer lo que hay en Banco[AR]
	output reg[31:0]DR2
	);

//Arreglo bidimencional de registros
reg [31:0]Banco[0:31];

initial
begin
	$readmemb("Datos.txt",Banco);
end
//SIEMPRE LEE

always @(*)
begin
	//Leer
	DR1= Banco[AR1];
	DR2= Banco[AR2];

	if (RegWrite) 
	begin
		// Escribir
		Banco[WriteRegister] = WriteData;
	end
end

endmodule