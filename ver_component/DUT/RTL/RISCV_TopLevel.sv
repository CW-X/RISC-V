`ifndef RISCV_TopLevel
`define RISCV_TopLevel
module RISCV_TopLevel( input logic clk,
                input logic reset,
				output logic [4:0] A1, A2, A3,
				output logic [31:0] RD1, RD2,
				output logic WD3, WE3,
				output logic [31:0] A, WD, RD,
				output logic WE
				 );

logic PCSrcE;
logic [31:0] PCNext, PCPlus4F, PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W;
logic [31:0] PCTargetE, PCplusImmE, PCplusImmM, PCplusImmW;
logic [31:0] PCF, PCD, PCE;
logic [31:0] InstrF, InstrD;
logic [31:0] RD1D, RD2D, RD1E, RD2E;
logic [31:0] RD1E, RD2E;
logic [31:0] ImmExtD, ImmExtE, ImmExtM, ImmExtW;
logic [31:0]  ALUResultE, ALUResultM, ALUResultW;
logic [31:0] SrcAE, SrcBE, WriteDataE, WriteDataM, ReadDataM, ReadDataW, ResultW;

logic [4:0] RdW, RdM;
logic [4:0] Rs1E, Rs2E, RdE;
logic [3:0] ALUControlD, ALUControlE;
logic [2:0] ImmSrcD;
logic [2:0] ResultSrcD, ResultSrcE, ResultSrcM, ResultSrcW;
logic [1:0] ForwardAE, ForwardBE;
logic [1:0] Byte_Half_OpD, Byte_Half_OpE, Byte_Half_OpM;

logic FlushD, FlushE;
logic StallF, StallD;
logic JumpD, JumpE;
logic BranchD, BranchE;
logic ALUSrcD, ALUSrcE;
logic RegWriteD, RegWriteE, RegWriteM, RegWriteW;
logic MemWriteD, MemWriteE, MemWriteM;
logic ZeroE;
logic signD, signE, signM;
logic PCTargetSrcD, PCTargetSrcE;

assign A1 = InstrD[19:15];
assign A2 = InstrD[24:20];
assign A3 = RdW;
assign RD1 = RD1D;
assign RD2 = RD2D;
assign WD3 = ResultW;
assign WE3 = RegWriteW;
assign A = ALUResultM;
assign WD = WriteDataM;
assign RD = ReadDataM;
assign WE = MemWriteM;

//Fetch state
mux2 #(32) mux2_PC(.d0(PCPlus4F), .d1(PCTargetE), .s(PCSrcE), .y(PCNext));
ff_pc #(32) ff_pc_ut(.CLK(clk), .EN(StallF), .RST(reset), .D(PCNext), .Q(PCF));
adder pcadder4(.a(PCF), .b(32'd4), .out(PCPlus4F));
imem imem_ut( .A(PCF), .RD(InstrF));

ff_F2D ff_F2D_ut(.PCF(PCF), .PCPlus4F(PCPlus4F), .InstrF(InstrF), .CLK(clk), .EN(StallD), .CLR(FlushD), .RST(reset),
				.InstrD(InstrD), .PCD(PCD), .PCPlus4D(PCPlus4D));

//Decode
Control_Unit Control_Unit_ut(.op(InstrD[6:0]), .funct3(InstrD[14:12]), .funct7_5(InstrD[30]),
							.RegWrite(RegWriteD), .ImmSrc(ImmSrcD), .ALUSrc(ALUSrcD), .MemWrite(MemWriteD),
							.ResultSrc(ResultSrcD), .Branch(BranchD), .Jump(JumpD), .signD(signD), .ALUControl(ALUControlD), .Byte_Half_OpD(Byte_Half_OpD),
							.PCTargetSrc(PCTargetSrcD));

Register_File Register_File_ut(.A1(InstrD[19:15]), .A2(InstrD[24:20]), .A3(RdW), .WD3(ResultW),
							.CLK(clk), .RESET(reset), .WE3(RegWriteW), .RD1(RD1D), .RD2(RD2D));
                        
extend extend_ut(.instr(InstrD[31:7]), .immsrc(ImmSrcD), .immext(ImmExtD));

ff_D2E ff_D2E_ut(.CLK(clk), .CLR(FlushE), .RST(reset), .RegWriteD(RegWriteD), .MemWriteD(MemWriteD), 
                .JumpD(JumpD), .BranchD(BranchD), .ALUSrcD(ALUSrcD), .signD(signD), 
				.PCTargetSrcD(PCTargetSrcD), .ResultSrcD(ResultSrcD),
				.Byte_Half_OpD(Byte_Half_OpD), .ALUControlD(ALUControlD),
				.RD1(RD1D), .RD2(RD2D), .PCD(PCD), .ImmExtD(ImmExtD), .PCPlus4D(PCPlus4D),
				.Rs1D(InstrD[19:15]), .Rs2D(InstrD[24:20]), .RdD(InstrD[11:7]),
				.RegWriteE(RegWriteE), .MemWriteE(MemWriteE), .JumpE(JumpE), .BranchE(BranchE), .ALUSrcE(ALUSrcE),
				.signE(signE), .PCTargetSrcE(PCTargetSrcE),
				.ResultSrcE(ResultSrcE), .Byte_Half_OpE(Byte_Half_OpE), 
				.ALUControlE(ALUControlE),
				.RD1E(RD1E), .RD2E(RD2E), .PCE(PCE), .ImmExtE(ImmExtE), .PCPlus4E(PCPlus4E),
				.Rs1E(Rs1E), .Rs2E(Rs2E), .RdE(RdE));

//Execute stage
assign PCSrcE = (~ZeroE & BranchE) | JumpE;

mux3 #(32) mux3_srcAE(.d0(RD1E), .d1(ResultW), .d2(ALUResultM),
				 .s(ForwardAE), .y(SrcAE));

mux3 #(32) mux3_srcBE(.d0(RD2E), .d1(ResultW), .d2(ALUResultM),
				 .s(ForwardBE), .y(WriteDataE));

