module top_module(
    input clk,
    input d,
    output reg q
);
    reg d_pos_edge, d_neg_edge;

    always @(posedge clk) begin
        d_pos_edge <= d; // Capture d on rising edge
    end
    
    always @(negedge clk) begin
        d_neg_edge <= d; // Capture d on falling edge
    end

    always @* begin
        q = (clk) ? d_pos_edge : d_neg_edge; // Update q based on clk state
    end
endmodule