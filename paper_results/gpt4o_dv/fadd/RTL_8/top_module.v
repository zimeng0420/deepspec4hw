module top_module (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    // Internal wire for intermediate XOR result
    wire axorb;

    // Calculate a XOR b
    assign axorb = a ^ b;

    // Calculate sum as (a XOR b) XOR cin
    assign sum = axorb ^ cin;

    // Calculate cout as (a AND b) OR (cin AND (a XOR b))
    assign cout = (a & b) | (cin & axorb);

endmodule