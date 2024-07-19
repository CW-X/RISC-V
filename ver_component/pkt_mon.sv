`ifndef PKT_MON_SV
`define PKT_MON_SV

`include "pkt_data.sv"
`include "pkt_if.sv"
`include "env_cfg.sv"

class pkt_mon;
    env_cfg cfg;
    virtual pkt_if mif;
    mailbox mon2chk;
    bit inout_type;
    int wait_pkt_time = 1000;
    pkt_data pre_pkt;
    
	extern function new(env_cfg cfg,
						virtual pkt_if mif,
						mailbox mon2chk,
						bit inout_type);
	extern virtual task run();
	extern virtual task send_chk(pkt_data pkt);

endclass

function pkt_mon::new(env_cfg cfg, virtual pkt_if mif, 
                        mailbox mon2chk, bit inout_type);
    this.cfg = cfg;
    this.mif = mif;
    this.mon2chk = mon2chk;
    this.wait_pkt_time = cfg.mon_wait_pkt_time;
    this.inout_type = inout_type;
endfunction:new

task pkt_mon::run();
    pkt_data rec_pkt;
    int i =0;
    int wait_time;
    // while (1) begin
    //     while(1) begin
    //         if(wait_time < wait_pkt_time ) begin
    //             @(this.mif.mon) begin
    //                     rec_pkt = new();
                        
    //                     rec_pkt.op = mif.mon.op;
    //                     rec_pkt.A1 = mif.mon.A1;
    //                     rec_pkt.A2 = mif.mon.A2;
    //                     rec_pkt.A3 = mif.mon.A3;
    //                     rec_pkt.WE3 = mif.mon.WE3;
    //                     rec_pkt.WD3 = mif.mon.WD3;
    //                     rec_pkt.RD1 = mif.mon.RD1;
    //                     rec_pkt.RD2 = mif.mon.RD2;
    //                     rec_pkt.A = mif.mon.A;
    //                     rec_pkt.WD = mif.mon.WD;
    //                     rec_pkt.RD = mif.mon.RD;
    //                     rec_pkt.WE = mif.mon.WE;

    //                     send_chk(rec_pkt);

    //                 end
    //         end
    //         else break;
    //     end
    //     this.cfg.mon_idle = 1;
    //     break;
    // end

    // while (1) begin
    //     @(top.clk) begin
    //         // Increment wait_time on every clock cycle when no update occurs
    //         if ($past(this.mif.mon) == this.mif.mon) begin
    //             wait_time++;
    //         end
    //         else wait_time = 0;
    //     end
    // end
    rec_pkt = new();
    while (1) begin
        @(posedge mif.clk) begin
            if(wait_time < wait_pkt_time ) begin
                pre_pkt = rec_pkt.copy(); 
                rec_pkt = new();
                rec_pkt.op = mif.mon.op;
                rec_pkt.A1 = mif.mon.A1;
                rec_pkt.A2 = mif.mon.A2;
                rec_pkt.A3 = mif.mon.A3;
                rec_pkt.WE3 = mif.mon.WE3;
                rec_pkt.WD3 = mif.mon.WD3;
                rec_pkt.RD1 = mif.mon.RD1;
                rec_pkt.RD2 = mif.mon.RD2;
                rec_pkt.A = mif.mon.A;
                rec_pkt.WD = mif.mon.WD;
                rec_pkt.RD = mif.mon.RD;
                rec_pkt.WE = mif.mon.WE;

                send_chk(rec_pkt);
                
            end
            if(pre_pkt.compare(rec_pkt)) wait_time++;
            else wait_time =0;

            if (wait_time >= wait_pkt_time) begin
                this.cfg.mon_idle = 1;
                $display("At %0t, mon_idle = 1",$time);
                break;
            end
        end
    end
endtask :run

task pkt_mon::send_chk(pkt_data pkt);
	mon2chk.put(pkt);
endtask : send_chk	
`endif