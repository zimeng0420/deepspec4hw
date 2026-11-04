module top_module(
    input p1a, 
    input p1b, 
    input p1c, 
    input p1d,
    input p1e,
    input p1f,
    output p1y, 
    input p2a, 
    input p2b, 
    input p2c, 
    input p2d, 
    output p2y
);

    wire and1_out, and2_out, and3_out, and4_out;

    // 3-input AND gates
    assign and1_out = p1a & p1b & p1c; // Output of first 3-input AND gate
    assign and2_out = p1d & p1e & p1f; // Output of second 3-input AND gate

    // OR gate for p1y
    assign p1y = and1_out | and2_out;

    // 2-input AND gates
    assign and3_out = p2a & p2b; // Output of first 2-input AND gate
    assign and4_out = p2c & p2d; // Output of second 2-input AND gate

    // OR gate for p2y
    assign p2y = and3_out | and4_out;

endmodule