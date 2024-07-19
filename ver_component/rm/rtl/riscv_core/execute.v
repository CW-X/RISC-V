module execute(
input clock,
input reset,
input [31:0] ex_pc,
input [3:0] aluop,
input immsrc,
input isbranch,
input memread,
input memwrite,
input regwrite,
input [1:0] memtoreg,
input pcsel,
input rdsel,
input isjump,
input islui,
input [31:0] rs1_data,
input [31:0] rs2_data,
input [31:0] imm,
input [2:0] funct3,//向量修改
input [4:0] ex_rs1,
input [4:0] ex_rd,
output reg [31:0] mem_pc,
output reg [31:0] target_pc,
output reg [31:0] reg_pc,
output reg mem_isbranch,
output reg mem_isjump,
output reg mem_memread,
output reg mem_memwrite,
output reg mem_regwrite,
output reg [1:0] mem_memtoreg,
output reg mem_zero,
output reg [31:0] mem_aluresult,
output reg [31:0] mem_rs2_data,
output reg [2:0] mem_funct3,
output reg [4:0] mem_rd,
input [31:0] writedata,
input [1:0] forward1,
input [1:0] forward2,
input ex_mem_flush
);

wire [31:0] alu_in1, alu_in2, alu_result;
wire [31:0] target_pc_w,reg_pc_w,mem_aluresult_w;//
reg  [31:0] mem_rs2_data_w;
wire zero;
reg  mem_forward_sel;//
assign mem_aluresult_w = (mem_forward_sel)? reg_pc : mem_aluresult;//
always @(*) begin
    case (forward2)
        2'b01: mem_rs2_data_w = mem_aluresult_w;
        2'b10: mem_rs2_data_w = writedata;
        default:  mem_rs2_data_w = rs2_data;
    endcase
end

AluSelect aluselect(
.rs1_data(rs1_data),
.rs2_data(rs2_data),
.imm(imm),
.mem_aluresult(mem_aluresult_w),//
.writedata(writedata),
.immsrc(immsrc),
.islui(islui),
.forward1(forward1),
.forward2(forward2),
.alu_in1(alu_in1),
.alu_in2(alu_in2)
);

ALU_rm alu(
.alu_in1(alu_in1),
.alu_in2(alu_in2),
.aluop(aluop),
.zero(zero),
.alu_result(alu_result)
);

TargetGen targetGen(
.ex_pc(ex_pc),
.imm(imm),
.alu_result(alu_result),
.pcsel(pcsel),
.rdsel(rdsel),
.reg_pc(reg_pc_w),//
.target_pc(target_pc_w)//
);

always @(posedge clock or posedge reset) begin
if (reset) begin//
mem_isbranch <= 0;
mem_isjump <= 0;
mem_memread <= 0;
mem_memwrite <= 0;
mem_regwrite <= 0;
mem_memtoreg <= 0;
mem_zero <= 0;
mem_aluresult <= 0;
mem_rs2_data <= 0;
mem_funct3 <= 0;
mem_rd <= 0;
mem_pc <= 0;//
target_pc <= 0;//
reg_pc <= 0;//
mem_forward_sel <= 0;//
end else if (ex_mem_flush) begin
mem_isbranch <= 0;
mem_isjump <= 0;
mem_memread <= 0;
mem_memwrite <= 0;
mem_regwrite <= 0;
mem_memtoreg <= 0;
mem_zero <= 0;
mem_aluresult <= 0;
mem_rs2_data <= 0;
mem_funct3 <= 0;
mem_rd <= 0;
mem_pc <= 0;//
target_pc <= 0;//
reg_pc <= 0;//
mem_forward_sel <= 0;//
end else if (!ex_mem_flush) begin
mem_isbranch <= isbranch;
mem_isjump <= isjump;
mem_memread <= memread;
mem_memwrite <= memwrite;
mem_regwrite <= regwrite;
mem_memtoreg <= memtoreg;
mem_zero <= zero;
mem_aluresult <= alu_result;
mem_rs2_data <= mem_rs2_data_w;
mem_funct3 <= funct3;
mem_rd <= ex_rd;
mem_pc <= ex_pc;//
target_pc <= target_pc_w;//
reg_pc <= reg_pc_w;//
mem_forward_sel <= isjump || rdsel || pcsel;//
end
end
endmodule
