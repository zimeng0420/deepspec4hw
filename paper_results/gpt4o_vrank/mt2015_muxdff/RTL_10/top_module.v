module top_module(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // Submodule for flip-flop and 2-1 multiplexer
    module flipflop_mux(
        input clk,
        input L,
        input r,
        input q,
        output reg q_out
    );

        always @(posedge clk) begin
            if (L) begin
                q_out <= r;
            end else begin
                q_out <= q;
            end
        end

    endmodule

    wire q_wire[2:0];  // Internal wires connecting submodules

    // Instantiate submodules
    flipflop_mux u0 (
        .clk(clk),
        .L(L),
        .r(r_in),
        .q(q_in),
        .q_out(q_wire[0])
    );

    flipflop_mux u1 (
        .clk(clk),
        .L(L),
        .r(r_in),
        .q(q_wire[0]),
        .q_out(q_wire[1])
    );

    flipflop_mux u2 (
        .clk(clk),
        .L(L),
        .r(r_in),
        .q(q_wire[1]),
        .q_out(Q)
    );

endmodule