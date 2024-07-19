`ifndef Data_Memory
`define Data_Memory
module Data_Memory(input logic CLK, WE, signM,
            input logic [1:0] Byte_Half_OpM,
            input logic [31:0] A, WD,
            output logic [31:0] RD );
    logic [7:0] ram[1048579:0]; //262145*32bits
   // assign RD = ram[A[31:2]];
   //load
   logic [2:0] load_type;
   assign load_type = {Byte_Half_OpM, signM};
   always_comb
   begin
   case(load_type)
    3'b010:  RD = {24'h000000, ram[{A[31:2], 2'b11}]}; //lbu
    3'b100:  RD = {16'h0000, ram[{A[31:2], 2'b10}], ram[{A[31:2], 2'b11}]}; // lhu
    3'b011:  RD = {{24{ram[{A[31:2], 2'b11}][7]}}, ram[{A[31:2], 2'b11}]}; //lb
    3'b101:  RD = {{16{ram[{A[31:2], 2'b10}][7]}}, ram[{A[31:2], 2'b10}], ram[{A[31:2], 2'b11}]}; // lh
    default: RD = {ram[{A[31:2], 2'b00}], ram[{A[31:2], 2'b01}], ram[{A[31:2], 2'b10}], ram[{A[31:2], 2'b11}]}; // word op
   endcase
   end
    //store
    always @( posedge CLK) begin
        if (WE)
        case(Byte_Half_OpM)
            2'b01: ram[{A[31:2], 2'b11}] <= WD[7:0]; //sb
            2'b10: {ram[{A[31:2], 2'b10}], ram[{A[31:2], 2'b11}]} <= WD[15:0]; // sh
            default: {ram[{A[31:2], 2'b00}], ram[{A[31:2], 2'b01}], ram[{A[31:2], 2'b10}], ram[{A[31:2], 2'b11}]} <= WD; //sw
        endcase
    end

endmodule
`endif