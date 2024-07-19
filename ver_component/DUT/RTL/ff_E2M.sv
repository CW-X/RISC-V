`ifndef ff_E2M
`define ff_E2M
module ff_E2M(input logic CLK, RST, RegWriteE, MemWriteE, signE,
					input logic [2:0] ResultSrcE,
					input logic [1:0] Byte_Half_OpE,
					input logic [31:0] ALUResult, WriteDataE, PCPlus4E, PCTargetE, ImmExtE,
					input logic [4:0] RdE,
					output logic RegWriteM, MemWriteM, signM,
					output logic [2:0] ResultSrcM,
					output logic [1:0] Byte_Half_OpM,
					output logic [31:0] ALUResultM, WriteDataM, PCPlus4M, PCTargetM, ImmExtM,
					output logic [4:0] RdM);

	always_ff @ (posedge CLK, posedge RST) begin
		if (RST) begin
			RegWriteM <= 0;
			MemWriteM <= 0;
			ResultSrcM <= 0;
			ALUResultM <= 0;
			WriteDataM <= 0;
			PCPlus4M <= 0;
			RdM <= 0;
			Byte_Half_OpM <= 0;
			signM <= 0;
			PCTargetM <= 0;
			ImmExtM <= 0;
		end

		else begin
			RegWriteM <= RegWriteE;
			MemWriteM <= MemWriteE;
			ResultSrcM <= ResultSrcE;
			ALUResultM <= ALUResult;
			WriteDataM <= WriteDataE;
			PCPlus4M <= PCPlus4E;
			RdM <= RdE;
			Byte_Half_OpM <= Byte_Half_OpE;
			signM <= signE;
			PCTargetM <= PCTargetE;
			ImmExtM <= ImmExtE;
		end
	end

endmodule
`endif