module top_module (
    input [4:1] x,
    output logic f
);

    assign f = ~x[1];

endmodule