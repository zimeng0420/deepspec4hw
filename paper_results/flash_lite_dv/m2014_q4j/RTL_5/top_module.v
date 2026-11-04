module top_module (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);

    wire [3:0] sum_internal;
    wire [4:0] carry;

    // Instantiate Full Adders
    full_adder fa0 (
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum_internal[0]),
        .cout(carry[1])
    );

    full_adder fa1 (
        .a(x[1]),
        .b(y[1]),
        .cin(carry[1]),
        .sum(sum_internal[1]),
        .cout(carry[2])
    );

    full_adder fa2 (
        .a(x[2]),
        .b(y[2]),
        .cin(carry[2]),
        .sum(sum_internal[2]),
        .cout(carry[3])
    );

    full_adder fa3 (
        .a(x[3]),
        .b(y[3]),
        .cin(carry[3]),
        .sum(sum_internal[3]),
        .cout(carry[4])
    );
    
    assign sum[0] = sum_internal[0];
    assign sum[1] = sum_internal[1];
    assign sum[2] = sum_internal[2];
    assign sum[3] = sum_internal[3];
    assign sum[4] = carry[4]; // Overflow bit


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