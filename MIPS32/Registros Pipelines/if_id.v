`timescale 1ns/1ns
module IF_ID(
    input clock, reset, flush,
    input [31:0] proxDir_IN,
    input [31:0] instruccion_IN,
    output reg [31:0] instruccion_OUT,
    output reg [31:0] proxDir_OUT
);

always @(posedge clock) begin
    if (reset || flush)
    begin
        instruccion_OUT <= 32'd0;
        proxDir_OUT <= 32'd0;
    end
    else begin
        instruccion_OUT <= instruccion_IN;
        proxDir_OUT <= proxDir_IN;
    end
end

endmodule