`ifndef GENERATOR
`define GENERATOR

`include "pkt_data.sv"
`include "env_cfg.sv"

class pkt_gen;
    env_cfg cfg;
    pkt_data pkt;
    mailbox gen2drv;

    extern function new(env_cfg cfg, mailbox gen2drv);
    extern virtual task run();

endclass
    
function pkt_gen::new(env_cfg cfg, mailbox gen2drv);
    this.cfg = cfg;
    this.gen2drv=gen2drv;
    this.pkt = new();
endfunction

task pkt_gen::run();
    pkt_data send_pkt;
    pkt_data chk_pkt;

    this.cfg.gen_idle = 0;
    assert(pkt.randomize());
    $cast(send_pkt, pkt.copy());
    $cast(chk_pkt, pkt.copy());
    gen2drv.put(send_pkt);
    this.cfg.gen_idle = 1;
    $display("At %0t, gen_idle = 1",$time);
    
endtask


`endif