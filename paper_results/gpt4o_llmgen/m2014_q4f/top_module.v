module top_module (
    input in1,
    input in2,
    output logic out
);

    // Intermediate signal for inverted input
    wire in2_not;

    // Generate the inverted input
    assign in2_not = ~in2;

    // Perform AND operation on in1 and in2_not
    assign out = in1 & in2_not;

endmodule