module top_module (
    input in1,
    input in2,
    output logic out
);

    // Negate in2 and then perform AND operation with in1
    assign out = in1 & ~in2;

endmodule