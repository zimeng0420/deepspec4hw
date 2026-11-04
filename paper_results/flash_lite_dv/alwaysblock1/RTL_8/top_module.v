module top_module(
    input a,
    input b,
    output wire out_assign,
    output reg out_alwaysblock
);

    // Assign statement implementation
    assign out_assign = a & b;

    // Combinational always block implementation
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule