module top_module (
    input clk,
    input L,
    input r_in,
    input q_in,
    output reg Q
);

    // Submodule instantiation (ff_mux)
    // Assume ff_mux contains a flip-flop and a 2-to-1 multiplexer
    // and will be instantiated within top_module
    always @(posedge clk) begin
        if (L) begin
            Q <= r_in;
        end else begin
            Q <= q_in; // or any previous output like Q;
        end
    end

endmodule

module full_module (
    input [2:0] r,
    input L,
    input clk,
    output reg [2:0] q
);

    top_module ff_mux_0 (
        .clk(clk),
        .L(L),
        .r_in(r[0]),
        .q_in(q[0]),
        .Q(q[0])
    );

    top_module ff_mux_1 (
        .clk(clk),
        .L(L),
        .r_in(r[1]),
        .q_in(q[1]),
        .Q(q[1])
    );

    top_module ff_mux_2 (
        .clk(clk),
        .L(L),
        .r_in(r[2]),
        .q_in(q[2]),
        .Q(q[2])
    );

    // Alternative q <= {q[1] ^ q[2], q[0], q[2]};
    // not supported by the provided top_module which only implements the 2:1 muxed flip-flop
    always @(posedge clk) begin
        if (!L) begin
            q[0] <= q[1] ^ q[2];
            q[1] <= q[0];
            q[2] <= q[2];

        end
    end

endmodule