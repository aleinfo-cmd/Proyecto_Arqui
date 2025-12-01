`timescale 1ns/1ns
module MUXes (
    input selector,
    input [31:0]A,
    input [31:0]B, 
    output [31:0]salida
);

                    //si es 1 es A, sino B
assign salida = (selector) ? A : B;
    
endmodule