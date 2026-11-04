module ff_mux (
    input clk,
    input L,
    input r,
    input q_in,
    output reg q_out
);

    // Internal wire for the multiplexer output
    wire mux_out;

    // 2-to-1 Multiplexer
    always @(*) begin
        if (L) begin
            mux_out = r;
        end else begin
            mux_out = q_in;
        end
    end

    // D Flip-Flop
    always @(posedge clk) begin
        q_out <= mux_out;
    end

endmodule

module top_module(
	input clk,
	input L,
	input r_in,
	input q_in,
	output reg Q
);

    // Internal wires to connect the ff_mux instances
    wire q1_out, q2_out;

    // Instantiate the ff_mux submodule three times
    ff_mux ff_mux_inst1 (
        .clk(clk),
        .L(L),
        .r(r_in),
        .q_in(q_in),
        .q_out(q1_out)
    );

    ff_mux ff_mux_inst2 (
        .clk(clk),
        .L(L),
        .r(q1_out ^ Q),
        .q_in(q1_out),
        .q_out(q2_out)
    );

    ff_mux ff_mux_inst3 (
        .clk(clk),
        .L(L),
        .r(q2_out),
        .q_in(q2_out),
        .q_out(Q)
    );

endmodule