`timescale 10ns/10ps
`include "../ver_component/DUT/RTL/RISCV_TopLevel.sv"
`include "../ver_component/rm/rtl/chip/riscv_soc.v"
module top;
	
	logic clk;
	logic rst_n, rst;
	
	always #5 clk = ~clk;
	assign rst_n = ~rst;
	initial begin
		clk <= 1'b1 ;
		rst <= 1'b1;
		#50;
		rst <= 1'b0;	
	end
	
	wire [4:0] my_CPU_A1, my_CPU_A2, my_CPU_A3;
	wire [31:0] my_CPU_RD1, my_CPU_RD2;
	wire  my_CPU_WD3, my_CPU_WE3;
	wire [31:0] my_CPU_A, my_CPU_WD, my_CPU_RD;
	wire my_CPU_WE;
	wire [4:0] golden_CPU_A1, golden_CPU_A2, golden_CPU_A3;
	wire [31:0] golden_CPU_RD1, golden_CPU_RD2;
	wire  golden_CPU_WD3, golden_CPU_WE3;
	wire [31:0] golden_CPU_A, golden_CPU_WD, golden_CPU_RD;
	wire golden_CPU_WE;
	pkt_if_pack pkt_bus(clk, rst_n);
	RISCV_TopLevel my_CPU(.clk(clk), .reset(rst), 
						.A1(my_CPU_A1), .A2(my_CPU_A2), .A3(my_CPU_A3),
						.RD1(my_CPU_RD1), .RD2(my_CPU_RD2),
						.WD3(my_CPU_WD3), .WE3(my_CPU_WE3),
						.A(my_CPU_A), .WD(my_CPU_WD), .RD(my_CPU_RD),
						.WE(my_CPU_WE)
				 		);
	riscv_soc golden_CPU(.clk(clk), .reset(rst),
						.A1(golden_CPU_A1), .A2(golden_CPU_A2), .A3(golden_CPU_A3),
						.RD1(golden_CPU_RD1), .RD2(golden_CPU_RD2),
						.WD3(golden_CPU_WD3), .WE3(golden_CPU_WE3),
						.A(golden_CPU_A), .WD(golden_CPU_WD), .RD(golden_CPU_RD),
						.WE(golden_CPU_WE)
						);
	
	operation_type drv_op; 
	assign drv_op = pkt_bus.pkt_in_bus.op;

	//my CPU
	assign pkt_bus.pkt_out_dut.A1  = my_CPU_A1;
	assign pkt_bus.pkt_out_dut.A2  = my_CPU_A2;
	assign pkt_bus.pkt_out_dut.A3  = my_CPU_A3;
	assign pkt_bus.pkt_out_dut.WD3  = my_CPU_WD3;
	assign pkt_bus.pkt_out_dut.WE3  = my_CPU_WE3;
	assign pkt_bus.pkt_out_dut.RD1  = my_CPU_RD1;
	assign pkt_bus.pkt_out_dut.RD2  = my_CPU_RD2;

	assign pkt_bus.pkt_out_dut.A  = my_CPU_A;
	assign pkt_bus.pkt_out_dut.WD  = my_CPU_WD;
	assign pkt_bus.pkt_out_dut.RD  = my_CPU_RD;
	assign pkt_bus.pkt_out_dut.WE  = my_CPU_WE;

	//golden CPU
	assign pkt_bus.pkt_out_rm.A1  = golden_CPU_A1;
	assign pkt_bus.pkt_out_rm.A2  = golden_CPU_A2;
	assign pkt_bus.pkt_out_rm.A3  = golden_CPU_A3;
	assign pkt_bus.pkt_out_rm.WD3  = golden_CPU_WD3;
	assign pkt_bus.pkt_out_rm.WE3  = golden_CPU_WE3;
	assign pkt_bus.pkt_out_rm.RD1  = golden_CPU_RD1;
	assign pkt_bus.pkt_out_rm.RD2  = golden_CPU_RD2;

	assign pkt_bus.pkt_out_rm.A  = golden_CPU_A;
	assign pkt_bus.pkt_out_rm.WD  = golden_CPU_WD;
	assign pkt_bus.pkt_out_rm.RD  = golden_CPU_RD;
	assign pkt_bus.pkt_out_rm.WE  = golden_CPU_WE;


	test u_test(pkt_bus, clk, rst_n);

	initial begin
		integer i;
			for(i=0; i < 65537; i=i+1) begin
				my_CPU.imem_ut.RAM[i] = 0;
			end
			for(i=0; i < 1048580; i=i+1) begin
				my_CPU.Data_Memory_ut.ram[i] = 0;
			end

			for(i=0; i < 65537; i=i+1) begin
				golden_CPU.u_iram.ram[i] = 0;
			end

			for(i=0; i < 262145; i=i+1) begin
				golden_CPU.u_dram.mymem.ram[i] = 0;
			end
	end

	always @(drv_op != reset) begin
		if (drv_op == add) begin
				$display("############################");
				$display("######## add test  #########");
				$display("############################");
				$readmemh("../tb/inst_txt/rv32ui-p-add.txt",my_CPU.imem_ut.RAM);//将指令写入iram
				$readmemh("../tb/inst_txt/rv32ui-p-add.txt",golden_CPU.u_iram.ram);
			end
		else if(drv_op == sub) begin
				$display("############################");
				$display("######## sub test  #########");
				$display("############################");
				$readmemh("../tb/inst_txt/rv32ui-p-sub.txt",my_CPU.imem_ut.RAM);
				$readmemh("../tb/inst_txt/rv32ui-p-sub.txt",golden_CPU.u_iram.ram);
			end
		else if(drv_op == sll) begin
				$display("############################");
				$display("######## sll test  #########");
				$display("############################");
				$readmemh("../tb/inst_txt/rv32ui-p-sll.txt",my_CPU.imem_ut.RAM);
				$readmemh("../tb/inst_txt/rv32ui-p-sll.txt",golden_CPU.u_iram.ram);
			end
		else $display("op=????");
	end

	initial begin
        $fsdbDumpfile("sim.fsdb");
        $fsdbDumpvars();
        $fsdbDumpSVA();
        $fsdbDumpMDA();
	end

endmodule