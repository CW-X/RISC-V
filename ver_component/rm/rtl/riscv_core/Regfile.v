`timescale 1ns / 1ps

module Regfile (
    input clock,
    input reset,
    input [4:0] id_rs1,
    input [4:0] id_rs2,
    input [4:0] wb_rd,
    input [31:0] writedata,
    input wb_regwrite,
    output reg [31:0] rs1_data,
    output reg [31:0] rs2_data
);

    reg [31:0] regfile [31:0];

    // Read ports
    always @(*) begin
        rs1_data = regfile[id_rs1];
        rs2_data = regfile[id_rs2];
    end

    // Write port
    integer i;//
    always @(negedge clock or posedge reset) begin
        if (reset) begin
        //    regfile <= '{default:0};
            for(i=0;i<32;i=i+1) begin
                regfile[i] <= 32'b0;
            end     
        end else if (wb_regwrite && wb_rd != 5'b0) begin
            regfile[wb_rd] <= writedata;
        end
    end

endmodule