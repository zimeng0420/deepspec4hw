module top_module (
    input clk,
    input L,
    input r_in,
    input q_in,
    output reg Q
);

    // Submodule instantiation (ff_mux)
    // Assuming ff_mux has the following interface:
    // module ff_mux (
    //     input clk,
    //     input L,
    //     input r_in,
    //     input q_in,
    //     output reg Q
    // );
    
    ff_mux my_ff_mux (
        .clk(clk),
        .L(L),
        .r_in(r_in),
        .q_in(q_in),
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

    wire [2:0] next_q;

    // Instantiate top_module three times
    top_module inst0 (
        .clk(clk),
        .L(L),
        .r_in(r[0]),
        .q_in(q[0]),
        .Q(next_q[0])
    );

    top_module inst1 (
        .clk(clk),
        .L(L),
        .r_in(r[1]),
        .q_in(q[1]),
        .Q(next_q[1])
    );

    top_module inst2 (
        .clk(clk),
        .L(L),
        .r_in(r[2]),
        .q_in(q[2]),
        .Q(next_q[2])
    );
    
    always @(posedge clk) begin
        if (L) begin
            q <= r;
        end else begin
            q <= {q[1] ^ q[2], q[0], q[2]};
        end
    end

endmodule