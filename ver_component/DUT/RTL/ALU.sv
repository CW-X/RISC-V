`ifndef ALU
`define ALU
module ALU(input logic [3:0] ALUControl,
				input logic [31:0] a,b,
				output logic [31:0] ALUResult,
				output logic Zero);
				
	always_comb begin
		case(ALUControl)
			4'b0000: ALUResult = a + b; //add
			4'b0001: ALUResult = a - b;	//sub
			4'b0010: ALUResult = a << b[4:0]; //sll
			4'b0011: ALUResult = ($signed(a) < $signed(b))? 32'b1 : 32'b0; // set less than
			4'b0100: ALUResult = (a < b)? 32'b1 : 32'b0;//sltu
			4'b0101: ALUResult = a ^ b; //xor
			4'b0110: ALUResult = a >> b[4:0];	//srl
			//shiftres[31:0] =  ( { {31{reg2_i}}, 1'b0 } << (~reg1_i[4:0]) ) | ( reg2_i >> reg1_i[4:0] ) ;
			4'b0111: ALUResult = ( { { 31{a[31]} }, 1'b0} << (~ b[4:0]) ) | ( a >> b[4:0] ); //sra
			//ALUResult = a >>> b[4:0];
			4'b1000: ALUResult = a | b;	//bitwise or
			4'b1001: ALUResult = a & b;  //bitwise and
			4'b1010: ALUResult = $signed(a) >= $signed(b) ? 32'b1 : 32'b0; // greater or equal signed
            		4'b1011: ALUResult = (a == b) ? 32'b1 : 32'b0; // equal
           		4'b1100: ALUResult = (a !== b) ? 32'b1 : 32'b0; // not equal
         		4'b1101: ALUResult = (a >= b) ? 32'b1 : 32'b0; // greater or equal unsigned
			default: ALUResult = 32'd0;
		endcase
	end 
	
	assign Zero = (ALUResult == 32'b0)? 1 : 0;
	
endmodule
`endif