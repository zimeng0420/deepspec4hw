module top_module(
    input clk,
    input load,
    input [9:0] data,
    output tc
);
    reg [9:0] counter; // 10-bit internal counter

    // Always block to handle counter logic
    always @(posedge clk) begin
        if (load) begin
            counter <= data; // Load data into the counter
        end else if (counter != 0) begin
            counter <= counter - 1; // Decrement the counter if it's not zero
        end
    end

    // Terminal count output is asserted when counter reaches 0
    assign tc = (counter == 0);

endmodule