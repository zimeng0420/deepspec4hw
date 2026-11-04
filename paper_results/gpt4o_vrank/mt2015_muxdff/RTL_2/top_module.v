module top_module (
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
    output [2:0] q
);

    wire [2:0] Q_internal;

    // Instantiate top_module three times
    top_module instance0 (
        .clk(clk),
        .L(L),
        .q_in(Q_internal[2] ^ Q_internal[1]),  // q[1] ^ q[2]
        .r_in(r[0]),
        .Q(Q_internal[0])
    );

    top_module instance1 (
        .clk(clk),
        .L(L),
        .q_in(Q_internal[0]),  // q[0]
        .r_in(r[1]),
        .Q(Q_internal[1])
    );

    top_module instance2 (
        .clk(clk),
        .L(L),
        .q_in(Q_internal[2]),  // q[2]
        .r_in(r[2]),
        .Q(Q_internal[2])
    );

    assign q = Q_internal;

endmodule