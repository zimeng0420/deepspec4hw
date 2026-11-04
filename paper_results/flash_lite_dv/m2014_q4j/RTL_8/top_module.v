module top_module (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire [3:0] carry;
    wire [3:0] sum_internal;

    // Instantiate full adders
    full_adder FA0 (
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum_internal[0]),
        .cout(carry[0])
    );

    full_adder FA1 (
        .a(x[1]),
        .b(y[1]),
        .cin(carry[0]),
        .sum(sum_internal[1]),
        .cout(carry[1])
    );

    full_adder FA2 (
        .a(x[2]),
        .b(y[2]),
        .cin(carry[1]),
        .sum(sum_internal[2]),
        .cout(carry[2])
    );

    full_adder FA3 (
        .a(x[3]),
        .b(y[3]),
        .cin(carry[2]),
        .sum(sum_internal[3]),
        .cout(carry[3])
    );

    // Overflow detection
    assign sum[4] = carry[3]; // Overflow = Cout[3]

    // Assign sum bits
    assign sum[0] = sum_internal[0];
    assign sum[1] = sum_internal[1];
    assign sum[2] = sum_internal[2];
    assign sum[3] = sum_internal[3];


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