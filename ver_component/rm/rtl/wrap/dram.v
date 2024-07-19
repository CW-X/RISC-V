/*** 
 * Author: Stephen Dai
 * Date: 2023-08-21 10:00:56
 * LastEditors: Stephen Dai
 * LastEditTime: 2023-08-25 16:22:22
 * FilePath: \Code\Project\RISCV\rtl\dram.v
 * Description: 
 * 
 */

 `include "defines.v"

module dram (
    input             clk      ,
    input             rst_n    ,
    input      [31:0] Ir_addr_i,
    output reg [31:0] Ir_data_o,
    input      [2:0]  mem_op   , 
    input             wen      ,
    input             ren      ,
    input      [31:0] addr     , //读写同地址
    input      [31:0] w_data_i , //写入数据
    output reg [31:0] r_data_o   //读出数据
);

reg [31:0] w_data; //重构的dram写入数据
reg [31:0] r_data; //dram读出数据

//SB、SH、SW写入数据
always @(*) begin
    if(wen == 1'b1)
        case(mem_op)
            `SB_TYPE: begin             //addr[1:0]用于选择ram，按字节存储，前面n位用于地址索引
                if(addr[1:0] == 2'b00) //根据addr[1:0]加载不同字节，字符扩展
                    w_data = {24'd0, w_data_i[7:0]};
                else if (addr[1:0] == 2'b01)
                    w_data = {16'd0, w_data_i[7:0],8'd0};
                else if (addr[1:0] == 2'b10)
                    w_data = {8'd0, w_data_i[7:0],16'd0};
                else if (addr[1:0] == 2'b11)
                    w_data = {w_data_i[7:0],24'd0};
                    else 
                    w_data = 32'd0;
            end

            `SH_TYPE: begin
                if(addr[1:0] == 2'b00)
                    w_data = {16'd0,w_data_i[15:0]};
                else if(addr[1:0] == 2'b10)
                    w_data = {w_data_i[15:0],16'd0};
                else 
                    w_data = 32'd0;
            end

            `SW_TYPE: w_data = w_data_i; 
            default: w_data = 32'd0;
        endcase
end

//LB、LH、LW、LBU、LHU加载数据
always @(*) begin
    if(ren == 1'b1)
        case(mem_op)
            `LB_TYPE:begin
                if(addr[1:0]== 2'b00) //根据addr[1:0]加载不同字节，零扩展
                    r_data_o = {{24{r_data[7]}},r_data[7:0]};
                else if(addr[1:0]== 2'b01)
                    r_data_o = {{24{r_data[15]}},r_data[15:8]};
                else if(addr[1:0]== 2'b10)
                    r_data_o = {{24{r_data[23]}},r_data[23:16]};
                else if(addr[1:0]== 2'b11)
                    r_data_o = {{24{r_data[31]}},r_data[31:24]};
                else
                    r_data_o = 32'd0;
            end
            `LH_TYPE:begin
                if(addr[1:0] == 2'b00)
                    r_data_o = {{16{r_data[15]}},r_data[15:0]}; 
                else if(addr[1:0] == 2'b10)
                    r_data_o = {{16{r_data[31]}},r_data[31:16]}; 
                else 
                    r_data_o = 32'd0;  
            end
            `LW_TYPE:begin
                    r_data_o = r_data; 
            end
            `LBU_TYPE:begin
                if(addr[1:0]== 2'b00)
                    r_data_o = {24'd0,r_data[7:0]};
                else if(addr[1:0]== 2'b01)
                    r_data_o = {24'd0,r_data[15:8]};
                else if(addr[1:0]== 2'b10)
                    r_data_o = {24'd0,r_data[23:16]};
                else if(addr[1:0]== 2'b11)
                    r_data_o = {24'd0,r_data[31:24]};
                else
                    r_data_o = 32'd0;
            end
            `LHU_TYPE:begin
                if(addr[1:0] == 2'b00)
                    r_data_o = {16'd0,r_data[15:0]}; 
                else if(addr[1:0] == 2'b10)
                    r_data_o = {16'd0,r_data[31:16]}; 
                else 
                    r_data_o = 32'd0;  
            end
            default:r_data_o = 32'd0;
        endcase
end

//32×1024的存储器
dual_ram 
#(
    .DW        (32        ),
    .MEM_DEPTH (65536     )
)
u_dual_ram(
    .clk      (clk          ),
    .rst_n    (rst_n        ),
    .Ir_addr_i(Ir_addr_i[17:2]),
    .Ir_data_o(Ir_data_o    ),
    .wen      (wen          ),
    .w_addr_i (addr[17:2]   ),
    .w_data_i (w_data       ),
    .ren      (ren          ),
    .r_addr_i (addr[17:2]   ),
    .r_data_o (r_data     )
);
    
endmodule
