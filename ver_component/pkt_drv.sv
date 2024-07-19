`ifndef PKT_DRV_SV
`define PKT_DRV_SV

class pkt_drv;
	env_cfg cfg;
	mailbox gen2drv;
	virtual pkt_if dif;
	
	//for finish simu	
	int idle_cnt;
	
	int get_num;
	
	extern function new(env_cfg cfg,
						virtual pkt_if dif,
						mailbox gen2drv
						);
	extern virtual task run();
	extern virtual task my_run();
	extern virtual task rst_sig();
	extern virtual task pkt_send(input pkt_data pkt);
	extern virtual task set_idle();

endclass

function pkt_drv::new(env_cfg cfg,
				    virtual pkt_if dif,
					  mailbox gen2drv
					 );
	this.cfg = cfg;
	this.dif = dif;
	this.gen2drv = gen2drv;
	this.get_num = 0;
endfunction

task pkt_drv::run();
	fork
		my_run();
		set_idle();
	join_none
endtask

task pkt_drv::my_run();
	pkt_data send_pkt;

	this.cfg.drv_idle = 0;
	//$display("At %0t, [DRV NOTE]: pkt_drv run start!", $time);
	rst_sig();
	//$display("At %0t, [DRV NOTE]: after rst_n", $time);
	while(1) begin
		gen2drv.peek(send_pkt);
		//$display("At %0t, [DRV NOTE]: get no.%0d pkt from gen", $time, this.get_num++);		
		pkt_send(send_pkt);
		gen2drv.get(send_pkt);
		rst_sig();
	end
endtask:my_run

task pkt_drv::rst_sig();
	wait(top.rst_n == 1'b1);
	@(this.dif.drv);
		this.dif.drv.op<= reset;
		this.dif.drv.A1<= '0;
		this.dif.drv.A2<= '0;
		this.dif.drv.A3<= '0;
		this.dif.drv.WE3<= '0;
		this.dif.drv.WD3<= '0;
		this.dif.drv.RD1<= '0;
		this.dif.drv.RD2<= '0;
		this.dif.drv.A<= '0;
		this.dif.drv.WD <= '0;
		this.dif.drv.RD<= '0;
		this.dif.drv.WE <= '0;
endtask

task pkt_drv::pkt_send(input pkt_data pkt);

    @(this.dif.drv);
		this.dif.drv.op<= pkt.op;
		this.dif.drv.A1<= pkt.A1;
		this.dif.drv.A2<= pkt.A2;
		this.dif.drv.A3<= pkt.A3;
		this.dif.drv.WE3<= pkt.WE3;
		this.dif.drv.WD3<= pkt.WD3;
		this.dif.drv.RD1<= pkt.RD1;
		this.dif.drv.RD2<= pkt.RD2;
		this.dif.drv.A<= pkt.A;
		this.dif.drv.WD <= pkt.WD;
		this.dif.drv.RD<= pkt.RD;
		this.dif.drv.WE <= pkt.WE;

endtask

task pkt_drv::set_idle();

	this.cfg.drv_idle = 1;
	$display("At %0t, drv_idle = 1",$time);
endtask:set_idle

`endif
