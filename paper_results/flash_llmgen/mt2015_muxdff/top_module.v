module top_module(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

reg D; // Internal signal for the D input of the flip-flop

always @(*) begin
    if (L) begin
        D = r_in;
    end else begin
        D = q_in;
    end
end

always @(posedge clk) begin
    Q <= D;
end

endmodule

module full_module (
    input [2:0] r,
    input L,
    input clk,
    output [2:0] q
);

wire q0_in, q1_in, q2_in;
wire q0_out, q1_out, q2_out;

assign q = {q2_out, q1_out, q0_out};

top_module top0 (
    .clk(clk),
    .L(L),
    .q_in(q1_in ^ q2_in), // XOR operation for q[1] ^ q[2]
    .r_in(r[0]),
    .Q(q0_out)
);

top_module top1 (
    .clk(clk),
    .L(L),
    .q_in(q0_in),
    .r_in(r[1]),
    .Q(q1_out)
);

top_module top2 (
    .clk(clk),
    .L(L),
    .q_in(q2_in),
    .r_in(r[2]),
    .Q(q2_out)
);

reg [2:0] q_internal; // Internal register to hold the state for feedback

always @(q0_out, q1_out, q2_out) begin
    q_internal = {q2_out, q1_out, q0_out};
end

assign q0_in = q_internal[0];
assign q1_in = q_internal[1];
assign q2_in = q_internal[2];

endmodule