`ifndef ff_M2W
`define ff_M2W
module ff_M2W(input logic CLK, RST, RegWriteM,
                input logic [2:0] ResultSrcM,
                input logic [4:0] RdM,
                input logic [31:0] ReadDataM, PCPlus4M, ALUResultM, PCTargetM, ImmExtM, 
                output logic RegWriteW,
                output logic [2:0] ResultSrcW,
                output logic [4:0] RdW,
                output logic [31:0] ReadDataW, PCPlus4W, ALUResultW, PCTargetW, ImmExtW
                );
    always_ff @( posedge CLK, posedge RST) begin
        if (RST) begin
        RegWriteW <= 0;
        ResultSrcW <= 0;
        RdW <= 0;
        ReadDataW <= 0;
        PCPlus4W <= 0;
        ALUResultW <= 0;
        PCTargetW <= 0;
        ImmExtW <= 0;
        end
        
        else begin
        RegWriteW <= RegWriteM;
        ResultSrcW <= ResultSrcM;
        RdW <= RdM;
        ReadDataW <= ReadDataM;
        PCPlus4W <= PCPlus4M;
        ALUResultW <= ALUResultM;
        PCTargetW <= PCTargetM;
        ImmExtW <= ImmExtM;
        end
    end
endmodule
`endif