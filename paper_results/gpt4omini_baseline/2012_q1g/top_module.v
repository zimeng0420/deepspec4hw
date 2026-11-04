module top_module (
    input [4:1] x,
    output logic f
);

    assign f = (x == 4'b0000) ||     // f(0,0)
               (x == 4'b0010) ||     // f(0,2)
               (x == 4'b1100) ||     // f(3,0)
               (x == 4'b1101) ||     // f(3,1)
               (x == 4'b1110) ||     // f(3,2)
               (x == 4'b1000) ||     // f(2,0)
               (x == 4'b1001);       // f(2,1)

endmodule