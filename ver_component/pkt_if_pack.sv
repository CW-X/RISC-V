`include "pkt_if.sv"

`ifndef PKT_INTERFACE_SV
`define PKT_INTERFACE_SV

interface pkt_if_pack(
	input logic		clk		,
	input logic		rst_n
	);
	
	pkt_if		pkt_in_bus	(clk, rst_n);
	pkt_if		pkt_out_rm (clk, rst_n);
	pkt_if		pkt_out_dut (clk, rst_n);
	
endinterface : pkt_if_pack

`endif