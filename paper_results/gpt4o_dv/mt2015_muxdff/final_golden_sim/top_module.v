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

module full_module (
    input [2:0] r,
    input L,
    input clk,
    output reg [2:0] q
);

    wire [2:0] mux_out;

    // Instance 1
    top_module u1 (
        .clk(clk),
        .L(L),
        .q_in(q[1] ^ q[2]),
        .r_in(r[0]),
        .Q(mux_out[0])
    );

    // Instance 2
    top_module u2 (
        .clk(clk),
        .L(L),
        .q_in(q[0]),
        .r_in(r[1]),
        .Q(mux_out[1])
    );

    // Instance 3
    top_module u3 (
        .clk(clk),
        .L(L),
        .q_in(q[2]),
        .r_in(r[2]),
        .Q(mux_out[2])
    );

    always @(posedge clk) begin
        q <= mux_out;
    end

endmodule