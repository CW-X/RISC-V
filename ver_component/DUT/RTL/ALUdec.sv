`ifndef ALUDEC
`define ALUDEC
module ALUdec (input logic [1:0] ALUOp,
				  input logic [2:0] funct3,
				  input logic op5, funct7_5,
				  output logic [3:0] ALUcontrol );
	always_comb			  
	case (ALUOp)
		
		//lw,sw
		2'b00: ALUcontrol= 4'b0000; //add
		// beq
		2'b01: 
			begin
			case(funct3)
				3'b000: ALUcontrol= 4'b1011; // beq
				3'b001: ALUcontrol= 4'b1100; // bne
				3'b100: ALUcontrol = 4'b0011; // blt
				3'b101: ALUcontrol = 4'b1010; //bge >= signed
				3'b110: ALUcontrol = 4'b0100; // bltu
				3'b111: ALUcontrol = 4'b1101; // bgeu
				default: ALUcontrol = 4'bxxxx;
			endcase
			end
		
		2'b10:
			begin
			case(funct3)
				3'b000: ALUcontrol = (op5 & funct7_5)? 4'b0001 : 4'b0000; // sub:add（addi)
				3'b001: ALUcontrol = 4'b0010; // sll(slli)
				3'b010: ALUcontrol = 4'b0011; //slt(slti)
				3'b011: ALUcontrol = 4'b0100; // sltu (sltiu)
				3'b100: ALUcontrol = 4'b0101; //xor (xori)
				//3'b101: ALUcontrol = (op5 & funct7_5)? 4'b0111 : 4'b0110 ; //sra:srl (srai : srli)
				3'b101: ALUcontrol = funct7_5? 4'b0111 : 4'b0110 ; //sra:srl (srai : srli)
				3'b110: ALUcontrol = 4'b1000; //or (ori)
				3'b111: ALUcontrol = 4'b1001; // and (andi)
				default: ALUcontrol = 4'bxxxx;
			endcase
			end
			
		default : ALUcontrol = 4'bxxxx;
		
	endcase

endmodule
`endif 



	