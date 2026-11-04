module top_module(
    input clk,
    input d,
    output reg q);

    reg q1, q2;
    
    always @(posedge clk) begin
        q1 <= d;  // Sample d on rising edge of clk
    end
    
    always @(negedge clk) begin
        q2 <= d;  // Sample d on falling edge of clk
    end
    
    always @(*) begin
        q = clk ? q1 : q2;  // Use mux-like behavior to set q based on clk
    end

endmodule