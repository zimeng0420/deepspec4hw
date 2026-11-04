module top_module (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

// Intermediate signals for full adder
wire sum_ab;           // Sum of a and b
wire carry_ab;         // Carry output from a and b
wire carry_sum;        // Carry output from the sum of a and b and cin

// Compute sum and carry for a and b
assign sum_ab = a ^ b;           // Sum of a and b
assign carry_ab = a & b;         // Carry from a and b

// Compute final sum and carry-out
assign sum = sum_ab ^ cin;       // Final sum considering cin
assign carry_sum = sum_ab & cin; // Carry from the sum and cin
assign cout = carry_ab | carry_sum; // Final carry-out

endmodule