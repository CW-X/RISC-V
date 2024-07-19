/*** 
 * Author: Stephen Dai
 * Date: 2023-08-23 20:28:52
 * LastEditors: Stephen Dai
 * LastEditTime: 2023-08-24 09:48:16
 * FilePath: \Code\Project\RISCV\rtl\dual_ram.v
 * Description: 
 * 
 */
module dual_ram #(
    parameter DW        = 32                 , //数据位宽data_width
    parameter MEM_DEPTH = 65536               
    //parameter AW        = $clog2(MEM_DEPTH)    //地址位宽addr_width
)(
    input                              clk      ,
    input                              rst_n    ,
    input      [$clog2(MEM_DEPTH)-1:0] Ir_addr_i ,
    output reg [DW-1:0]                Ir_data_o ,
    input                              wen      , //写使能
    input      [$clog2(MEM_DEPTH)-1:0] w_addr_i , //写地址，地址位宽根据MEM_DEPTH确定
    input      [DW-1:0]                w_data_i , //写数据
    input                              ren      , //读使能
    input      [$clog2(MEM_DEPTH)-1:0] r_addr_i , //读地址
    output reg [DW-1:0]                r_data_o   //读数据
);

//reg [DW-1:0] r_data_o;
reg[DW-1:0] mem[0:MEM_DEPTH-1]; //定义MEM_NUM×DW存储器，MEM_NUM个位宽为DW的寄存器

always @(*) begin
    Ir_data_o <= mem[Ir_addr_i];
    if(ren)
        r_data_o <= mem[r_addr_i]; //读出
end


always @(posedge clk) begin
    if(wen)
        mem[w_addr_i] <= w_data_i; //写入	
end

endmodule
