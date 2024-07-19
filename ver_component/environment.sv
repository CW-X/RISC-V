`include "pkt_gen.sv"
`include "pkt_drv.sv"
`include "pkt_mon.sv"
`include "pkt_chk.sv"
`include "env_cfg.sv"
`include "pkt_if_pack.sv"

`ifndef ENV_SV
`define ENV_SV

class environment;
	virtual pkt_if_pack bus;
    pkt_gen gen;
    pkt_drv drv;
    pkt_mon rm_mon;
    pkt_mon dut_mon;
    pkt_chk chk;
    env_cfg cfg;
	mailbox gen2drv;
	mailbox rm_mon2chk;
	mailbox dut_mon2chk;	
    
    int send_pkt_num;
    int wait_time;

    extern function new(input virtual pkt_if_pack bus);
    extern virtual task build();
    extern virtual task run();
    extern virtual task report();
endclass

function environment::new(input virtual pkt_if_pack bus);
	$display("At %0t, [ENV NOTE]: environment::new() start!", $time);
	this.bus = bus;
	this.cfg = new();	
	gen2drv = new();
	rm_mon2chk = new();
	dut_mon2chk = new();
endfunction

task environment::build();
    int test[20];
    $display("At %0t, [ENV NOTE]: environment::build() start!", $time);
    gen = new(cfg, gen2drv);
    drv = new(cfg, this.bus.pkt_in_bus, gen2drv);
    rm_mon = new(cfg, this.bus.pkt_out_rm, this.rm_mon2chk, 1);
    dut_mon = new(cfg, this.bus.pkt_out_dut, this.dut_mon2chk, 1);
    // rm  = new(this.in_mon2rm, this.rm2chk);	
    chk = new(cfg, this.rm_mon2chk, this.dut_mon2chk);
endtask

task environment::run();
    fork
		drv.run();
		gen.run();
		rm_mon.run();
		dut_mon.run();
		// rm.run();
		chk.run();
    join_none

    #100;
    $display("At %0t, [ENV NOTE]: wait for end............", $time);
    while(1) begin
            wait(cfg.gen_idle);
            wait(cfg.drv_idle);
            wait(cfg.mon_idle);
            wait(cfg.chk_idle);
        break;
    end
    $display("At %0t, [ENV NOTE]: normal finish", $time);

endtask

task environment::report();
    $display("At %0t, [ENV NOTE]: report start", $time);
	chk.report();
	$display("At %0t, [ENV NOTE]: report over", $time);
endtask

`endif