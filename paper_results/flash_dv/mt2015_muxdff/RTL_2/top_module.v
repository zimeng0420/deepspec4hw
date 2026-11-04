module top_module(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

always @(posedge clk) begin
    if (L) begin
        Q <= r_in;
    end else begin
        Q <= q_in;
    end
end

endmodule

module full_module (
    input [2:0] r,
    input L,
    input clk,
    output [2:0] q
);

wire q0, q1, q2;

top_module top0 (
    .clk(clk),
    .L(L),
    .q_in( {q1 ^ q2} ),
    .r_in(r[0]),
    .Q(q0)
);

top_module top1 (
    .clk(clk),
    .L(L),
    .q_in(q0),
    .r_in(r[1]),
    .Q(q1)
);

top_module top2 (
    .clk(clk),
    .L(L),
    .q_in(q2),
    .r_in(r[2]),
    .Q(q2)
);

assign q = {q0, q1, q2};

endmodule