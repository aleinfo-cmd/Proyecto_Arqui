`timescale 1ns/1ns
module mips32(
    input clk,
    input reset //inicio PC inst 0
);

wire [31:0] C_InstQ, C_InstQ_IFID, next_dir, C1B, C_DR1_B, C_DR2_B, C_SigExt, C_SigExt_B, C_AddBranch_A, C_AddBranch_B,C_DR1, C_DR2, c_muxPC_salida, c_next;
wire C_Zero, C_BranchZero, C_Branch_1;
wire [31:0] C_Add_ProxDir, C_ALU_result, C_ALU_result_B ,C_muxEntry, C_DR2_C, C_ReadData;
wire [31:0] C_WriteData, C_ReadData_B, C_ALU_result_C;
wire cregDst, cjump, cbranch, cmemRead, cmemtoReg, cmemWrite, cALUSrc, cRegWrite;
wire IDEX_cregDst, IDEX_cbranch, IDEX_cmemRead, IDEX_cmemtoReg, IDEX_cmemWrite, IDEX_cALUSrc, IDEX_cRegWrite;
wire EXMEM_cbranch, EXMEM_cmemRead, EXMEM_cmemtoReg, EXMEM_cmemWrite, EXMEM_cRegWrite;
wire MEMWB_memtoreg, MEMWB_regwrite;
wire [1:0] cALUop, IDEX_cALUop;
wire [3:0] cAlU_control;
//Write Registers
wire [4:0] C_rt_B, C_rd_B;
wire [4:0] C_WRe2, C_WRe3; 
wire [27:0] c_jump_28;
wire [4:0] C_OEX;


//Etapas
Instruction_Fetch IF(
    .clk(clk), .reset(reset),
    .branch(C_Branch_1),
    .next(c_next),
    .PCmux_A(C_muxEntry),
    .PCmux_B(C_AddBranch_B),
    .InstQ(C_InstQ),
    .prox_dir(next_dir),
    .muxPC_salida(c_muxPC_salida)
);
Instruction_Decode ID(
    .RegWrite(MEMWB_regwrite),
    .WriteRegisterID(C_WRe3),
    .WriteData(C_WriteData),
    .instruccion(C_InstQ_IFID),
    .DR1(C_DR1), //outputs
    .DR2(C_DR2),
    .salida_SE(C_SigExt)
);
Execution EX(
    .RegDst(IDEX_cregDst), .AluSrc(IDEX_cALUSrc),
    .ALU_control(cAlU_control),
    .rt(C_rt_B), 
    .rd(C_rd_B),
    .prox_dir(C_AddBranch_A),
    .ALU_A(C_DR1_B),
    .DR2(C_DR2_B),
    .sign_extend(C_SigExt_B),
    .zero(C_Zero),
    .proxdir_result(C_Add_ProxDir),
    .ALU_result(C_ALU_result),
    .WriteRegister_OEX(C_OEX)
);
MemoryAccess MEM(
    .MemWrite(EXMEM_cmemWrite),
    .MemRead(EXMEM_cmemRead),
    .clk(clk),
    .Address(C_ALU_result_B),
    .WriteData(C_DR2_C),
    .ReadData(C_ReadData)
);

Write_Back WB(
    .selector(MEMWB_memtoreg),
    .ReadData(C_ReadData_B),
    .Alu_result(C_ALU_result_C),
    .WriteData(C_WriteData)
);
//Etapas fin

//pipeline registers
IF_ID IFID(
    .clock(clk), .reset(reset),
    .proxDir_IN(next_dir),
    .instruccion_IN(C_InstQ),
    .instruccion_OUT(C_InstQ_IFID),
    .proxDir_OUT(C1B)
);
ID_EX IDEX(
    .clock(clk), .reset(reset),
    .regsdt(cregDst), .branch(cbranch), .memread(cmemRead), .memtoreg(cmemtoReg), .memwrite(cmemWrite), .alusrc(cALUSrc), .regwrite(cRegWrite),
    .aluop(cALUop),
    .proxDir_IN(C1B),
    .DR1_IN(C_DR1),
    .DR2_IN(C_DR2),
    .sign_extend_IN(C_SigExt),
    .rt_IN(C_InstQ_IFID[20:16]),
    .rd_IN(C_InstQ_IFID[15:11]),
    .proxDir_OUT(C_AddBranch_A),
    .DR1_OUT(C_DR1_B),
    .DR2_OUT(C_DR2_B),
    .sign_extend_OUT(C_SigExt_B),
    .rt_OUT(C_rt_B),
    .rd_OUT(C_rd_B),
    .o_regsdt(IDEX_cregDst), .o_branch(IDEX_cbranch), .o_memread(IDEX_cmemRead), .o_memtoreg(IDEX_cmemtoReg), .o_memwrite(IDEX_cmemWrite), .o_alusrc(IDEX_cALUSrc), .o_regwrite(IDEX_cRegWrite),
    .o_aluop(IDEX_cALUop)
);
EX_MEM EXMEM(
    .PCplus4_B(C_AddBranch_A), .PCplus4_B_OUT(C_AddBranch_B),
    .clock(clk), .reset(reset), .zero_IN(C_Zero),
    .branch(IDEX_cbranch), .memread(IDEX_cmemRead), .memtoreg(IDEX_cmemtoReg), .memwrite(IDEX_cmemWrite), .regwrite(IDEX_cRegWrite),
    .Add_proxDir_IN(C_Add_ProxDir),
    .DR2_IN(C_DR2_B),
    .Alu_result_IN(C_ALU_result),
    .WriteRegister_IN(C_OEX),
    .zero_OUT(C_BranchZero),
    .Add_proxDir_OUT(C_muxEntry),
    .DR2_OUT(C_DR2_C),
    .Alu_result_OUT(C_ALU_result_B),
    .WriteRegister(C_WRe2),
    .o_branch(EXMEM_cbranch), .o_memread(EXMEM_cmemRead), .o_memtoreg(EXMEM_cmemtoReg), .o_memwrite(EXMEM_cmemWrite), .o_regwrite(EXMEM_cRegWrite)
);

MEM_WB MEMWB(
    .clock(clk), .reset(reset),
    .memtoreg(EXMEM_cmemtoReg), .regwrite(EXMEM_cRegWrite),
    .ReadData_IN(C_ReadData), 
    .ALUResult_IN(C_ALU_result_B),
    .RegDst_IN(C_WRe2),
    .ReadData_OUT(C_ReadData_B), 
    .ALUResult_OUT(C_ALU_result_C),
    .RegDst_OUT(C_WRe3),
    .o_memtoreg(MEMWB_memtoreg), .o_regwrite(MEMWB_regwrite)
);
//pipelines reg fin

control control_unit(
    .opcode(C_InstQ[31:26]), //instruccion del [31:26]
    .RegDst(cregDst),
    .Jump(cjump),
    .Branch(cbranch),
    .MemRead(cmemRead),
    .MemtoReg(cmemtoReg),
    .ALUop(cALUop),
    .MemWrite(cmemWrite),
    .ALUSrc(cALUSrc),
    .RegWrite(cRegWrite)
);

//azul
ALUcontrol alu_control(
    .instruccion_FNC(C_SigExt_B[5:0]),
    .ALUop(IDEX_cALUop), //de control idex
    .sal_alu_control(cAlU_control) //salida para ALU
);

AND branch(
    .A(EXMEM_cbranch),
    .B(C_BranchZero),
    .salida(C_Branch_1)
);

shift_l2_jump sl2_jump(
    .dir_inst_j(C_InstQ_IFID[25:0]),
    .direccion_28(c_jump_28)
);

MUXes muxJump(.selector(cjump), .A({C_InstQ_IFID[31:28], c_jump_28}), .B(c_muxPC_salida), .salida(c_next));


always @(posedge clk) begin
    if (cbranch) 
        $display("BEQ_DEBUG: zero=%b, branch_taken=%b, deberia_saltar=%b", 
                 C_BranchZero, C_Branch_1, (C_BranchZero && EXMEM_cbranch));
end

endmodule