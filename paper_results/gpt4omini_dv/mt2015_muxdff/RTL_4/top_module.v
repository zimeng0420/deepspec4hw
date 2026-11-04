module top_module(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    always @(*) begin
        if (L) begin
            Q = r_in;
        end else begin
            Q = q_in ^ r_in;
        end
    end

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

module hierarchical_module (
    input clk,
    input L,
    input [2:0] r_in,
    output [2:0] q_out
);
    wire [2:0] Q1, Q2, Q3;

    top_module u1 (.clk(clk), .L(L), .q_in(Q3[0]), .r_in(r_in[0]), .Q(Q1[0]));
    top_module u2 (.clk(clk), .L(L), .q_in(Q1[0]), .r_in(r_in[1]), .Q(Q2[0]));
    top_module u3 (.clk(clk), .L(L), .q_in(Q2[0]), .r_in(r_in[2]), .Q(Q3[0]));

    assign q_out = {Q3[0], Q2[0], Q1[0]};

endmodule