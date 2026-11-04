module top_module(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

reg mux_out;

always @(*) begin
    if (L) begin
        mux_out = r_in;
    end else begin
        mux_out = q_in;
    end
end

always @(posedge clk) begin
    Q <= mux_out;
end

endmodule

module full_module (
    input [2:0] r,
    input L,
    input clk,
    output [2:0] q
);

wire w0, w1;
wire [2:0] q_internal;
assign q = q_internal;

top_module top0 (
    .clk(clk),
    .L(L),
    .q_in(q_internal[0]),
    .r_in(r[0]),
    .Q(q_internal[0])
);

top_module top1 (
    .clk(clk),
    .L(L),
    .q_in(q_internal[1]),
    .r_in(r[1]),
    .Q(q_internal[1])
);

top_module top2 (
    .clk(clk),
    .L(L),
    .q_in(q_internal[2]),
    .r_in(r[2]),
    .Q(q_internal[2])
);

endmodule