module top_module(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);
    always @(*) begin
        if (L)
            Q = r_in;
        else
            Q = q_in;
    end
endmodule

module full_module (
    input [2:0] r,
    input L,
    input clk,
    output reg [2:0] q
);
    wire [2:0] mux_out;

    // Instantiate top_module three times
    top_module u0 (
        .clk(clk),
        .L(L),
        .q_in(q[0]),
        .r_in(r[0]),
        .Q(mux_out[0])
    );
    
    top_module u1 (
        .clk(clk),
        .L(L),
        .q_in(q[1]),
        .r_in(r[1]),
        .Q(mux_out[1])
    );
    
    top_module u2 (
        .clk(clk),
        .L(L),
        .q_in(q[2]),
        .r_in(r[2]),
        .Q(mux_out[2])
    );

    always @(posedge clk) begin
        q <= mux_out;
    end
endmodule