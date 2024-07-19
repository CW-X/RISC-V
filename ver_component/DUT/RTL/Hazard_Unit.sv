`ifndef Hazard_Unit
`define Hazard_Unit
module Hazard_Unit(input logic [4:0] Rs1D, Rs2D, Rs1E, Rs2E,
										RdE, RdM, RdW, 
					input logic [2:0]  ResultSrcE,
					input logic RegWriteM, RegWriteW, PCSrcE,
					output logic StallF, StallD, FlushE, FlushD,
					output logic [1:0] ForwardAE, ForwardBE);
						 
	logic lwStall;
	//Solve Data Hazard
	//Read After Write
	always_comb
		begin 
			if (((Rs1E == RdM) && RegWriteM) && (Rs1E != 0))
				ForwardAE = 2'b10;
			else if (((Rs1E == RdW) && RegWriteW) && (Rs1E != 0))
				ForwardAE = 2'b01;
			else 
				ForwardAE = 2'b00;
		end
		
	always_comb
		begin 
			if (((Rs2E == RdM) && RegWriteM) && (Rs2E != 0))
				ForwardBE = 2'b10;
			else if (((Rs2E == RdW) && RegWriteW) && (Rs2E != 0))
				ForwardBE = 2'b01;
			else
				ForwardBE = 2'b00;
		end
		
	//Stall to slove lw data hazard
	assign lwStall = (ResultSrcE ==3'b001) && ((Rs1D == RdE)||(Rs2D == RdE));
	
	always_comb
		begin
		if (lwStall === 1'bx) begin
				StallF = 1'b0;
				StallD = 1'b0;
				FlushE = 1'b0;
			end
			
		else begin
				StallF = lwStall;
				StallD = lwStall;
				FlushE = lwStall || PCSrcE;
			end
		end
	
	assign FlushD = PCSrcE;
		
endmodule
`endif