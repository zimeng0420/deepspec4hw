module top_module(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire mux_out;

    // 2-1 multiplexer
    assign mux_out = L ? r_in : q_in;

    // D flip-flop
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
    wire [2:0] q_next;

    // Each instance of top_module for bit 0, 1, and 2
    top_module u0 (
        .clk(clk),
        .L(L),
        .q_in(q[1] ^ q[2]), // Feedback from full_module
        .r_in(r[0]),
        .Q(q_next[0])
    );

    top_module u1 (
        .clk(clk),
        .L(L),
        .q_in(q[0]), // Feedback from full_module
        .r_in(r[1]),
        .Q(q_next[1])
    );

    top_module u2 (
        .clk(clk),
        .L(L),
        .q_in(q[2]), // Feedback from full_module
        .r_in(r[2]),
        .Q(q_next[2])
    );

    // Output assignment
    assign q = q_next;

endmodule