module top_module(
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);
    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data; // Load the new value into the counter
            tc <= 0; // Reset terminal count
        end else if (counter > 0) begin
            counter <= counter - 1; // Decrement the counter
            if (counter == 1) begin
                tc <= 1; // Assert terminal count when about to reach 0
            end else begin
                tc <= 0; // Clear terminal count otherwise
            end
        end
    end

    // Hold tc signal at 1 until a new load occurs
    always @(posedge clk) begin
        if (load) begin
            tc <= 0; // Reset terminal count on load
        end else if (counter == 0) begin
            tc <= 1; // Assert terminal count when counter is 0
        end
    end
endmodule