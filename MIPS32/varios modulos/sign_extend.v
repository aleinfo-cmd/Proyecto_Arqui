`timescale 1ns/1ns
module SignExtend(
    input [15:0] instruccion,
    output reg [31:0] sign_extended
);

always @(*) begin
    sign_extended = {{16{instruccion[15]}}, instruccion}; //16 veces el bit en inst[15]
end

endmodule