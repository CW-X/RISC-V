`timescale 1ns / 1ps

module BTB (
    input clock,
    input reset,
    input [31:0] PC,
    input [31:0] PCM,
    input pcsrc,
    input branch,
    output bht_taken
);

    reg [1:0] counter [0:15];
    wire [3:0] index;
    integer i;
    assign index = PC[5:2];
    assign bht_taken = (counter[index] > 2'b01) ? 1'b1 : 1'b0;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                counter[i] <= 2'b01;
            end
        end else if (branch) begin
            if (pcsrc) begin
                if (counter[PCM[5:2]] < 2'b11) begin
                    counter[PCM[5:2]] <= counter[PCM[5:2]] + 1;
                end
            end else begin
                if (counter[PCM[5:2]] > 2'b00) begin
                    counter[PCM[5:2]] <= counter[PCM[5:2]] - 1;
                end
            end
        end
    end

endmodule