mux2 #(32) mux2_SrcBE(.d0(WriteDataE), .d1(ImmExtE), .s(ALUSrcE),
				 .y(SrcBE));

ALU ALU_ut(.ALUControl(ALUControlE), .a(SrcAE), .b(SrcBE),
				.ALUResult(ALUResultE), .Zero(ZeroE));

adder pcadder_imm(.a(PCE), .b(ImmExtE), .out(PCplusImmE));

mux2 #(32) mux2_PCTarget(.d0(PCplusImmE), .d1(ALUResultE), .s(PCTargetSrcE),
				 .y(PCTargetE));

ff_E2M ff_E2M_ut(.CLK(clk), .RST(reset), .RegWriteE(RegWriteE), .MemWriteE(MemWriteE), .signE(signE),
					.ResultSrcE(ResultSrcE), .Byte_Half_OpE(Byte_Half_OpE), 
					.ALUResult(ALUResultE), .WriteDataE(WriteDataE), .PCPlus4E(PCPlus4E),
					.PCTargetE(PCplusImmE), .ImmExtE(ImmExtE), .RdE(RdE),
					.RegWriteM(RegWriteM), .MemWriteM(MemWriteM), .signM(signM),
					.ResultSrcM(ResultSrcM), .Byte_Half_OpM(Byte_Half_OpM),
                    .ALUResultM(ALUResultM), .WriteDataM(WriteDataM), .PCPlus4M(PCPlus4M),
					.PCTargetM(PCplusImmM), .ImmExtM(ImmExtM), .RdM(RdM));

// Memory stage
Data_Memory Data_Memory_ut(.CLK(clk), .WE(MemWriteM), .signM(signM), .Byte_Half_OpM(Byte_Half_OpM), .A(ALUResultM), .WD(WriteDataM),
            .RD(ReadDataM) );

ff_M2W ff_M2W_ut(.CLK(clk), .RST(reset), .RegWriteM(RegWriteM), .ResultSrcM(ResultSrcM),
        .RdM(RdM), .ReadDataM(ReadDataM), .PCPlus4M(PCPlus4M), .ALUResultM(ALUResultM),
		.PCTargetM(PCplusImmM), .ImmExtM(ImmExtM),
        .RegWriteW(RegWriteW), .ResultSrcW(ResultSrcW), .RdW(RdW),
        .ReadDataW(ReadDataW), .PCPlus4W(PCPlus4W), .ALUResultW(ALUResultW), 
		.PCTargetW(PCplusImmW), .ImmExtW(ImmExtW));

// Writeback stage

mux_Result #(32) mux_Result_ut(.d0(ALUResultW), .d1(ReadDataW), .d2(PCPlus4W), .d3(ImmExtW), .d4(PCplusImmW),
				 .ResultSrcW(ResultSrcW),
				 .ResultW(ResultW));
						

//Harzard Unit 
Hazard_Unit Hazard_Unit_ut(.Rs1D(InstrD[19:15]), .Rs2D(InstrD[24:20]), .Rs1E(Rs1E), .Rs2E(Rs2E),
			.RdE(RdE), .RdM(RdM), .RdW(RdW), 
			.RegWriteM(RegWriteM), .RegWriteW(RegWriteW), .ResultSrcE(ResultSrcE), .PCSrcE(PCSrcE),
			.StallF(StallF), .StallD(StallD), .FlushE(FlushE), .FlushD(FlushD),
			.ForwardAE(ForwardAE), .ForwardBE(ForwardBE));

endmodule
`endif