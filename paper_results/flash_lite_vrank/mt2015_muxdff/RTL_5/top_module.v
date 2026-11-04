module top_module(
	input clk,
	input L,
	input q_in,
	input r_in,
	output reg Q
);

    // Submodule: Flip-Flop with 2-to-1 Mux
    module ff_mux (
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

    // Instantiate the submodule three times
    wire [2:0] r;
    wire [2:0] q_temp;


    assign r[0] = r_in;

    ff_mux ff_inst0 (
        .clk(clk),
        .L(L),
        .r(r_in),
        .q_in(q_in),
        .q_out(Q)
    );


endmodule