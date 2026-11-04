module top_module(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);
    always @(*) begin
        if (L) begin
            Q = r_in;
        end else begin
            Q = q_in;
        end
    end
endmodule

module full_module(
    input [2:0] r,
    input L,
    input clk,
    output reg [2:0] q
);

    wire [2:0] Q_out;

    top_module top_0 (
        .clk(clk),
        .L(L),
        .q_in(q[1] ^ q[2]),
        .r_in(r[0]),
        .Q(Q_out[0])
    );

    top_module top_1 (
        .clk(clk),
        .L(L),
        .q_in(q[0]),
        .r_in(r[1]),
        .Q(Q_out[1])
    );

    top_module top_2 (
        .clk(clk),
        .L(L),
        .q_in(q[2]),
        .r_in(r[2]),
        .Q(Q_out[2])
    );

    always @(posedge clk) begin
        q <= Q_out;
    end
endmodule