module top_module (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // Submodule instantiation (assuming ff_mux is defined elsewhere)
    ff_mux my_ff_mux (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .Q(Q)
    );

endmodule

module ff_mux (
    input clk,
    input L,
    input r_in,
    input q_in,
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

    wire [2:0] q_next;

    top_module top_module_inst0 (
        .clk(clk),
        .L(L),
        .q_in(q[0]),
        .r_in(r[0]),
        .Q(q_next[0])
    );

    top_module top_module_inst1 (
        .clk(clk),
        .L(L),
        .q_in(q[1]),
        .r_in(r[1]),
        .Q(q_next[1])
    );

    top_module top_module_inst2 (
        .clk(clk),
        .L(L),
        .q_in(q[2]),
        .r_in(r[2]),
        .Q(q_next[2])
    );

    always @(posedge clk) begin
        if (L) begin
            q <= r;
        end else begin
            q <= {q_next[1] , q_next[0], q_next[2]};
        end
    end

endmodule