module top_module (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    // Sum logic
    assign sum = a ^ b ^ cin;

    // Carry-out logic
    assign cout = (a & b) | (cin & (a ^ b));

endmodule