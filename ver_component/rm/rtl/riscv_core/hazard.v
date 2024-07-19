`timescale 1ns / 1ps

module hazard(
input isbranch,
output predict,
output pc_stall,
output if_id_stall,
output if_id_flush,
input trap,
input memread,
input use_rs1,
input use_rs2,
input [4:0] id_rs1,
input [4:0] id_rs2,
input [4:0] ex_rd,
input ex_use_rs1,
input ex_use_rs2,
input [4:0] ex_rs1,
input [4:0] ex_rs2,
input [31:0] ex_pc,
output id_ex_flush,
input [4:0] mem_rd,
input mem_regwrite,
input [31:0] mem_pc,
input [31:0] target_pc,
output [1:0] forward1,
output [1:0] forward2,
output ex_mem_flush,
input [4:0] wb_rd,
input wb_regwrite,
input pcsrc,

//new add
input [1:0] mem_memtoreg
);

assign forward1 = (ex_use_rs1 && ex_rs1 == mem_rd && mem_regwrite && mem_rd != 0) ? 2'b01 : (ex_use_rs1 && ex_rs1 == wb_rd && wb_regwrite && wb_rd != 0) ? 2'b10 : 2'b00;
assign forward2 = (ex_use_rs2 && ex_rs2 == mem_rd && mem_regwrite && mem_rd != 0) ? 2'b01 : (ex_use_rs2 && ex_rs2 == wb_rd && wb_regwrite && wb_rd != 0) ? 2'b10 : 2'b00;

//assign if_id_stall = (use_rs1 && id_rs1 == ex_rd && memread && ex_rd != 0) || (use_rs2 && id_rs2 == ex_rd && memread && ex_rd != 0);
assign if_id_stall = mem_memtoreg[0]&((id_rs1 == ex_rd) || (id_rs2 == ex_rd));
assign pc_stall = if_id_stall;
assign if_id_flush = trap || (pcsrc && target_pc != ex_pc) || (isbranch && !pcsrc && ex_pc != mem_pc + 4);
assign id_ex_flush = (pcsrc && target_pc != ex_pc) || (isbranch && !pcsrc && ex_pc != mem_pc + 4) ;
assign ex_mem_flush = (pcsrc && target_pc != ex_pc) || (isbranch && !pcsrc && ex_pc != mem_pc + 4);
assign predict = (pcsrc && target_pc == ex_pc) || (isbranch && !pcsrc && ex_pc == mem_pc + 4);

endmodule