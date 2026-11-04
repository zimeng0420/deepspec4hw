module top_module(
    input clk, 
    input load, 
    input [9:0] data, 
    output reg tc
);
    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;  // Load the counter with data
            tc <= 0;         // Clear terminal count
        end else if (counter > 0) begin
            counter <= counter - 1;  // Decrement counter
        end
        
        if (counter == 0) begin
            tc <= 1; // Assert terminal count when counter reaches 0
        end
    end
endmodule