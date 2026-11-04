module top_module(
    input a, 
    input b,
    output out_assign,
    output reg out_alwaysblock
);

    // Output driven by continuous assignment
    assign out_assign = a & b;

    // Output driven by combinational always block
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule