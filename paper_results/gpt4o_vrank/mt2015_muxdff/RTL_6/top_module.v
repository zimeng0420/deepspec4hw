module top_module(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire mux_out;

    mux2_1 u_mux2_1 (
        .a(q_in),
        .b(r_in),
        .sel(L),
        .y(mux_out)
    );

    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule

module mux2_1(
    input a,
    input b,
    input sel,
    output y
);

    assign y = sel ? b : a;

endmodule

module hierarchical_module(
    input [2:0] r,
    input L,
    input clk,
    output [2:0] q
);

    wire [2:0] q_int;
    
    top_module u0 (
        .clk(clk),
        .L(L),
        .q_in(q_int[0]),
        .r_in(r[0]),
        .Q(q[0])
    );
    
    top_module u1 (
        .clk(clk),
        .L(L),
        .q_in(q_int[1]),
        .r_in(r[1]),
        .Q(q[1])
    );
    
    top_module u2 (
        .clk(clk),
        .L(L),
        .q_in(q_int[2]),
        .r_in(r[2]),
        .Q(q[2])
    );

    assign q_int = {q[1] ^ q[2], q[0], q[2]};

endmodule