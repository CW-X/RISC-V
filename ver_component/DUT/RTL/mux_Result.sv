`ifndef mux_Result
`define mux_Result
module mux_Result #(parameter WIDTH=32)
				(input logic [WIDTH-1:0] d0, d1, d2, d3, d4,
				 input logic [2:0] ResultSrcW,
				 output logic [WIDTH-1:0] ResultW);
    always_comb
    begin
        case(ResultSrcW)
        3'b000: ResultW = d0;
        3'b001: ResultW = d1;
        3'b010: ResultW = d2;
        3'b011: ResultW = d3;
        3'b100: ResultW = d4;
        default : ResultW = 32'd0;
        endcase
    end
				
endmodule
`endif