`ifndef Register_File
`define Register_File
module Register_File(input logic [4:0] A1, A2, A3,
							input logic [31:0] WD3,
							input logic CLK, RESET, WE3,
							output logic [31:0] RD1, RD2);
							
	logic [31:0] rf[31:0];
	always @(*) begin 
		RD1 = (A1 == 0)? 32'b0 : rf[A1];
		RD2 = (A2 == 0)? 32'b0 : rf[A2];
	end
	
	integer i;
	always @(negedge CLK or posedge RESET) begin
        if (RESET) begin
            for(i=0;i<32;i=i+1) begin
                rf[i] <= 32'b0;
            end     
        end else if (WE3 && A3 != 5'b0) begin
            if(WE3) rf[A3] <= WD3;
        end
    end

endmodule
`endif