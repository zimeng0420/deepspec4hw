module top_module(
    input clk, 
    input load, 
    input [9:0] data, 
    output reg tc
);

    reg [9:0] counter;  // Internal 10-bit counter

    always @(posedge clk) begin
        if (load) begin
            counter <= data;  // Load the counter with the input data
            tc <= 0;          // Reset the terminal count signal
        end
        else if (counter > 0) begin
            counter <= counter - 1;  // Decrement the counter
            tc <= 0;                // Ensure terminal count is de-asserted
        end
        else begin
            tc <= 1;  // Assert terminal count when counter reaches 0
        end
    end

endmodule