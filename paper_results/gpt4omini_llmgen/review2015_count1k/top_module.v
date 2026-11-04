module top_module(
    input clk,            // Clock input
    input reset,         // Active high synchronous reset input
    output reg [9:0] q   // 10-bit output to hold the counter value
);

    // Internal register to store the counter value
    reg [9:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 10'd0;   // Reset the counter to 0 when reset is high
        end 
        else if (count < 10'd999) begin
            count <= count + 1; // Increment the counter
        end
    end

    assign q = count; // Assigning the current count value to output q

endmodule