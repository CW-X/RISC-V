module Instmemory(iaddr, idataout);
    input  [31:0] iaddr;
    output reg [31:0] idataout;

    reg [31:0] ram [65536:0];

    always@(*) begin
        idataout <= ram[iaddr[17:2]];
    end
endmodule