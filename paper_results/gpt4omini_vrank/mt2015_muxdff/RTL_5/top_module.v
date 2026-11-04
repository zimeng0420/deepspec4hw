module top_module(
    input clk,
    input L,
    input [2:0] r,
    output [2:0] q
);

    wire [2:0] q1, q2, q3;

    // Instantiate full_module three times
    full_module ff1 (
        .r(r),
        .L(L),
        .clk(clk),
        .q(q1)
    );

    full_module ff2 (
        .r(q1),
        .L(L),
        .clk(clk),
        .q(q2)
    );

    full_module ff3 (
        .r(q2),
        .L(L),
        .clk(clk),
        .q(q3)
    );

    assign q = q3;

endmodule

module full_module (
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