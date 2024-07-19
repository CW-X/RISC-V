`timescale 1ns / 1ps

module Fetch(
input wire clock,
input wire reset,
// input wire [31:0] trap_vector,//
// input wire [31:0] mret_vector,//
input wire [31:0] target_pc,
input wire [31:0] mem_pc,
input wire pcsrc,
input wire branch,
input wire trap,
// input wire mret,
input wire pc_stall,
input wire if_id_stall,
input wire if_id_flush,
input wire predict,
input wire [31:0] fetch_data,
output wire [31:0] id_pc,
output wire [31:0] inst,
output wire [31:0] fetch_address
);

parameter TRAP_VECTOR = 32'h0000_0010;//
reg [31:0] pc;
reg [31:0] pc_next;
wire match;
wire valid;
wire btb_taken;
wire [31:0] bht_pred_pc;

BHT bht(
.clock(clock),
.reset(reset),
.pc(pc_next),
.mem_pc(mem_pc),
.pcsrc(pcsrc),
.target_pc(target_pc),
.match(match),
.valid(valid),
.bht_pred_pc(bht_pred_pc)
);

BTB btb(
.clock(clock),
.reset(reset),
.pc(pc_next),
.mem_pc(mem_pc),
.pcsrc(pcsrc),
.branch(branch),
.btb_taken(btb_taken)
);

always@(*) begin
if (reset) begin
 pc_next <= 32'h0000_0000;
end else if (pc_stall) begin
 pc_next <= pc;
// end else if (trap) begin
// //pc <= trap_vector;//
// pc <= TRAP_VECTOR;
// // end else if (mret) begin//
// // pc <= mret_vector;//
end else if (pcsrc && !predict) begin
 pc_next <= target_pc;
end else if (branch && !pcsrc && !predict) begin
 pc_next <= mem_pc + 4;
end else if (match && valid && btb_taken) begin
 pc_next <= bht_pred_pc;
end else begin
 pc_next <= pc + 4;
end
end

reg [31:0] id_pc_reg;
reg [31:0] inst_reg;

always @(posedge clock or posedge reset) begin
if (reset) begin
id_pc_reg <= 0;
inst_reg <= 32'h00100013; // addi x0,x0,0
end else if (if_id_flush) begin
id_pc_reg <= 0;
inst_reg <= 32'h00100013; // addi x0,x0,0
end else if (!if_id_stall) begin
id_pc_reg <= pc_next;
inst_reg <= fetch_data;
end
end

assign id_pc = id_pc_reg;
assign inst = inst_reg;
assign fetch_address = pc_next;

endmodule
