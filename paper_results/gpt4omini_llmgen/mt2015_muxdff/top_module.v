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
            Q <= q_in;
        end
    end
endmodule

module full_module (
    input [2:0] r,
    input L,
    input clk,
    output reg [2:0] q
);
    wire q0_out, q1_out, q2_out;

    top_module instance0 (
        .clk(clk),
        .L(L),
        .q_in(q1_out),
        .r_in(r[0]),
        .Q(q0_out)
    );

    top_module instance1 (
        .clk(clk),
        .L(L),
        .q_in(q2_out),
        .r_in(r[1]),
        .Q(q1_out)
    );

    top_module instance2 (
        .clk(clk),
        .L(L),
        .q_in(q0_out ^ q1_out), // XOR operation based on requirements
        .r_in(r[2]),
        .Q(q2_out)
    );

    always @(posedge clk) begin
        if (L) begin
            q <= r;
        end else begin
            q <= {q1_out ^ q2_out, q0_out, q2_out}; // Logic shifting as described
        end
    end
endmodule