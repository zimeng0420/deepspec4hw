module top_module (
    input [4:1] x,
    output logic f
);
    assign f = (x[4:1] == 4'b0111) || (x[4:1] == 4'b1100) || (x[4:1] == 4'b1000) || (x[4:1] == 4'b1010);
endmodule