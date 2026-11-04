module top_module(
    input clk, 
    input load, 
    input [9:0] data, 
    output reg tc
);
    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;  // Load the internal counter
            tc <= 0;         // Clear terminal count
        end else if (counter > 0) begin
            counter <= counter - 1; // Decrement the counter
            if (counter == 1) begin
                tc <= 1; // Assert terminal count when reaching 0
            end
        end
    end

    always @(posedge clk) begin
        if (counter == 0) begin
            tc <= 1; // Ensure terminal count stays asserted
        end
    end
endmodule