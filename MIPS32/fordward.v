module Forwarding(
    input [4:0] ID_rs, ID_rt,     // Registros que BEQ quiere leer
    input [4:0] EX_rd,            // Registro que EX va a escribir  
    input EX_RegWrite,             // EX va a escribir un registro
    output reg forward_rs, forward_rt
);
    
    // Forward para rs
    assign forward_rs = (EX_RegWrite && EX_rd == ID_rs);
    
    // Forward para rt  
    assign forward_rt = (EX_RegWrite && EX_rd == ID_rt);
    
endmodule