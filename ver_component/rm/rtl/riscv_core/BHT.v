	`timescale 1ns / 1ps
	
	module BHT (
	    input clock,
	    input reset,
	    input [31:0] pc,
	    input [31:0] mem_pc,
	    input pcsrc,
	    input [31:0] target_pc,
	    output  match,
	    output  valid,
	    output  [31:0] bht_pred_pc
	);
	
	    reg [25:0] tag [15:0];
	    reg valid_bit [15:0];
	    reg [31:0] target [15:0];
	    integer i;
		assign match=(tag[pc[5:2]] == pc[31:6])?1'b1:1'b0;
 		assign valid=(tag[pc[5:2]] == pc[31:6])?valid_bit[pc[5:2]]:1'b0;
 		assign bht_pred_pc=(tag[pc[5:2]] == pc[31:6])?target[pc[5:2]]:32'b0;
	
	    always @(posedge clock or posedge reset) begin
	        if (reset) begin
	            for (i = 0; i < 16; i = i + 1) begin
	                tag[i] <= 26'b0;
	                valid_bit[i] <= 1'b0;
	                target[i] <= 32'b0;
	            end
	        end else begin
	            if (pcsrc) begin
	                tag[mem_pc[5:2]] <= mem_pc[31:6];
	                valid_bit[mem_pc[5:2]] <= 1'b1;
	                target[mem_pc[5:2]] <= target_pc;
	            end
	            end
	    end
	
	endmodule