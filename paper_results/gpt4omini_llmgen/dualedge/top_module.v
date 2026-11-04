module top_module(
    input clk,
    input d,
    output reg q
);
    
    reg d_latch; // Intermediate register to store the value of d on the falling edge

    always @(posedge clk) begin
        q <= d;          // Capture input d on the rising edge
    end

    always @(negedge clk) begin
        d_latch <= d;    // Capture input d on the falling edge
        q <= d_latch;    // Update output q with the value captured on the falling edge
    end

endmodule