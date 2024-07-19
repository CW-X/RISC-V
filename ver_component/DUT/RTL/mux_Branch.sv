`ifndef mux_Branch
`define mux_Branch
module mux_Branch #(parameter WIDTH=32)
				(input logic ZeroE,
				 input logic [2:0] funct3E,
				 output logic y);
                 
	logic not_ZeroE;
    logic [1:0] s;
    assign s = ~funct3E[2] & ~funct3E[1] & funct3E[0];
    assign not_ZeroE = ~ ZeroE;

    always_comb
    begin
        case(s)
        1'b0: y = ZeroE;
        1'b1: y = not_ZeroE;
        default : y = ZeroE;
        endcase
    end
				
endmodule
`endif