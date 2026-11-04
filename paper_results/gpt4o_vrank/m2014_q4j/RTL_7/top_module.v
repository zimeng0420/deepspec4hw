module top_module (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire c1, c2, c3, c4;
    
    // First full adder
    full_adder fa0 (
        .a(x[0]),
        .b(y[0]),
        .cin(0),
        .s(sum[0]),
        .cout(c1)
    );
    
    // Second full adder
    full_adder fa1 (
        .a(x[1]),
        .b(y[1]),
        .cin(c1),
        .s(sum[1]),
        .cout(c2)
    );
    
    // Third full adder
    full_adder fa2 (
        .a(x[2]),
        .b(y[2]),
        .cin(c2),
        .s(sum[2]),
        .cout(c3)
    );
    
    // Fourth full adder
    full_adder fa3 (
        .a(x[3]),
        .b(y[3]),
        .cin(c3),
        .s(sum[3]),
        .cout(c4)
    );
    
    // Assign the overflow bit to sum[4]
    assign sum[4] = c4;

endmodule

module full_adder (
    input a, b, cin,
    output s, cout
);
    assign s = a ^ b ^ cin;  // sum
    assign cout = (a & b) | (b & cin) | (a & cin);  // carry out
endmodule