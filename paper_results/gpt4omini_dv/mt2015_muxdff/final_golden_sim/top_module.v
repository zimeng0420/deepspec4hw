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

module hierarchical_module (
    input clk,
    input L,
    input [2:0] r_in,
    output [2:0] q_out
);
    wire [2:0] q0, q1, q2;
    full_module inst0 (.r(r_in), .L(L), .clk(clk), .q(q0));
    full_module inst1 (.r(q0), .L(L), .clk(clk), .q(q1));
    full_module inst2 (.r(q1), .L(L), .clk(clk), .q(q2));
    
    assign q_out = q2;

endmodule