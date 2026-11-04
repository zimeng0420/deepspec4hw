module top_module(
    input clk, 
    input load, 
    input [9:0] data, 
    output reg tc
);
    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;  // Load the counter with 'data' on load signal
            tc <= 0;         // Reset terminal count when loading new value
        end else if (counter > 0) begin
            counter <= counter - 1; // Decrement counter
        end
        
        // Assert tc when counter reaches zero
        if (counter == 0) begin
            tc <= 1; // Terminal count
        end else begin
            tc <= 0; // Ensure tc is low when counter is not zero
        end
    end
endmodule