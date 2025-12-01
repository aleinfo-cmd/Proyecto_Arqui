`timescale 1ns/1ns
module shift_l2_jump(
    input [25:0] dir_inst_j,
    output [27:0] direccion_28
);

assign direccion_28 = {dir_inst_j, 2'b00 };

endmodule