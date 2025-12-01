`timescale 1ns/1ns
module ID_EX (
    input clock, reset, flush,
    input regsdt, branch, memread, memtoreg, memwrite, alusrc, regwrite,
    input [1:0] aluop,
    input [31:0] proxDir_IN,
    input [31:0] DR1_IN,
    input [31:0] DR2_IN,
    input [31:0] sign_extend_IN,
    input [4:0] rt_IN,
    input [4:0] rd_IN,
    output reg [31:0] proxDir_OUT,
    output reg [31:0] DR1_OUT,
    output reg [31:0] DR2_OUT,
    output reg [31:0] sign_extend_OUT,
    output reg [4:0] rt_OUT,
    output reg [4:0] rd_OUT,
    output reg o_regsdt, o_branch, o_memread, o_memtoreg, o_memwrite, o_alusrc, o_regwrite,
    output reg [1:0] o_aluop
);
    
always @(posedge clock) begin
    if (reset || flush)
    begin
        proxDir_OUT <= 32'd0;
        DR1_OUT <= 32'd0;
        DR2_OUT <= 32'd0;
        sign_extend_OUT <= 32'd0;
        rt_OUT <= 5'd0;
        rd_OUT <= 5'd0;
        o_regsdt <= 0;
        o_branch <= 0;
        o_memread <= 0;
        o_memtoreg <= 0;
        o_memwrite <= 0;
        o_alusrc <= 0;
        o_regwrite <= 0;
        o_aluop <= 2'b0;
        
    end
    else begin
        proxDir_OUT <= proxDir_IN;
        DR1_OUT <= DR1_IN;
        DR2_OUT <= DR2_IN;
        sign_extend_OUT <= sign_extend_IN;
        rt_OUT <= rt_IN;
        rd_OUT <= rd_IN;
        o_branch <= branch;
        o_regsdt <= regsdt;
        o_memread <= memread;
        o_memtoreg <= memtoreg;
        o_memwrite <= memwrite;
        o_alusrc <= alusrc;
        o_regwrite <= regwrite;
        o_aluop <= aluop;
    end
end

endmodule