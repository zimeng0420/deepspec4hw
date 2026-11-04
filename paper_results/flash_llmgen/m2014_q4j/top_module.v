module top_module (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire c1, c2, c3; // Carry signals between full adders

    // Instantiate Full Adders
    full_adder FA0 (
        .A(x[0]),
        .B(y[0]),
        .Cin(1'b0), // Carry-in for LSB is 0
        .S(sum[0]),
        .Cout(c1)
    );

    full_adder FA1 (
        .A(x[1]),
        .B(y[1]),
        .Cin(c1),
        .S(sum[1]),
        .Cout(c2)
    );

    full_adder FA2 (
        .A(x[2]),
        .B(y[2]),
        .Cin(c2),
        .S(sum[2]),
        .Cout(c3)
    );

    full_adder FA3 (
        .A(x[3]),
        .B(y[3]),
        .Cin(c3),
        .S(sum[3]),
        .Cout(sum[4]) // Carry-out of MSB is the overflow bit
    );

    // Overflow Detection (Alternative implementation - more explicit)
    // assign sum[4] = c3 ^ sum[4]; // Overflow is Cin XOR Cout of MSB

endmodule

// Full Adder Module
module full_adder (
    input A,
    input B,
    input Cin,
    output S,
    output Cout
);

    assign S = A ^ B ^ Cin;
    assign Cout = (A & B) | (A & Cin) | (B & Cin);

endmodule