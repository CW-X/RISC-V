`include "./environment.sv"

program automatic test(pkt_if_pack bus,
                        input clk, rst_n);

    environment env;
    initial begin
    env = new(bus);
    env.build();
    // env.gen.send_num = 2;
    env.run();
    env.report();
    $display("At %0t, [TEST NOTE]: simulation finish~~~~~~~~~~~~~~~~~~", $time);
    $finish;
    end
  
endprogram