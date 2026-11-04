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

module top_level (
    input clk,
    input L,
    input [2:0] r,
    output [2:0] q_out
);
    wire [2:0] q1, q2, q3;

    full_module inst1 (
        .r(r), 
        .L(L), 
        .clk(clk), 
        .q(q1)
    );

    full_module inst2 (
        .r(r), 
        .L(L), 
        .clk(clk), 
        .q(q2)
    );

    full_module inst3 (
        .r(r), 
        .L(L), 
        .clk(clk), 
        .q(q3)
    );

    assign q_out = q1 | q2 | q3; // Combine outputs for demonstration

endmodule