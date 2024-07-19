	
	`timescale 1ns / 1ps
	
	module ALU_rm(//
	    input [31:0] alu_in1,
	    input [31:0] alu_in2,
	    input [3:0] aluop,//
	    output reg [31:0] alu_result,
	    output reg zero
	);
	
	always @(*) begin
	    zero = (alu_in1 == alu_in2) ? 1'b1 : 1'b0;
	    case(aluop)//
	        4'b0000: alu_result = alu_in1 + alu_in2;
	        4'b0001: alu_result = alu_in1 - alu_in2;
	        4'b0010: alu_result = alu_in1 ^ alu_in2;
	        4'b0011: alu_result = alu_in1 | alu_in2;
	        4'b0100: alu_result = alu_in1 & alu_in2;
	        4'b0101: alu_result = alu_in1 << alu_in2[4:0];
	        4'b0110: alu_result = alu_in1 >> alu_in2[4:0];
	        4'b0111: alu_result = $signed(alu_in1) >>> alu_in2[4:0];
	        4'b1000: alu_result = ($signed(alu_in1) < $signed(alu_in2)) ? 32'h00000001 : 32'h00000000;
	        4'b1001: alu_result = ($unsigned(alu_in1) < $unsigned(alu_in2)) ? 32'h00000001 : 32'h00000000;
	        default: alu_result = 32'h00000000;
	    endcase
	end
	
	endmodule
	
	
