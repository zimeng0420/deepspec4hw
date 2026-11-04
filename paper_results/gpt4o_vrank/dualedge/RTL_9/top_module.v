module top_module(
    input clk,
    input d,
    output reg q
);

    reg q_pos, q_neg;

    // Positive edge triggered always block
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge triggered always block
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Combine outputs to create dual-edge functionality
    always @(posedge clk or negedge clk) begin
        q <= (clk) ? q_pos : q_neg;
    end

endmodule