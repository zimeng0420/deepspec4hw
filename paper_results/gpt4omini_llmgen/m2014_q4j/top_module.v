module top_module (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [3:0] carry; // Carry wires between full adders

    // Full adder for least significant bit
    full_adder FA0 (
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0), // Initial carry in is 0
        .sum(sum[0]),
        .cout(carry[0])
    );

    // Full adder for the second bit
    full_adder FA1 (
        .a(x[1]),
        .b(y[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout(carry[1])
    );

    // Full adder for the third bit
    full_adder FA2 (
        .a(x[2]),
        .b(y[2]),
        .cin(carry[1]),
        .sum(sum[2]),
        .cout(carry[2])
    );

    // Full adder for the most significant bit
    full_adder FA3 (
        .a(x[3]),
        .b(y[3]),
        .cin(carry[2]),
        .sum(sum[3]),
        .cout(sum[4]) // Final carry out indicates overflow
    );

endmodule

module full_adder (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule