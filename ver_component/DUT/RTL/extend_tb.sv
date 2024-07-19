`include "extend.sv"
`include "Control_Unit.sv"
`timescale 1ns/100ps
module extend_tb();

logic [31:0] instr;
logic [4:0] rd;
logic [2:0] funct3;
logic [4:0] rs1;
logic [4:0] rs2;
logic [6:0] funct7;
logic [6:0] op;

logic funct7_5;
logic RegWrite;
logic [1:0] ImmSrc;
logic ALUSrc;
logic MemWrite;
logic [1:0] ResultSrc;
logic Branch;
logic Jump;
logic [2:0] ALUControl;

logic [31:0] immext;


Control_Unit Control_Unit_ut (op, funct3, funct7_5, RegWrite, ImmSrc,
							ALUSrc, MemWrite, ResultSrc, Branch, Jump, ALUControl
							);

extend extend_ut (.instr(instr[31:7]),
					.immsrc(ImmSrc),
					.immext(immext));

initial begin

    $dumpfile("extend_tb.vcd");        //生成的vcd文件名称
    $dumpvars(0, extend_tb);    //tb模块名称

end

initial begin
//Instr on P399
    instr = 32'hFFC4A303; //LW
    {funct7,rs2,rs1,funct3,rd,op} = instr;
    funct7_5 = funct7[5];
    #100;
    instr = 32'h0064A423; //SW
    {funct7,rs2,rs1,funct3,rd,op} = instr;
    funct7_5 = funct7[5];
    #100;
    instr = 32'h0062E233; //OR
    {funct7,rs2,rs1,funct3,rd,op} = instr;
    funct7_5 = funct7[5];
    #100;
    instr = 32'hFE420AE3; //beq
    {funct7,rs2,rs1,funct3,rd,op} = instr;
    funct7_5 = funct7[5];
    #100;
    op = 7'b1101111;
    #100;
    $finish;
end

endmodule