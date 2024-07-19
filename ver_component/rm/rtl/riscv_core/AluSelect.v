	module AluSelect(//
	input [31:0] rs1_data,
	input [31:0] rs2_data,
	input [31:0] imm,
	input [31:0] mem_aluresult,
	input [31:0] writedata,
	input immsrc,
	input islui,
	input [1:0] forward1,
	input [1:0] forward2,
	output reg [31:0] alu_in1,
	output reg [31:0] alu_in2
	);
	
	reg [31:0] select1, select2;
	
	always @(*) begin
	  case(forward1)
	    2'b00: select1 = rs1_data;
	    2'b01: select1 = mem_aluresult;
	    2'b10: select1 = writedata;
	    2'b11: select1 = rs1_data;
	  endcase
	
	  case(forward2)
	    2'b00: select2 = rs2_data;
	    2'b01: select2 = mem_aluresult;
	    2'b10: select2 = writedata;
	    2'b11: select2 = rs2_data;
	  endcase
	
	  alu_in1 = (islui == 1'b1) ? 32'b0 : select1;
	  alu_in2 = (immsrc == 1'b1) ? imm : select2;
	end
	
	endmodule