module top_module(
    input clk,
    input L,
    input [2:0] r,
    output [2:0] q
);
    
    wire [2:0] q_out1, q_out2, q_out3;
    
    full_module instance1 (
        .r(r),
        .L(L),
        .clk(clk),
        .q(q_out1)
    );
    
    full_module instance2 (
        .r(q_out1),
        .L(L),
        .clk(clk),
        .q(q_out2)
    );
    
    full_module instance3 (
        .r(q_out2),
        .L(L),
        .clk(clk),
        .q(q_out3)
    );
    
    assign q = q_out3;

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