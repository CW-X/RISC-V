`ifndef ff_pc
`define ff_pc
module ff_pc #(parameter WIDTH = 32)
            (input logic CLK, EN, RST,
            input logic [WIDTH-1:0] D,
            output logic [WIDTH-1:0] Q );
    always_ff @ (posedge CLK, posedge RST) begin
        if (RST) Q <= 0;
        else if (EN == 1'b0 | EN === 1'bx) Q <= D;
    end
endmodule
`endif
