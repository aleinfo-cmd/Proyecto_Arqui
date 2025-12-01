`timescale 1ns/1ns
module EX_MEM(
    input clock, reset, zero_IN,
    input branch, memread, memtoreg, memwrite, regwrite,
    input [31:0] PCplus4_B,
    input [31:0] Add_proxDir_IN,
    input [31:0] DR2_IN,
    input [31:0] Alu_result_IN,
    input [4:0] WriteRegister_IN,
    output reg zero_OUT,
    output reg [31:0] PCplus4_B_OUT,
    output reg [31:0] Add_proxDir_OUT,
    output reg [31:0] DR2_OUT,
    output reg [31:0] Alu_result_OUT,
    output reg [4:0] WriteRegister,
    output reg o_branch, o_memread, o_memtoreg, o_memwrite, o_regwrite
);

always @(posedge clock) begin
    if (reset)
    begin
        PCplus4_B_OUT <= 32'b0;
        zero_OUT <= 0;
        Add_proxDir_OUT <= 32'd0;
        DR2_OUT <= 32'd0;
        Alu_result_OUT <= 32'd0;
        WriteRegister <= 5'd0;
        o_branch <= 0;
        o_memread <= 0;
        o_memtoreg <= 0;
        o_memwrite <= 0;
        o_regwrite <= 0;
    end
    else begin
        PCplus4_B_OUT <= PCplus4_B;
        zero_OUT <= zero_IN;
        Add_proxDir_OUT <= Add_proxDir_IN;
        DR2_OUT<= DR2_IN;
        Alu_result_OUT <= Alu_result_IN;
        WriteRegister <= WriteRegister_IN;
        o_branch <= branch;
        o_memread <= memread;
        o_memtoreg <= memtoreg;
        o_memwrite <= memwrite;
        o_regwrite <= regwrite;
    end
end


endmodule