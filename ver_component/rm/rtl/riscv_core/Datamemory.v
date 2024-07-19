module Datamemory(addr, dataout, datain, wrclk, memop, we, re);
	input  [31:0] addr;
	output reg [31:0] dataout;
	input  [31:0] datain;
	input  wrclk;
	input [2:0] memop;
	input we;
    input re;
	
	wire [31:0] memin;
	reg  [3:0] wmask;
	wire [7:0] byteout;
	wire [15:0] wordout;
	wire [31:0] dwordout;
 

assign memin = (memop[1:0]==2'b00)?{4{datain[7:0]}}:((memop[1:0]==2'b10)?datain:{2{datain[15:0]}}) ; //lb: same for all four, lh:copy twice; lw:copy

//four memory chips	
testdmem mymem(
    .byteena_a(wmask),
    .data(memin), 
    .rdaddress(addr[19:2]),  
    .wraddress(addr[19:2]), 
    .wrclock(wrclk), 
    .wen(we), 
	.ren(re),
    .q(dwordout)
    );
//wmask,addr[16:2]
assign wordout = (addr[1]==1'b1)? dwordout[31:16]:dwordout[15:0];

assign byteout = (addr[1]==1'b1)? ((addr[0]==1'b1)? dwordout[31:24]:dwordout[23:16]):((addr[0]==1'b1)? dwordout[15:8]:dwordout[7:0]);


always @(*)
begin
  case(memop)
  3'b000: //lb
     dataout = { {24{byteout[7]}}, byteout};
  3'b001: //lh
     dataout = { {16{wordout[15]}}, wordout};
  3'b010: //lw
     dataout = dwordout;
  3'b100: //lbu
     dataout = { 24'b0, byteout};
  3'b101: //lhu
     dataout = { 16'b0, wordout};
  default:
     dataout = dwordout;
  endcase
end

always@(*)
begin
	case(memop)
		3'b000://sb
		begin
			wmask[0]=(addr[1:0]==2'b00)?1'b1:1'b0;
			wmask[1]=(addr[1:0]==2'b01)?1'b1:1'b0;
			wmask[2]=(addr[1:0]==2'b10)?1'b1:1'b0;
			wmask[3]=(addr[1:0]==2'b11)?1'b1:1'b0;
		end
		3'b001://sh
		begin
			wmask[0]=(addr[1]==1'b0)?1'b1:1'b0;
			wmask[1]=(addr[1]==1'b0)?1'b1:1'b0;
			wmask[2]=(addr[1]==1'b1)?1'b1:1'b0;
			wmask[3]=(addr[1]==1'b1)?1'b1:1'b0;
		end		
		3'b010://sw
		begin
			wmask=4'b1111;
		end
		default:
		begin
			wmask=4'b0000;
		end
	endcase
end
endmodule

module testdmem(
    byteena_a,
	data,
	rdaddress,
	wraddress,
	wrclock,
	wen,
	ren,
	q
	);
	

	input [3:0]  byteena_a;
	input	[31:0]  data;
	input	[17:0]  rdaddress;
	input	[17:0]  wraddress;
	input	  wrclock;
	input	  wen;
	input	  ren;
	output reg	[31:0]  q;
	
	reg  [31:0] tempout;
	reg  [31:0] tempin;

	
	reg [31:0] ram [262144:0];

	always@(*)
	begin
	tempout<=ram[wraddress];
    if(ren)
		q <= ram[rdaddress];
	end

	always @(*) begin
        tempin[7:0]   <= (byteena_a[0])? data[7:0]  : tempout[7:0];
        tempin[15:8]  <= (byteena_a[1])? data[15:8] : tempout[15:8];
        tempin[23:16] <= (byteena_a[2])? data[23:16]: tempout[23:16];
        tempin[31:24] <= (byteena_a[3])? data[31:24]: tempout[31:24];
	end

	always@(posedge wrclock)
	begin
		if(wen) 
		begin
			ram[wraddress]<=tempin;
		end
	end
		
endmodule