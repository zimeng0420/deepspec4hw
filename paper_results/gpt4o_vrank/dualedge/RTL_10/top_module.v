module top_module(
    input clk,
    input d,
    output reg q
);
    
    reg q_pos, q_neg;
    
    // Positive edge triggered block
    always @(posedge clk) begin
        q_pos <= d;
    end
    
    // Negative edge triggered block
    always @(negedge clk) begin
        q_neg <= d;
    end
    
    // Output logic
    always @(*) begin
        q = clk ? q_neg : q_pos;
    end

endmodule