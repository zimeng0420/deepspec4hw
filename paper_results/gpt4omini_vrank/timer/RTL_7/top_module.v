module top_module(
    input clk, 
    input load, 
    input [9:0] data, 
    output reg tc
);
    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;  // Load new value into counter
            tc <= 0;         // Reset terminal count
        end else if (counter > 0) begin
            counter <= counter - 1;  // Decrement counter
            if (counter == 1) tc <= 1; // Assert tc when going to 0
        end
    end

    always @(posedge clk) begin
        if (counter == 0) begin
            tc <= 1; // Assert tc when counter reaches 0
        end
    end
endmodule