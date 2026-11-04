module top_module(
    input clk,
    input d,
    output reg q
);
    
    reg d1, d2;

    always @(posedge clk) begin
        d1 <= d; // Capture d on rising edge
    end
    
    always @(negedge clk) begin
        d2 <= d; // Capture d on falling edge
    end

    always @* begin
        q = (clk) ? d1 : d2; // Output based on the current clock state
    end

endmodule