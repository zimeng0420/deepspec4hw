module top_module(
	input clk,
	input L,
	input q_in,
	input r_in,
	output reg Q
);

    // Submodule: flipflop_mux
    module flipflop_mux (
        input clk,
        input L,
        input d,
        input q_in,
        output reg q_out
    );

        always @(posedge clk) begin
            if (L) begin
                q_out <= d;
            end else begin
                q_out <= {q_in};
            end
        end

    endmodule

    wire w1, w2, w3;

    // Instantiate flipflop_mux three times
    flipflop_mux ff1 (
        .clk(clk),
        .L(L),
        .d(r_in),
        .q_in(q_in),
        .q_out(Q)
    );


endmodule