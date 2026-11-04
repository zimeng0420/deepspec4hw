module top_module(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;

    // Internal signals
    wire counter_enable;

    // Determine when to enable the counter decrement
    assign counter_enable = !load && (counter != 0); // Decrement only if not loading and counter is not zero

    // Counter logic
    always @(posedge clk) begin
        if (load) begin
            counter <= data; // Load the counter with the data value
        end else if (counter_enable) begin
            counter <= counter - 1; // Decrement the counter
        end
    end

    // Terminal count logic
    assign tc = (counter == 0); // Assert tc when counter reaches zero

endmodule