module top_module(
    input clk, 
    input load, 
    input [9:0] data, 
    output reg tc
);
    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data; // Load the counter with the provided data
            tc <= 0; // Reset terminal count
        end else if (counter > 0) begin
            counter <= counter - 1; // Decrement the counter
            if (counter == 1) begin
                tc <= 1; // Assert terminal count when it will reach 0
            end
        end else begin
            tc <= 1; // Terminal count remains asserted
        end
    end
endmodule