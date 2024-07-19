`ifndef PKT_DATA_SV
`define PKT_DATA_SV

typedef enum logic [1:0] {
	reset = 2'b00,
	add = 2'b01,
	sub = 2'b10,
	sll = 2'b11
} operation_type;

class pkt_data;
	rand operation_type op;
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
	
	constraint no_reset{
		op != reset;
	};

	extern function new();
	extern virtual function bit compare(pkt_data to);
	extern virtual function string psprintf(string preset = "");
	extern virtual function pkt_data copy(pkt_data to=null);
	
endclass

function pkt_data::new();

endfunction

function bit pkt_data::compare(pkt_data to);
	bit match = 1;
	if((this.A1 != to.A1))	match = 0;
	if((this.A2 != to.A2))	match = 0;
	if((this.A3 != to.A3))	match = 0;
	if((this.WD3 != to.WD3))	match = 0;
	if((this.RD1 != to.RD1))	match = 0;
	if((this.RD2 != to.RD2))	match = 0;
	if((this.WE3 != to.WE3))	match = 0;

	if((this.A != to.A))	match = 0;
	if((this.WD != to.WD))	match = 0;
	if((this.WE != to.WE))	match = 0;
	if((this.RD != to.RD))	match = 0;

	return match;
endfunction:compare

function string pkt_data::psprintf(string preset = "");

		psprintf = {preset, $psprintf("A1 = %0d", A1)};
		psprintf = {psprintf, $psprintf("A2 = %0d", A2)};
		psprintf = {psprintf, ",", $psprintf("A3 = %0d", A3)};
		psprintf = {psprintf, ",", $psprintf("WD3 = %0h", WD3)};
		psprintf = {psprintf, ",", $psprintf("RD1 = %0h", RD1)};
		psprintf = {psprintf, ",", $psprintf("RD2 = %0h", RD2)};
		psprintf = {psprintf, ",", $psprintf("WE3 = %0b", WE3)};
		psprintf = {preset, $psprintf("A = %0h", A)};
		psprintf = {preset, $psprintf("WD = %0h", WD)};
		psprintf = {psprintf, ",", $psprintf("WE = %0b", WE)};
		psprintf = {preset, $psprintf("RD = %0h", RD)};
		$display(" \n");

endfunction


function pkt_data pkt_data::copy(pkt_data to=null);
	pkt_data tmp;
	if (to == null)
		tmp = new();
	else
		$cast(tmp, to);

	tmp.op = this.op;
	tmp.A1 = this.A1;
	tmp.A2  = this.A2;
	tmp.A3  = this.A3;
	tmp.WD3  = this.WD3;
	tmp.WE3  = this.WE3;
	tmp.RD1  = this.RD1;
	tmp.RD2  = this.RD2;
	tmp.A  = this.A;
	tmp.WD  = this.WD;
	tmp.WE  = this.WE;
	tmp.RD  = this.RD;

	return tmp;
endfunction

`endif
