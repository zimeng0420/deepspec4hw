module top_module(
    input clk, 
    input load, 
    input [9:0] data, 
    output reg tc
);
    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;          // Load data into the counter
        end else if (counter > 0) begin
            counter <= counter - 1;   // Decrement the counter
        end
    end

    always @(*) begin
        tc = (counter == 0);          // Assert terminal count when counter reaches 0
    end
endmodule