module top_module(
    input clk,
    input L,
    input [2:0] r,
    output [2:0] q
);
    wire [2:0] q0, q1, q2;

    full_module u0 (
        .r(r),
        .L(L),
        .clk(clk),
        .q(q0)
    );

    full_module u1 (
        .r(q0),
        .L(L),
        .clk(clk),
        .q(q1)
    );

    full_module u2 (
        .r(q1),
        .L(L),
        .clk(clk),
        .q(q2)
    );

    assign q = q2;

endmodule

module full_module(
    input [2:0] r,
    input L,
    input clk,
    output reg [2:0] q
);
    always @(posedge clk) begin
        if (L) begin
            q <= r;
        end else begin
            q <= {q[1] ^ q[2], q[0], q[2]};
        end
    end
endmodule