module top_module(
	input clk,
	input L,
	input q_in,
	input r_in,
	output reg Q
);

    // Submodule: Flip-Flop and 2-to-1 Mux
    module ff_mux (
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
                q_out <= q_in;
            end
        end
    endmodule

    wire [2:0] r;
    wire [2:0] q_next;
    wire [2:0] q_internal;

    assign r[0] = r_in;
    assign r[1] = r_in;
    assign r[2] = r_in;

    // Instantiate three ff_mux submodules
    ff_mux ff_mux_0 (
        .clk(clk),
        .L(L),
        .d(r[0]),
        .q_in(q_internal[0]),
        .q_out(q_next[0])
    );

    ff_mux ff_mux_1 (
        .clk(clk),
        .L(L),
        .d(r[1]),
        .q_in(q_internal[1]),
        .q_out(q_next[1])
    );


    ff_mux ff_mux_2 (
        .clk(clk),
        .L(L),
        .d(r[2]),
        .q_in(q_internal[2]),
        .q_out(Q)
    );
    
    always @(*) begin
        q_internal[0] = q_next[1] ^ Q;
        q_internal[1] = q_next[0];
        q_internal[2] = Q;
    end
endmodule