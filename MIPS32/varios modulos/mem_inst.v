`timescale 1ns/1ns
module MemInstrucciones(
	input [31:0]Dir, 
	output reg [31:0]InstActual
);

reg [7:0] MI [0:255];
initial
$readmemb("instrucciones.txt", MI);

always@*
begin
//InstActual = MI[dir];
InstActual = {MI[Dir], MI[Dir+1], MI[Dir+2], MI[Dir+3]};
end

endmodule