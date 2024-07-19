`timescale 1ns / 1ps

module BTB (
    input clock,
    input reset,
    input [31:0] pc,
    input [31:0] mem_pc,
    input pcsrc,
    input branch,
    output btb_taken
);

    reg [1:0] counter [0:15];
    wire [3:0] index;
    integer i;
    assign index = pc[5:2];
    assign btb_taken = (counter[index] > 2'b01) ? 1'b1 : 1'b0;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                counter[i] <= 2'b01;
            end
        end else if (branch) begin
            if (pcsrc) begin
                if (counter[mem_pc[5:2]] < 2'b11) begin
                    counter[mem_pc[5:2]] <= counter[mem_pc[5:2]] + 1;
                end
            end else begin
                if (counter[mem_pc[5:2]] > 2'b00) begin
                    counter[mem_pc[5:2]] <= counter[mem_pc[5:2]] - 1;
                end
            end
        end
    end

endmodule
