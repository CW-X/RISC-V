`ifndef ff_D2E
`define ff_D2E
module ff_D2E(input logic CLK, CLR, RST,
								RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD, signD, PCTargetSrcD,
					input logic [2:0] ResultSrcD,
					input logic [1:0] Byte_Half_OpD,
					input logic [3:0] ALUControlD,
					input logic [31:0] RD1, RD2, PCD, ImmExtD, PCPlus4D,
					input logic [4:0] Rs1D, Rs2D, RdD,
					output logic RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE, signE, PCTargetSrcE,
					output logic [2:0] ResultSrcE,
					output logic [1:0] Byte_Half_OpE,
					output logic [3:0] ALUControlE,
					output logic [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E,
					output logic [4:0] Rs1E, Rs2E, RdE);
					
	always_ff @ (posedge CLK, posedge RST) begin
		if (RST) begin
			RegWriteE <= 0;
			MemWriteE <= 0;
			JumpE <= 0;
			BranchE <= 0;
			ALUSrcE <= 0;
			ResultSrcE <= 0;
			ALUControlE <= 0;
			RD1E <= 0;
			RD2E <= 0;
			PCE <= 0;
			ImmExtE <= 0;
			PCPlus4E <= 0;
			Rs1E <= 0;
			Rs2E <= 0;
			RdE <= 0;
			Byte_Half_OpE <= 0;
			signE <= 0;
			PCTargetSrcE  <=0; 
			end
			
		else begin
			RegWriteE <= CLR? 0 : RegWriteD;
			MemWriteE <= CLR? 0 : MemWriteD;
			JumpE <= CLR? 0 : JumpD;
			BranchE <= CLR? 0 : BranchD;
			ALUSrcE <= CLR? 0 : ALUSrcD;
			ResultSrcE <= CLR? 0 : ResultSrcD;
			ALUControlE <= CLR? 0 : ALUControlD;
			RD1E <= CLR? 0 : RD1;
			RD2E <= CLR? 0 : RD2;
			PCE <= CLR? 0 : PCD;
			ImmExtE <= CLR? 0 : ImmExtD;
			PCPlus4E <= CLR? 0 : PCPlus4D;
			Rs1E <= CLR? 0 : Rs1D;
			Rs2E <= CLR? 0 : Rs2D;
			RdE <= CLR? 0 : RdD;
			Byte_Half_OpE <= CLR? 0: Byte_Half_OpD;
			signE <= CLR? 0: signD;
			PCTargetSrcE <= CLR? 0 : PCTargetSrcD;
			end
			
	end
	
endmodule
`endif