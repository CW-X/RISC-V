`ifndef riscv_soc
`define riscv_soc
module riscv_soc(
    input clk   ,
    input reset,
    output [4:0] A1, A2, A3,
    output [31:0] RD1, RD2, WD3,
    output WE3,
    output [31:0] A, WD, RD,
    output WE
);

//===============================================================================
//Signal declaration
//===============================================================================

//from riscv_core
wire [2:0]  mem_op_out  ;
wire [31:0] iram_addr   ; 
wire        dram_wen    ; 
wire        dram_ren    ; 
wire [31:0] dram_addr   ; 
wire [31:0] data_to_dram;   

//from iram
wire [31:0] iram_out    ;

//from dram
wire [31:0] dram_out    ;

assign A = dram_addr;
assign WD = data_to_dram;
assign RD = dram_out;
assign WE = dram_wen;
//==============================================================================
//Main code
//===============================================================================

Top u_riscv_core(
    .clk                    (clk           ),
    .reset                  (reset         ),
    .fetch_data             (iram_out      ), 
    .fetch_address          (iram_addr     ),  
    .memory_read_data       (dram_out      ), 
    .load_store_unsigned    (mem_op_out[2] ), 
    .memory_size            (mem_op_out[1:0]), 
    .memory_address         (dram_addr     ), 
    .memory_write_data      (data_to_dram  ), 
    .memory_read            (dram_ren      ),  
    .memory_write           (dram_wen      ),
    //NEW ADD
    .A1(A1), 
    .A2(A2), 
    .A3(A3),
    .RD1(RD1),
    .RD2(RD2), 
    .WD3(WD3),
    .WE3(WE3)
);

Datamemory u_dram(
    .addr(dram_addr), 
    .dataout(dram_out), 
    .datain(data_to_dram), 
    .wrclk(clk), 
    .memop(mem_op_out), 
    .we(dram_wen), 
    .re(dram_ren)
    );

Instmemory u_iram(
    .iaddr(iram_addr), 
    .idataout(iram_out)
    );

endmodule
`endif