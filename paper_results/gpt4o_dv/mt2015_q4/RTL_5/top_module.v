module A(
    input x,
    input y,
    output reg z
);
    always @(*) begin
        z = (x ^ y) & x;
    end
endmodule

module B(
    input x,
    input y,
    output reg z
);
    always @(*) begin
        z = (~x & ~y) | (x & y);
    end
endmodule

module top_module(
    input x,
    input y,
    output z
);
    wire A1_out, A2_out, B1_out, B2_out;
    wire OR_out, AND_out;

    A inst_A1 (
        .x(x),
        .y(y),
        .z(A1_out)
    );

    A inst_A2 (
        .x(x),
        .y(y),
        .z(A2_out)
    );

    B inst_B1 (
        .x(x),
        .y(y),
        .z(B1_out)
    );

    B inst_B2 (
        .x(x),
        .y(y),
        .z(B2_out)
    );

    assign OR_out = A1_out | B1_out;
    assign AND_out = A2_out & B2_out;
    assign z = OR_out ^ AND_out;

endmodule