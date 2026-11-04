module submodule_flipflop_mux(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    always @(posedge clk) begin
        if (L) begin
            Q <= r_in;
        end else begin
            Q <= q_in;
        end
    end

endmodule

module top_module(
    input clk,
    input L,
    input q_in,
    input [2:0] r_in,
    output reg [2:0] Q
);

    wire q0, q1, q2;

    submodule_flipflop_mux inst0 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in[0]),
        .Q(q0)
    );

    submodule_flipflop_mux inst1 (
        .clk(clk),
        .L(L),
        .q_in(q0),
        .r_in(r_in[1]),
        .Q(q1)
    );

    submodule_flipflop_mux inst2 (
        .clk(clk),
        .L(L),
        .q_in(q1),
        .r_in(r_in[2]),
        .Q(q2)
    );

    always @(*) begin
        Q[0] = q0;
        Q[1] = q1;
        Q[2] = q2;
    end

endmodule