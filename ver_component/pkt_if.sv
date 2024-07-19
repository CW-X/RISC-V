`ifndef PKT_IF_SV
`define PKT_IF_SV
`timescale 1ns/1ps
interface pkt_if(input clk, input rst_n);
	operation_type op;
	//REGISTER FILE
	logic [4:0] A1, A2, A3;
	logic [31:0] WD3;
	logic [31:0] RD1, RD2;
	logic WE3;
	//DRAM
	logic [31:0] A;
	logic [31:0] WD;

	logic WE;
	logic [31:0] RD;
	
	clocking drv @(posedge clk);
		//default input #1ps output #1ps;
		output op;
		output A1, A2, A3;
		output WD3;
		output RD1, RD2;
		output WE3;
		//DRAM
		output A;
		output WD;
		output WE;
		output RD;
	endclocking : drv
	modport pkt_drv (clocking drv);
	
	clocking mon @(posedge clk);
		// default input #1ps output #1ps;
		input op;
		//REGISTER FILE
		input A1, A2, A3;
		input  WD3;
		input RD1, RD2;
		input WE3;
		//DRAM
		input A;
		input WD;
		input WE;
		input RD;
	endclocking : mon
	modport pkt_mon (clocking mon);
	
endinterface

typedef virtual pkt_if.pkt_drv vdrv;
typedef virtual pkt_if.pkt_mon vmon;

`endif