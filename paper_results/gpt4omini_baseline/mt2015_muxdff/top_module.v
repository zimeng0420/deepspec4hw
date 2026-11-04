module top_module(
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
            Q <= {Q[1] ^ Q[2], Q[0], q_in};
        end
    end
endmodule

module full_module (
    input [2:0] r,
    input L,
    input clk,
    output reg [2:0] q
);

    wire q1, q2, q3;
    
    top_module ff1 (
        .clk(clk),
        .L(L),
        .q_in(q[0]),
        .r_in(r[0]),
        .Q(q1)
    );

    top_module ff2 (
        .clk(clk),
        .L(L),
        .q_in(q[1]),
        .r_in(r[1]),
        .Q(q2)
    );

    top_module ff3 (
        .clk(clk),
        .L(L),
        .q_in(q[2]),
        .r_in(r[2]),
        .Q(q3)
    );

    always @(posedge clk) begin
        if (L) begin
            q <= r;
        end else begin
            q <= {q2 ^ q3, q1, q3};
        end
    end
endmodule