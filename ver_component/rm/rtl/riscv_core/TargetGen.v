`timescale 1ns / 1ps

module TargetGen(
    input [31:0] ex_pc,
    input [31:0] imm,
    input [31:0] alu_result,
    input pcsel,
    input rdsel,
    output reg [31:0] reg_pc,
    output reg [31:0] target_pc
);

    assign target_pc = (pcsel) ? alu_result : (ex_pc + imm);
    assign reg_pc = (rdsel) ? (ex_pc + imm) : (ex_pc + 4);

endmodule