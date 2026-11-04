module full_adder (
    input  x,
    input  y,
    input  cin,
    output sum,
    output cout
);

    assign sum  = x ^ y ^ cin;
    assign cout = (x & y) | (x & cin) | (y & cin);

endmodule

module top_module (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);

    wire [3:0] cout; // Carry-out signals from each FA

    // Instantiate Full Adders
    full_adder fa0 (
        .x(x[0]),
        .y(y[0]),
        .cin(1'b0), // Initial carry-in = 0
        .sum(sum[0]),
        .cout(cout[0])
    );

    full_adder fa1 (
        .x(x[1]),
        .y(y[1]),
        .cin(cout[0]),
        .sum(sum[1]),
        .cout(cout[1])
    );

    full_adder fa2 (
        .x(x[2]),
        .y(y[2]),
        .cin(cout[1]),
        .sum(sum[2]),
        .cout(cout[2])
    );

    full_adder fa3 (
        .x(x[3]),
        .y(y[3]),
        .cin(cout[2]),
        .sum(sum[3]),
        .cout(cout[3])
    );

    // Overflow Detection
    assign sum[4] = cout[3] ^ cout[2]; // XOR of carry-in and carry-out of MSB FA

endmodule