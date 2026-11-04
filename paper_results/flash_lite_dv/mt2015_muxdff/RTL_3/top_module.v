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

module top_module (
    input [2:0] r,
    input L,
    input clk,
    output reg [2:0] q
);

    wire [2:0] q_next;

    ff_mux ff_mux_inst0 (
        .clk(clk),
        .L(L),
        .r_in(r[0]),
        .q_in(q[0]),
        .Q(q_next[0])
    );

    ff_mux ff_mux_inst1 (
        .clk(clk),
        .L(L),
        .r_in(r[1]),
        .q_in(q[1]),
        .Q(q_next[1])
    );

    ff_mux ff_mux_inst2 (
        .clk(clk),
        .L(L),
        .r_in(r[2]),
        .q_in(q[2]),
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