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
        input r,
        input q_in,
        output reg q_out
    );

        always @(posedge clk) begin
            if (L) begin
                q_out <= r;
            end else begin
                q_out <= q_in;
            end
        end

    endmodule

    wire [2:0] r_internal;
    wire [2:0] q_internal;

    assign r_internal[0] = r_in;

    // Instantiate three flipflop_mux submodules
    flipflop_mux u_ff_mux_0 (
        .clk(clk),
        .L(L),
        .r(r_internal[0]),
        .q_in(q_internal[0]),
        .q_out(q_internal[0])
    );

    flipflop_mux u_ff_mux_1 (
        .clk(clk),
        .L(L),
        .r(q_internal[0]),
        .q_in(q_internal[1]),
        .q_out(q_internal[1])
    );

    flipflop_mux u_ff_mux_2 (
        .clk(clk),
        .L(L),
        .r(q_internal[1]),
        .q_in(q_internal[2]),
        .q_out(q_internal[2])
    );

	assign Q = q_internal[2];


endmodule