/*** 
 * Author: Stephen Dai
 * Date: 2023-08-21 10:00:56
 * LastEditors: Stephen Dai
 * LastEditTime: 2023-09-01 10:15:26
 * FilePath: \Code\Project\RISCV_from_0_to_1\RISCV_V3\rtl\wrap\iram.v
 * Description: 
 * 
 */

module iram #(
    parameter DW        = 32,
    parameter MEM_DEPTH = 1024 //2^10
)
(
    input         clk       ,
    input         rst_n     ,
    input  [31:0] r_addr_i  ,
    output [31:0] r_data_o
);
    
    dual_ram 
    #(
        .DW        (DW       ),
        .MEM_DEPTH (MEM_DEPTH) 
    )
    dual_ram_inst1(
    	.clk      (clk                              ),
        .rst_n    (rst_n                            ),
        .wen      (1'b0                             ),
        .w_addr_i ({$clog2(MEM_DEPTH){1'b0}}        ),
        .w_data_i (32'b0                            ),
        .ren      (1'b1                             ),
        .r_addr_i (r_addr_i[$clog2(MEM_DEPTH)+1:2]  ), //最后两位用于四字节对齐，[$clog2(MEM_DEPTH)+1:2]用于地址索引
        .r_data_o (r_data_o                         )
    );
    
endmodule
