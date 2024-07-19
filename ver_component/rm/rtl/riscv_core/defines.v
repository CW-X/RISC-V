/*** 
 * Author: Stephen Dai
 * Date: 2023-07-10 16:16:46
 * LastEditors: Stephen Dai
 * LastEditTime: 2023-09-01 10:15:25
 * FilePath: \Code\Project\RISCV_from_0_to_1\RISCV_V3\rtl\riscv_core\defines.v
 * Description: 
 * 
 */

//opcode    
`define R_OP      7'b0110011    //R型指令
`define LUI_OP    7'b0110111    //LUI型指令
`define AUIPC_OP  7'b0010111    //AUPIC指令
`define JAL_OP    7'b1101111    //JAL指令
`define B_OP      7'b1100011    //B型指令
`define S_OP      7'b0100011    //Store型指令
`define LD_OP     7'b0000011    //load指令
`define I_OP      7'b0010011    //I型指令
`define JALR_OP   7'b1100111    //JALR指令

//自定义ALUOp
`define R_ALUOp     3'b000
`define I_ALUOp     3'b001
`define LS_ALUOp    3'b010  //L、S型指令rd执行同样的操作
`define B_ALUOp     3'b011
`define J_ALUOp     3'b100  //JAL、JALR指令rd执行同样的操作
`define LUI_ALUOp   3'b101
`define AUIPC_ALUOp 3'b110

//func3字段，用于alu control
`define ADD_SUB_func  3'b000     //ADD和SUB指令fun3相同，需要进一步区分
`define SLL_func      3'b001 
`define SLT_func      3'b010 
`define SLTU_func     3'b011 
`define XOR_func      3'b100 
`define SRL_func      3'b101 
`define SRA_func      3'b101 
`define OR_func       3'b110 
`define AND_func      3'b111 

`define ADDI_func     3'b000   
`define SLTI_func     3'b010
`define SLTIU_func    3'b011 
`define XORI_func     3'b100
`define ORI_func      3'b110
`define ANDI_func     3'b111

`define BEQ_func      3'b000
`define BNE_func      3'b001
`define BLT_func      3'b100
`define BGE_func      3'b101
`define BLTU_func     3'b110
`define BGEU_func     3'b111

`define SLLI_func       3'b001
`define SRLI_SRAI_func  3'b101   //SRLI和SRAI指令fun3相同，需要进一步区分

//自定义ALU_ctl，用于区分指令操作
`define ALU_ADD   5'b00000 //执行ADD 操作
`define ALU_SUB   5'b00001 //执行SUB 操作
`define ALU_AND   5'b00010 //执行AND 操作
`define ALU_OR    5'b00011 //执行OR  操作
`define ALU_XOR   5'b00100 //执行XOR 操作
`define ALU_SLL   5'b00101 //执行SLL 操作
`define ALU_SRL   5'b00110 //执行SRL 操作
`define ALU_SRA   5'b00111 //执行SRA 操作
`define ALU_BEQ   5'b01000 //执行BEQ 操作
`define ALU_BNE   5'b01001 //执行BNE 操作
`define ALU_BGE   5'b01010 //执行BGE 操作
`define ALU_BGEU  5'b01011 //执行BGEU操作
`define ALU_BLT   5'b01100 //执行BLT 操作
`define ALU_BLTU  5'b01101 //执行BLTU操作
`define ALU_SLT   5'b01110 //执行SLT 操作   比较小于，SLT、SLTI共同使用，
`define ALU_SLTU  5'b01111 //执行SLTU操作   比较小于(无符号)，SLTU、SLTIU共同使用，
`define ALU_LUI   5'b10000 //执行imm << 12
`define ALU_AUIPC 5'b10001 //执行PC+(imm<<12)
`define ALU_Jtype 5'b10010 //执行PC+4

//mem_op，用于dram中区分SB、SH、SW、LB、LH、LW、LBU、LHU指令
`define SB_TYPE   3'b000 
`define SH_TYPE   3'b001 
`define SW_TYPE   3'b010 

`define LB_TYPE   3'b000 
`define LH_TYPE   3'b001 
`define LW_TYPE   3'b010 
`define LBU_TYPE  3'b100 
`define LHU_TYPE  3'b101 



