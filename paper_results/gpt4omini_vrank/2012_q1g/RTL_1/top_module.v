module top_module (
    input [3:0] x,
    output logic f
);
    assign f = (x == 4'b0000) || (x == 4'b0010) || 
               (x == 4'b1100) || (x == 4'b1101) ||
               (x == 4'b1010) || (x == 4'b1011) || 
               (x == 4'b1111);
endmodule