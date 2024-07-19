
`timescale 1ns / 1ps

module Branch(//
    input mem_zero,
    input [31:0] mem_aluresult,
    input [2:0] mem_funct3,
    input mem_isbranch,
    input mem_isjump,
    output reg branch,
    output reg pcsrc
);

always @(*) begin
    branch = mem_isbranch;
    if (mem_isjump) begin
        pcsrc = 1'b1;
    end else if (mem_isbranch) begin
        case (mem_funct3)
            3'b000: pcsrc = mem_zero;
            3'b001: pcsrc = ~mem_zero;
            3'b100: pcsrc = mem_aluresult[0];
            3'b101: pcsrc = ~mem_aluresult[0];
            3'b110: pcsrc = mem_aluresult[0];
            3'b111: pcsrc = ~mem_aluresult[0];
            default: pcsrc = 1'b0;
        endcase
    end else begin
        pcsrc = 1'b0;
    end
end

endmodule

