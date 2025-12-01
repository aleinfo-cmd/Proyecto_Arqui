`timescale 1ns/1ns
module PC(
	input clk, reset,
	input [31:0] next,
	output reg [31:0] InstActual
);

initial
begin
InstActual = 32'b0;
#5;
end

always @(posedge clk) begin
    if (reset)
        InstActual = 32'b0;  // ← Inicialización EXPLÍCITA
    else
        InstActual = next;
end

endmodule