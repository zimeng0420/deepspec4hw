module top_module(
    input clk, 
    input load, 
    input [9:0] data, 
    output reg tc
);
    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data; // Load the counter with the data
            tc <= 0; // Reset terminal count
        end else if (counter > 0) begin
            counter <= counter - 1; // Decrement counter
        end 
        if (counter == 0) begin
            tc <= 1; // Assert terminal count
        end
    end
endmodule