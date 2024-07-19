`timescale 1ns / 1ps

module decode(
    input clock, 
    input reset, 
    input [31:0] id_pc, 
    input [31:0] inst, 
    input [4:0] wb_rd, 
    input wb_regwrite, 
    input [31:0] writedata, 
    input id_ex_flush,
    input id_ex_stall,
    output reg [31:0] ex_pc, 
    output reg [3:0] aluop, 
    output reg immsrc, 
    output reg isbranch, 
    output reg memread, 
    output reg memwrite, 
    output reg regwrite, 
    output reg [1:0] memtoreg, 
    output reg pcsel, 
    output reg rdsel, 
    output reg isjump, 
    output reg islui, 
    output reg [31:0] rs1_data, 
    output reg [31:0] rs2_data, 
    output reg [31:0] imm, 
    output reg [2:0] funct3, 
    output reg [4:0] ex_rs1, 
    output reg [4:0] ex_rs2, 
    output reg [4:0] ex_rd, 
    output reg ex_use_rs1, 
    output reg ex_use_rs2, 
    output  trap, 
    output  [4:0] id_rs1, 
    output  [4:0] id_rs2, 
    output  use_rs1, 
    output  use_rs2,
    //new add for ver
    output [31:0] rs1_data_w, rs2_data_w
);

    wire [3:0] aluop_w;
    wire immsrc_w, isbranch_w, memread_w, memwrite_w, regwrite_w;
    wire [1:0] memtoreg_w;
    wire pcsel_w, rdsel_w, isjump_w, islui_w, use_rs1_w, use_rs2_w;
    wire [31:0] rs1_data_w, rs2_data_w, imm_w;

    assign id_rs1 = (id_ex_flush == 0)? inst[19:15]:4'b0;
	assign id_rs2 = (id_ex_flush == 0)? inst[24:20]:4'b0;
	assign use_rs1 = (id_ex_flush == 0)? use_rs1_w:1'b0;
	assign use_rs2 = (id_ex_flush == 0)? use_rs2_w:1'b0;
    //assign trap = (inst == 32'h00000073 && id_ex_flush == 0) ? 1'b1 : 1'b0;

    Control ctrl_inst(
        .opcode(inst[6:0]),
        .funct7(inst[31:25]),
        .funct3(inst[14:12]),
        .aluop(aluop_w),
        .immsrc(immsrc_w),
        .isbranch(isbranch_w),
        .memread(memread_w),
        .memwrite(memwrite_w),
        .regwrite(regwrite_w),
        .memtoreg(memtoreg_w),
        .pcsel(pcsel_w),
        .rdsel(rdsel_w),
        .isjump(isjump_w),
        .islui(islui_w),
        .use_rs1(use_rs1_w),
        .use_rs2(use_rs2_w)
    );

    Regfile rf_inst(
        .clock(clock),
        .reset(reset),
        .id_rs1(inst[19:15]),
        .id_rs2(inst[24:20]),
        .wb_rd(wb_rd),
        .writedata(writedata),
        .wb_regwrite(wb_regwrite),
        .rs1_data(rs1_data_w),
        .rs2_data(rs2_data_w)
    );

    ImmGen immgen_inst(
        .inst(inst),
        .imm(imm_w)
    );

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            ex_pc <= 0;
            aluop <= 0;
            immsrc <= 0;
            isbranch <= 0;
            memread <= 0;
            memwrite <= 0;
            regwrite <= 0;
            memtoreg <= 0;
            pcsel <= 0;
            rdsel <= 0;
            isjump <= 0;
            islui <= 0;
            rs1_data <= 0;
            rs2_data <= 0;
            imm <= 0;
            funct3 <= 0;
            ex_rs1 <= 0;
            ex_rs2 <= 0;
            ex_rd <= 0;
            ex_use_rs1 <= 0;
            ex_use_rs2 <= 0;
        end else if (id_ex_flush || id_ex_stall) begin
            ex_pc <= 0;
            aluop <= 0;
            immsrc <= 0;
            isbranch <= 0;
            memread <= 0;
            memwrite <= 0;
            regwrite <= 0;
            memtoreg <= 0;
            pcsel <= 0;
            rdsel <= 0;
            isjump <= 0;
            islui <= 0;
            rs1_data <= 0;
            rs2_data <= 0;
            imm <= 0;
            funct3 <= 0;
            ex_rs1 <= 0;
            ex_rs2 <= 0;
            ex_rd <= 0;
            ex_use_rs1 <= 0;
            ex_use_rs2 <= 0;
        
        end else begin
            ex_pc <= id_pc;
            aluop <= aluop_w;
            immsrc <= immsrc_w;
            isbranch <= isbranch_w;
            memread <= memread_w;
            memwrite <= memwrite_w;
            regwrite <= regwrite_w;
            memtoreg <= memtoreg_w;
            pcsel <= pcsel_w;
            rdsel <= rdsel_w;
            isjump <= isjump_w;
            islui <= islui_w;
            rs1_data <= rs1_data_w;
            rs2_data <= rs2_data_w;
            imm <= imm_w;
            funct3 <= inst[14:12];
            ex_rs1 <= inst[19:15];
            ex_rs2 <= inst[24:20];
            ex_rd <= inst[11:7];
            ex_use_rs1 <= use_rs1_w;
            ex_use_rs2 <= use_rs2_w;
        end
    end

endmodule

