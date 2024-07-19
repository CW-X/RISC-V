module Control(input [6:0] opcode, input [6:0] funct7, input [2:0] funct3, output reg [3:0] aluop, output reg immsrc, output reg isbranch, output reg memread, output reg memwrite, output reg regwrite, output reg [1:0] memtoreg, output reg pcsel, output reg rdsel, output reg isjump, output reg islui, output reg use_rs1, output reg use_rs2);
 always @(*) begin
 // Default values
 aluop = 4'b0000; immsrc = 0; isbranch = 0; memread = 0; memwrite = 0; regwrite = 0; memtoreg = 2'b00; pcsel = 0; rdsel = 0; isjump = 0; islui = 0; use_rs1 = 0; use_rs2 = 0;
 case(opcode)
 7'b0110011: begin // R-type
 use_rs1 = 1; use_rs2 = 1; regwrite = 1; memtoreg = 2'b10;
 case(funct3)
 3'b000: aluop = (funct7 == 7'b0000000) ? 4'b0000 : 4'b0001;
 3'b001: aluop = 4'b0101;
 3'b010: aluop = 4'b1000;
 3'b011: aluop = 4'b1001;
 3'b100: aluop = 4'b0010;
 3'b101: aluop = (funct7 == 7'b0000000) ? 4'b0110 : 4'b0111;
 3'b110: aluop = 4'b0011;
 3'b111: aluop = 4'b0100;
 endcase
 end
 7'b0010011: begin // I-type
 use_rs1 = 1; regwrite = 1; immsrc = 1; memtoreg = 2'b10;
 case(funct3)
 3'b000: aluop = 4'b0000;
 3'b001: aluop = 4'b0101;
 3'b010: aluop = 4'b1000;
 3'b011: aluop = 4'b1001;
 3'b100: aluop = 4'b0010;
 3'b101: aluop = (funct7 == 7'b0000000) ? 4'b0110 : 4'b0111;
 3'b110: aluop = 4'b0011;
 3'b111: aluop = 4'b0100;
 endcase
 end
 7'b1100011: begin // B-type
 use_rs1 = 1; use_rs2 = 1; isbranch = 1;
 aluop = (funct3 == 3'b110 || funct3 == 3'b111) ? 4'b1001 : 4'b1000;
 end
 7'b0000011: begin // Load
 use_rs1 = 1; regwrite = 1; immsrc = 1; memread = 1; memtoreg = 2'b01;
 end
 7'b0100011: begin // Store
 use_rs1 = 1; use_rs2 = 1; immsrc = 1; memwrite = 1;
 end
 7'b1101111: begin // JAL
 isjump = 1; regwrite = 1; immsrc = 1;
 end
 7'b1100111: begin // JALR
 use_rs1 = 1; isjump = 1; regwrite = 1; immsrc = 1; pcsel = 1;
 end
 7'b0110111: begin // LUI
 islui = 1; regwrite = 1; immsrc = 1; memtoreg = 2'b10;
 end
 7'b0010111: begin // AUIPC
 rdsel = 1; regwrite = 1; immsrc = 1;
 end
 default: begin
 aluop = 4'b0000; immsrc = 0; isbranch = 0; memread = 0; memwrite = 0; regwrite = 0; memtoreg = 2'b00; pcsel = 0; rdsel = 0; isjump = 0; islui = 0; use_rs1 = 0; use_rs2 = 0;
 end
 endcase
 end
endmodule
