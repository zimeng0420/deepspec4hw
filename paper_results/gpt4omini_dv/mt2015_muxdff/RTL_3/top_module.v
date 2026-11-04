module top_module(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // Combinational logic implementation
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

module hierarchical_module(
    input clk,
    input L,
    input [2:0] r,
    output [2:0] q
);
    wire Q1, Q2, Q3;

    top_module inst1(.clk(clk), .L(L), .q_in(Q2), .r_in(r[0]), .Q(Q1));
    top_module inst2(.clk(clk), .L(L), .q_in(Q3), .r_in(r[1]), .Q(Q2));
    top_module inst3(.clk(clk), .L(L), .q_in(Q1), .r_in(r[2]), .Q(Q3));

    full_module inst_full(.r(r), .L(L), .clk(clk), .q(q));

endmodule