module top_module(
    input clk,
    input L,
    input [2:0] r_in,
    output [2:0] q_out
);
    
    wire [2:0] q1, q2, q3;

    full_module u1 (
        .r(r_in),
        .L(L),
        .clk(clk),
        .q(q1)
    );

    full_module u2 (
        .r(q1),
        .L(L),
        .clk(clk),
        .q(q2)
    );

    full_module u3 (
        .r(q2),
        .L(L),
        .clk(clk),
        .q(q3)
    );

    assign q_out = q3;

endmodule

module full_module (
    input [2:0] r,
    input L,
    input clk,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (L) begin
            q <= r;
        end else begin
            q <= {q[1] ^ q[2], q[0], q[2]};
        end
    end

endmodule