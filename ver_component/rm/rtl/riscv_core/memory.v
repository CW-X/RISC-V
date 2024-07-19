`timescale 1ns / 1ps

module memory(
input clock,
input reset,
input [31:0] reg_pc,
input mem_isbranch,
input mem_isjump,
input mem_memread,
input mem_memwrite,
input mem_regwrite,
input [1:0] mem_memtoreg,
input mem_zero,
input [31:0] mem_aluresult,
input [31:0] mem_rs2_data,
input [2:0] mem_funct3,
input [4:0] mem_rd,
output reg [31:0] wb_reg_pc,
output reg [31:0] wb_readdata,
output reg [31:0] wb_aluresult,
output reg [1:0] wb_memtoreg,
output reg wb_regwrite,
output reg [4:0] wb_rd,
output pcsrc,
output branch,
input [31:0] memory_read_data,
output load_store_unsigned,
output [1:0] memory_size,
output [31:0] memory_address,
output [31:0] memory_write_data,
output memory_read,
output memory_write
);

wire branch_out, pcsrc_out;

Branch branch1(
.mem_zero(mem_zero),
.mem_aluresult(mem_aluresult),
.mem_funct3(mem_funct3),
.mem_isbranch(mem_isbranch),
.mem_isjump(mem_isjump),
.branch(branch_out),
.pcsrc(pcsrc_out)
);

assign branch = branch_out;
assign pcsrc = pcsrc_out;

assign memory_address = mem_aluresult;
assign memory_write_data = mem_rs2_data;
assign memory_read = mem_memread;
assign memory_write = mem_memwrite;
assign load_store_unsigned = mem_funct3[2];
assign memory_size = mem_funct3[1:0];

always @(posedge clock or posedge reset) begin
if (reset) begin
wb_reg_pc <= 0;
wb_readdata <= 0;
wb_aluresult <= 0;
wb_memtoreg <= 0;
wb_regwrite <= 0;
wb_rd <= 0;
end else begin
wb_reg_pc <= reg_pc;
wb_readdata <= memory_read_data;
wb_aluresult <= mem_aluresult;
wb_memtoreg <= mem_memtoreg;
wb_regwrite <= mem_regwrite;
wb_rd <= mem_rd;
end
end

endmodule
