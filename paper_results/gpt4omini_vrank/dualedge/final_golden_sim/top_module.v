module top_module(
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d; // Capture d on the rising edge
    end
    
    always @(negedge clk) begin
        q <= d; // Capture d on the falling edge
    end
endmodule