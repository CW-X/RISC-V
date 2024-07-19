`timescale 1ns / 1ps

module writeback (
    //input   [31:0]  csr_read_data_in,//
    input   [31:0]  wb_reg_pc,
    input   [31:0]  wb_readdata,
    input   [31:0]  wb_aluresult,
    input   [1:0]  wb_memtoreg,
    output reg  [31:0]  writedata
);

always @(*) begin
    case(wb_memtoreg)
        2'b00: writedata = wb_reg_pc;
        2'b01: writedata = wb_readdata;
        2'b10: writedata = wb_aluresult;
        //2'b11: writedata = csr_read_data_in;//
        default: writedata = 32'b0; // Error handling
    endcase
end

endmodule

