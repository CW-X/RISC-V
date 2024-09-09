`include "BTB.sv"
`include "BHT.sv"

module PC_gen(input logic clk, reset,
				input logic [31:0] PC, PCM,
				input logic PCSrcE,
				input logic [31:0] target_PC,
				input logic branch,
				input logic predict, 
				output logic [31:0] pc_next
				);
logic bht_taken;
logic [31:0] btb_pred_pc;

BHT BHT_inst( .clock(clk), .reset(reset), .PC(PC),
    .PCM(PCM), .pcsrc(PCSrcE), .branch(branch),
    .bht_taken(bht_taken));

BTB BTB_inst( .clock(clk), .reset(reset),
	    .PC(PC), .PCM(PCM), .pcsrc(PCSrcE),
	  	.target_PC(target_PC), .match(match),
	    .valid(valid),
	    .btb_pred_pc(btb_pred_pc));

always@(*) begin
	if (reset) begin
		pc_next <= 32'h0000_0000;
	end else if (pc_stall) begin
		pc_next <= PC;
	end else if (PCSrcE && !predict) begin
		pc_next <= target_PC;
	end else if (branch && !pcsrc && !predict) begin
		pc_next <= PCM + 4;
	end else if (match && valid && bht_taken) begin
		pc_next <= bht_pred_pc;
	end else begin
		pc_next <= PC + 4;
	end
end

endmodule
