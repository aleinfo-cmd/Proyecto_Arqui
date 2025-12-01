`timescale 1ns/1ns
module shift_l2_branch(
    input [31:0] sign_extend,
    output [31:0] shift_branch_salida
);

assign shift_branch_salida = sign_extend << 2;

endmodule