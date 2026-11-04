module top_module(
    input x,
    input y,
    output z
);

    // Submodule A
    wire A1_out, A2_out;
    
    assign A1_out = (x ^ y) & x;
    assign A2_out = (x ^ y) & x;
  
    // Submodule B
    wire B1_out, B2_out;

    assign B1_out = (~x & ~y) | (x & y);
    assign B2_out = (~x & ~y) | (x & y);

    // OR gate output of first pair of A and B submodules
    wire OR_out;
    assign OR_out = A1_out | B1_out;

    // AND gate output of second pair of A and B submodules
    wire AND_out;
    assign AND_out = A2_out & B2_out;

    // Final XOR gate output
    assign z = OR_out ^ AND_out;

endmodule