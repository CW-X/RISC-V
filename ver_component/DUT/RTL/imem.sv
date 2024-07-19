`ifndef imem
`define imem
module imem( input logic [31:0] A,
             output logic [31:0] RD);
    logic [31:0] RAM[65536:0];

    assign RD = RAM[A[31:2]];
endmodule
`endif