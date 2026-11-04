module top_module(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire mux_out;
    
    // 2-1 Multiplexer
    assign mux_out = L ? r_in : q_in;
    
    // Flip-Flop
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule

module full_module (
    input [2:0] r,
    input L,
    input clk,
    output [2:0] q
);
    top_module inst0 (
        .clk(clk),
        .L(L),
        .q_in(q[1] ^ q[2]),
        .r_in(r[0]),
        .Q(q[0])
    );

    top_module inst1 (
        .clk(clk),
        .L(L),
        .q_in(q[0]),
        .r_in(r[1]),
        .Q(q[1])
    );

    top_module inst2 (
        .clk(clk),
        .L(L),
        .q_in(q[2]),
        .r_in(r[2]),
        .Q(q[2])
    );

endmodule