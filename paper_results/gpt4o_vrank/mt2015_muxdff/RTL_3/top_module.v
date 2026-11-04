module top_module (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire mux_out;

    // 2-1 multiplexer
    assign mux_out = L ? r_in : q_in;

    // D flip-flop with asynchronous reset
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

    wire [2:0] q_internal;

    // Instantiation of top_module submodules
    top_module u0 (
        .clk(clk),
        .L(L),
        .q_in(q_internal[1] ^ q_internal[2]),
        .r_in(r[0]),
        .Q(q_internal[0])
    );

    top_module u1 (
        .clk(clk),
        .L(L),
        .q_in(q_internal[0]),
        .r_in(r[1]),
        .Q(q_internal[1])
    );

    top_module u2 (
        .clk(clk),
        .L(L),
        .q_in(q_internal[2]),
        .r_in(r[2]),
        .Q(q_internal[2])
    );

    assign q = q_internal;

endmodule