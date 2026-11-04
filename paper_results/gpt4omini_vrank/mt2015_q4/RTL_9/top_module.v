module top_module(
    input x,
    input y,
    output z
);

    // Module A implementaion
    wire a1_out, a2_out, b1_out, b2_out;
    
    assign a1_out = (x ^ y) & x;  // A module 1
    assign a2_out = (x ^ y) & x;  // A module 2

    // Module B implementation
    assign b1_out = (x == 0 && y == 0) || (x == 1 && y == 1); // B module 1
    assign b2_out = (x == 0 && y == 0) || (x == 1 && y == 1); // B module 2

    // Combining outputs
    wire or_out, and_out;
    
    assign or_out = a1_out | b1_out;  // OR gate
    assign and_out = a2_out & b2_out;  // AND gate

    // Final output
    assign z = or_out ^ and_out;  // XOR gate

endmodule