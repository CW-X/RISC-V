`ifndef data_extend
`define data_extend
module data_extend( input logic [2:0] funct3W,
                    input logic [31:0] datasrc,
                    output logic [31:0] dataext);

    always_comb begin
    case(funct3W)

    3'b000: dataext = { {24{datasrc[31]}}, datasrc[7:0]}; // byte
    3'b001: dataext = { {16{datasrc[31]}}, datasrc[15:0]}; //half
    3'b010: dataext = datasrc; // word
    3'b100: dataext = { 24'h000000, datasrc[7:0]}; //byte unsigned 
    3'b101: dataext = { 16'h0000, datasrc[15:0]}; // half unsigned
    default: dataext = datasrc;
    endcase
    end

endmodule
`endif