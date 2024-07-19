/*** 
 * Author: Stephen Dai
 * Date: 2023-08-22 20:36:05
 * LastEditors: Stephen Dai
 * LastEditTime: 2023-08-30 22:47:53
 * FilePath: \ShareFolder\RISCV_V3\tb\riscv_soc_tb.v
 * Description: 
 * 
 */
module riscv_soc_tb;

	reg clk;
	reg rst;
	wire x3  = riscv_soc_tb.u_riscv_soc.u_riscv_core.decode_inst.rf_inst.regfile[3] ; 
	wire x26 = riscv_soc_tb.u_riscv_soc.u_riscv_core.decode_inst.rf_inst.regfile[26];
	wire x27 = riscv_soc_tb.u_riscv_soc.u_riscv_core.decode_inst.rf_inst.regfile[27];
	
	always #5 clk = ~clk;
	
	initial begin
		clk <= 1'b1 ;
		rst <= 1'b1;
		#50;
		rst <= 1'b0;	
	end



	initial begin
		wait(x26 == 32'b1);
		
		#200;
		if(x27 == 32'b1) begin
			$display("############################");
			$display("########  pass  !!!#########");
			$display("############################");
			// for(r = 0;r < 32; r = r + 1)begin
			// 	$display("x%2d register value is %d",r,riscv_soc_tb.u_riscv_soc.u_riscv_core.decode_inst.rf_inst.regfile[r]);	
			// end	
		end
		else begin
			$display("############################");
			$display("########  fail  !!!#########");
			$display("############################");
			$display("fail testnum = %2d", x3);
			for(r = 0;r < 32; r = r + 1)begin
				$display("x%2d register value is %d",r,riscv_soc_tb.u_riscv_soc.u_riscv_core.decode_inst.rf_inst.regfile[r]);	
			end	
		end
		
		$finish;
	end
	
	initial begin
      $fsdbDumpfile("sim.fsdb");
      $fsdbDumpvars();
    end

	riscv_soc u_riscv_soc(
		.clk   (clk   ),
		.reset (rst   )
	);
	
	
//ram 初始值
    integer i;
	initial begin
		for(i=0; i < 65537; i=i+1) begin
		    riscv_soc_tb.u_riscv_soc.u_iram.ram[i] = 0;
        end

		for(i=0; i < 262145; i=i+1) begin
		    riscv_soc_tb.u_riscv_soc.u_dram.mymem.ram[i] = 0;
        end

		/*************************************************   R-type   *************************************************************/
	    if ($test$plusargs("add")) begin 
		$display("############################"); $display("######## add test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-add.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);//将指令写入iram
		end
		if ($test$plusargs("sub")) begin 
		$display("############################"); $display("######## sub test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-sub.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("sll")) begin 
		$display("############################"); $display("######## sll test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-sll.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end   
		if ($test$plusargs("slt")) begin 
		$display("############################"); $display("######## slt test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-slt.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("sltu")) begin 
		$display("############################"); $display("########  sltu test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-sltu.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("xor")) begin 
		$display("############################"); $display("######## xor test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-xor.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("srl")) begin 
		$display("############################"); $display("######## srl test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-srl.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("sra")) begin 
		$display("############################"); $display("######## sra test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-sra.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("or")) begin 
		$display("############################"); $display("######## or test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-or.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("and")) begin 
		$display("############################"); $display("######## and test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-and.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		/*************************************************   U-type   *************************************************************/
		if ($test$plusargs("lui")) begin 
		$display("############################"); $display("######## lui test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-lui.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("auipc")) begin 
		$display("############################"); $display("######## auipc test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-auipc.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		/*************************************************    Jump   *************************************************************/
		if ($test$plusargs("jal")) begin 
		$display("############################"); $display("######## jal test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-jal.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("jalr")) begin 
		$display("############################"); $display("######## jalr test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-jalr.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		/*************************************************   B-type   *************************************************************/
		if ($test$plusargs("beq")) begin 
		$display("############################"); $display("######## beq test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-beq.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("bne")) begin 
		$display("############################"); $display("######## bne test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-bne.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("blt")) begin 
		$display("############################"); $display("######## blt test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-blt.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("bge")) begin 
		$display("############################"); $display("######## bge test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-bge.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("bltu")) begin 
		$display("############################"); $display("######## bltu test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-bltu.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("bgeu")) begin 
		$display("############################"); $display("######## bgeu test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-bgeu.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		/*************************************************   L-type   *************************************************************/
		if ($test$plusargs("lb")) begin 
		$display("############################"); $display("######## lb test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-lb.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		$readmemh("../tb/inst_txt/rv32ui-p-lb.txt",riscv_soc_tb.u_riscv_soc.u_dram.mymem.ram);
		end
		if ($test$plusargs("lh")) begin 
		$display("############################"); $display("######## lh test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-lh.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		$readmemh("../tb/inst_txt/rv32ui-p-lh.txt",riscv_soc_tb.u_riscv_soc.u_dram.mymem.ram);
		end
		if ($test$plusargs("lw")) begin 
		$display("############################"); $display("######## lw test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-lw.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		$readmemh("../tb/inst_txt/rv32ui-p-lw.txt",riscv_soc_tb.u_riscv_soc.u_dram.mymem.ram);
		end
		if ($test$plusargs("lbu")) begin 
		$display("############################"); $display("######## lbu test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-lbu.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		$readmemh("../tb/inst_txt/rv32ui-p-lbu.txt",riscv_soc_tb.u_riscv_soc.u_dram.mymem.ram);
		end
		if ($test$plusargs("lhu")) begin 
		$display("############################"); $display("######## lhu test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-lhu.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		$readmemh("../tb/inst_txt/rv32ui-p-lhu.txt",riscv_soc_tb.u_riscv_soc.u_dram.mymem.ram);
		end
		/*************************************************   S-type   *************************************************************/
		if ($test$plusargs("sb")) begin 
		$display("############################"); $display("######## sb test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-sb.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		$readmemh("../tb/inst_txt/rv32ui-p-sb.txt",riscv_soc_tb.u_riscv_soc.u_dram.mymem.ram);
		end
		if ($test$plusargs("sh")) begin 
		$display("############################"); $display("######## sh test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-sh.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		$readmemh("../tb/inst_txt/rv32ui-p-sh.txt",riscv_soc_tb.u_riscv_soc.u_dram.mymem.ram);
		end
		if ($test$plusargs("sw")) begin 
		$display("############################"); $display("######## sw test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-sw.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		$readmemh("../tb/inst_txt/rv32ui-p-sw.txt",riscv_soc_tb.u_riscv_soc.u_dram.mymem.ram);
		end
		/*************************************************   I-type   *************************************************************/
		if ($test$plusargs("addi")) begin 
		$display("############################"); $display("######## addi test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-addi.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("slti")) begin 
		$display("############################"); $display("######## slti test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-slti.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("sltiu")) begin 
		$display("############################"); $display("######## sltiu test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-sltiu.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("xori")) begin 
		$display("############################"); $display("######## xori test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-xori.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("ori")) begin 
		$display("############################"); $display("######## ori test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-ori.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("andi")) begin 
		$display("############################"); $display("######## andi test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-andi.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("slli")) begin 
		$display("############################"); $display("######## slli test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-slli.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("srli")) begin 
		$display("############################"); $display("######## srli test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-srli.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("srai")) begin 
		$display("############################"); $display("######## srai test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-srai.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("auipc")) begin 
		$display("############################"); $display("######## srai test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-auipc.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("fence_i")) begin 
		$display("############################"); $display("######## fence_i test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-fence_i.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
		if ($test$plusargs("simple")) begin 
		$display("############################"); $display("######## simple test  #########");$display("############################");
		$readmemh("../tb/inst_txt/rv32ui-p-simple.txt",riscv_soc_tb.u_riscv_soc.u_iram.ram);
		end
	end 
	
endmodule


