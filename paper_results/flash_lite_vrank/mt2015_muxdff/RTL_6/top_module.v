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
        input din,
        input r,
        output reg q
    );
        always @(posedge clk) begin
            if (L) begin
                q <= r;
            end else begin
                q <= din;
            end
        end
    endmodule

    wire [2:0] q_internal;
    wire [2:0] r_internal;
    wire [2:0] din_internal;


    // Instantiate three ff_mux modules
    ff_mux ff_mux_0 (
        .clk(clk),
        .L(L),
        .din(din_internal[0]),
        .r(r_internal[0]),
        .q(q_internal[0])
    );

    ff_mux ff_mux_1 (
        .clk(clk),
        .L(L),
        .din(din_internal[1]),
        .r(r_internal[1]),
        .q(q_internal[1])
    );

    ff_mux ff_mux_2 (
        .clk(clk),
        .L(L),
        .din(din_internal[2]),
        .r(r_internal[2]),
        .q(q_internal[2])
    );

    //Connections and logic
    assign r_internal[0] = r_in;
    assign r_internal[1] = r_in;
    assign r_internal[2] = r_in;


    assign din_internal[0] = q_internal[1] ^ q_internal[2];
    assign din_internal[1] = q_internal[0];
    assign din_internal[2] = q_internal[2];


    assign Q = q_internal[0];

endmodule