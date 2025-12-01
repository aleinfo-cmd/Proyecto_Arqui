`timescale 1ns/1ns
module mips_TB();

reg clk, reset;

mips32 procesador(.clk(clk), .reset(reset));

initial begin 
    clk = 0;    //no quitar, esto para que el pc lea desde la primera instrucción 0
    reset = 1;
    #5 reset = 0;
end

always #50 clk = ~clk; 



endmodule