module Top (//
    input clk,
    input reset,
    input [31:0] fetch_data,
    output [31:0] fetch_address,
    input [31:0] memory_read_data,
    output load_store_unsigned,
    output [1:0] memory_size,
    output [31:0] memory_address,
    output [31:0] memory_write_data,
    output memory_read,
    output memory_write,

    //new add
    output [4:0] A1, A2, A3,
    output [31:0] RD1, RD2, WD3,
    output WE3
);

    wire [31:0] id_pc, inst;
    wire [31:0] ex_pc, mem_pc, target_pc,reg_pc;//
    wire [3:0] aluop;
    wire immsrc, isbranch, memread, memwrite, regwrite;
    wire [1:0] memtoreg;
    wire pcsel, rdsel, isjump, islui;
    wire [31:0] rs1_data, rs2_data, imm;
    wire [2:0] funct3;
    wire [4:0] ex_rs1, ex_rs2, ex_rd, mem_rd, wb_rd, id_rs1, id_rs2;
    wire ex_use_rs1, ex_use_rs2, use_rs1, use_rs2, trap;
    wire mem_isbranch,mem_isjump,mem_memread,mem_memwrite,mem_regwrite,mem_zero;//
    wire [1:0]  mem_memtoreg,wb_memtoreg;//
    wire [31:0] mem_aluresult,mem_rs2_data;//
    wire [2:0] mem_funct3;//
    wire [31:0] writedata, wb_reg_pc, wb_readdata, wb_aluresult;
    wire wb_regwrite, pcsrc, branch;
    wire predict, pc_stall, if_id_stall, if_id_flush, id_ex_flush;
    wire [1:0] forward1, forward2;
    wire ex_mem_flush;

    //new for ver
    wire [31:0] rs1_data_w, rs2_data_w;


    assign A1 = id_rs1;
    assign A2 = id_rs2;
    assign A3 = wb_rd;
    assign RD1 = rs1_data_w;
    assign RD2 = rs2_data_w;
    assign WD3 = writedata;
    assign WE3 = wb_regwrite;


    Fetch fetch_inst (//
        .clock(clk),
        .reset(reset),
        .trap(trap),
        .target_pc(target_pc),
        .mem_pc(mem_pc),
        .pcsrc(pcsrc),
        .branch(branch),
        .pc_stall(pc_stall),
        .if_id_stall(if_id_stall),
        .if_id_flush(if_id_flush),
        .predict(predict),
        .id_pc(id_pc),
        .inst(inst),
        .fetch_data(fetch_data),
        .fetch_address(fetch_address)
    );

    decode decode_inst (
        .clock(clk),
        .reset(reset),
        .id_pc(id_pc),
        .inst(inst),
        .ex_pc(ex_pc),
        .aluop(aluop),
        .immsrc(immsrc),
        .isbranch(isbranch),
        .memread(memread),
        .memwrite(memwrite),
        .regwrite(regwrite),
        .memtoreg(memtoreg),
        .pcsel(pcsel),
        .rdsel(rdsel),
        .isjump(isjump),
        .islui(islui),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .imm(imm),
        .funct3(funct3),
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .ex_rd(ex_rd),
        .ex_use_rs1(ex_use_rs1),
        .ex_use_rs2(ex_use_rs2),
        .wb_rd(wb_rd),
        .wb_regwrite(wb_regwrite),
        .writedata(writedata),
        .id_ex_flush(id_ex_flush),
        .id_ex_stall(if_id_stall),
        .id_rs1(id_rs1),
        .id_rs2(id_rs2),
        .use_rs1(use_rs1),
        .use_rs2(use_rs2),
        .trap(trap),
        //new for ver
        .rs1_data_w(rs1_data_w), .rs2_data_w(rs2_data_w)
    );

    execute execute_inst (
        .clock(clk),
        .reset(reset),
        .ex_pc(ex_pc),
        .aluop(aluop),
        .immsrc(immsrc),
        .isbranch(isbranch),
        .memread(memread),
        .memwrite(memwrite),
        .regwrite(regwrite),
        .memtoreg(memtoreg),
        .pcsel(pcsel),
        .rdsel(rdsel),
        .isjump(isjump),
        .islui(islui),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .imm(imm),
        .funct3(funct3),
        .ex_rs1(ex_rs1),
        .ex_rd(ex_rd),
        .mem_pc(mem_pc),
        .target_pc(target_pc),
        .reg_pc(reg_pc),
        .mem_isbranch(mem_isbranch),
        .mem_isjump(mem_isjump),
        .mem_memread(mem_memread),
        .mem_memwrite(mem_memwrite),
        .mem_regwrite(mem_regwrite),
        .mem_memtoreg(mem_memtoreg),
        .mem_zero(mem_zero),
        .mem_aluresult(mem_aluresult),
        .mem_rs2_data(mem_rs2_data),
        .mem_funct3(mem_funct3),
        .mem_rd(mem_rd),
        .writedata(writedata),
        .forward1(forward1),
        .forward2(forward2),
        .ex_mem_flush(ex_mem_flush)
    );

    memory memory_inst (
        .clock(clk),
        .reset(reset),
        .reg_pc(reg_pc),
        .mem_isbranch(mem_isbranch),
        .mem_isjump(mem_isjump),
        .mem_memread(mem_memread),
        .mem_memwrite(mem_memwrite),
        .mem_regwrite(mem_regwrite),
        .mem_memtoreg(mem_memtoreg),
        .mem_zero(mem_zero),
        .mem_aluresult(mem_aluresult),
        .mem_rs2_data(mem_rs2_data),
        .mem_funct3(mem_funct3),
        .mem_rd(mem_rd),
        .wb_reg_pc(wb_reg_pc),
        .wb_readdata(wb_readdata),
        .wb_aluresult(wb_aluresult),
        .wb_memtoreg(wb_memtoreg),
        .wb_regwrite(wb_regwrite),
        .wb_rd(wb_rd),
        .pcsrc(pcsrc),
        .branch(branch),
        .memory_read_data(memory_read_data),
        .load_store_unsigned(load_store_unsigned),
        .memory_size(memory_size),
        .memory_address(memory_address),
        .memory_write_data(memory_write_data),
        .memory_read(memory_read),
        .memory_write(memory_write)
    );

    writeback writeback_inst (
        .wb_reg_pc(wb_reg_pc),
        .wb_readdata(wb_readdata),
        .wb_aluresult(wb_aluresult),
        .wb_memtoreg(wb_memtoreg),
        .writedata(writedata)
    );

    hazard hazard_inst (
        .isbranch(branch),
        .predict(predict),
        .pc_stall(pc_stall),
        .if_id_stall(if_id_stall),
        .if_id_flush(if_id_flush),
        .trap(trap),
        .memread(memread),
        .use_rs1(use_rs1),
        .use_rs2(use_rs2),
        .id_rs1(id_rs1),
        .id_rs2(id_rs2),
        .ex_rd(ex_rd),
        .ex_use_rs1(ex_use_rs1),
        .ex_use_rs2(ex_use_rs2),
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .ex_pc(ex_pc),
        .id_ex_flush(id_ex_flush),
        .mem_rd(mem_rd),
        .mem_regwrite(mem_regwrite),
        .mem_pc(mem_pc),
        .target_pc(target_pc),
        .forward1(forward1),
        .forward2(forward2),
        .ex_mem_flush(ex_mem_flush),
        .wb_rd(wb_rd),
        .wb_regwrite(wb_regwrite),
        .pcsrc(pcsrc),
        .mem_memtoreg(mem_memtoreg)
    );

endmodule
