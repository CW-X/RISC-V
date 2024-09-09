	module BTB (
	    input clock,
	    input reset,
	    input [31:0] PC,
	    input [31:0] PCM,
	    input pcsrc,
	    input [31:0] target_PC,
	    output  match,
	    output  valid,
	    output  [31:0] btb_pred_pc
	);
	
	    reg [25:0] tag [15:0];
	    reg valid_bit [15:0];
	    reg [31:0] target [15:0];
	    integer i;
		assign match=(tag[PC[5:2]] == PC[31:6])?1'b1:1'b0;
 		assign valid=(tag[PC[5:2]] == PC[31:6])?valid_bit[PC[5:2]]:1'b0;
 		assign btb_pred_pc=(tag[PC[5:2]] == PC[31:6])?target[PC[5:2]]:32'b0;
	
	    always @(posedge clock or posedge reset) begin
	        if (reset) begin
	            for (i = 0; i < 16; i = i + 1) begin
	                tag[i] <= 26'b0;
	                valid_bit[i] <= 1'b0;
	                target[i] <= 32'b0;
	            end
	        end else begin
	            if (pcsrc) begin
	                tag[PCM[5:2]] <= PCM[31:6];
	                valid_bit[PCM[5:2]] <= 1'b1;
	                target[PCM[5:2]] <= target_pc;
	            end
	            end
	    end
	
	endmodule