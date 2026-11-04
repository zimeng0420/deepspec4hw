module top_module(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter; // 10-bit register for storing the counter value

    always @(posedge clk) begin
        if (load) begin
            counter <= data; // Load the counter with data when load is asserted
        end else if (counter != 10'b0) begin
            counter <= counter - 1'b1; // Decrement the counter if it is greater than 0
        end
        // If counter is 0, maintain the value (no further decrement)
    end

    assign tc = (counter == 10'b0); // tc is asserted when counter reaches 0

endmodule