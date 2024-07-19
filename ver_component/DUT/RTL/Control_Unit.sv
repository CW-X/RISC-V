`ifndef CONTROLUNIT
`define CONTROLUNIT
module Control_Unit (input logic [6:0] op,
							input logic [2:0] funct3,
							input logic funct7_5,
							output logic RegWrite,
							output logic [2:0] ImmSrc,
							output logic ALUSrc,
							output logic MemWrite,
							output logic [2:0] ResultSrc,
							output logic Branch,
							output logic Jump,
							output logic signD, //0:unsigned, 1:signed
							output logic [3:0] ALUControl,
							output logic [1:0] Byte_Half_OpD, //00:word opration; 01: byte_op 10: half_op
							output logic PCTargetSrc
							);
	
	logic [1:0] ALUOp;
	logic [16:0] control;
	assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, Byte_Half_OpD, signD, PCTargetSrc} = control;
	always_comb begin 
		case(op)
		
			7'b0000011: //（3）I-type
				case(funct3)
				3'b000: control = 17'b1_000_1_0_001_0_00_0_01_1_0; //lb
				3'b100: control = 17'b1_000_1_0_001_0_00_0_01_0_0; //lbu
				3'b001: control = 17'b1_000_1_0_001_0_00_0_10_1_0; //lh
				3'b101: control = 17'b1_000_1_0_001_0_00_0_10_0_0; //lhu
				default: control = 17'b1_000_1_0_001_0_00_0_00_1_0;  //lw
				endcase

			7'b0100011: //(35) S-type
				case(funct3)
				3'b000: control = 17'b0_001_1_1_xxx_0_00_0_01_1_0; //sb 
				3'b001: control = 17'b0_001_1_1_xxx_0_00_0_10_1_0; //sh
				default: control = 17'b0_001_1_1_xxx_0_00_0_00_1_0; //sw
				endcase
				
			7'b0110011: control = 17'b1_xxx_0_0_000_0_10_0_00_1_0; //（51）R-type

			7'b1100011: control = 17'b0_010_0_0_xxx_1_01_0_00_1_0; //（99）branch

			7'b0010011: control = 17'b1_000_1_0_000_0_10_0_00_1_0; //(19) I-type (ALU)

			7'b1101111: control = 17'b1_011_x_0_010_0_xx_1_00_1_0; //（111）jal

			7'b0110111: control = 17'b1_100_x_0_011_0_xx_0_00_1_0;//(55) U-type lui

			7'b0010111: control = 17'b1_100_x_0_100_0_xx_0_00_1_0; //(23) U-type auipc

			7'b1100111: control = 17'b1_000_1_0_010_0_00_1_00_1_1; //(103) I-type Jalr

			default: control = 17'b0;
		endcase
	end
	
	ALUdec ALUdec_imp (.ALUOp(ALUOp), .funct3(funct3), .op5(op[5]), .funct7_5(funct7_5),
				  .ALUcontrol(ALUControl) );
		
endmodule
`endif