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

module full_module(
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

module hierarchical_design(
    input clk,
    input L,
    input [2:0] r,
    output [2:0] q
);
    wire [2:0] q_inst0, q_inst1, q_inst2;

    full_module u1 (
        .r(r),
        .L(L),
        .clk(clk),
        .q(q_inst0)
    );

    full_module u2 (
        .r(q_inst0),
        .L(L),
        .clk(clk),
        .q(q_inst1)
    );

    full_module u3 (
        .r(q_inst1),
        .L(L),
        .clk(clk),
        .q(q_inst2)
    );

    assign q = q_inst2;

endmodule