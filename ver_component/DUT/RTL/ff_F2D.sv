`ifndef ff_F2D
`define ff_F2D
module ff_F2D(input logic [31:0] PCF, PCPlus4F, InstrF,
					input logic CLK, EN, CLR, RST,
					output logic [31:0] InstrD, PCD, PCPlus4D);

	always_ff @(posedge CLK, posedge RST)
		begin
			if(RST) begin
				InstrD <= 0;
				PCD <= 0;
				PCPlus4D <= 0;
				end
				
			else if (~EN) begin
				InstrD <= CLR? 0 : InstrF;
				PCD <= CLR? 0 : PCF;
				PCPlus4D <= CLR? 0 : PCPlus4F;
				end
				
		end
		
endmodule
`endif