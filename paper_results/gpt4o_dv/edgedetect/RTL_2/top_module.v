module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in; // Register to store previous input state

    always @(posedge clk) begin
        // Positive edge detection logic
        pedge <= in & ~prev_in; // Set pedge if current in is 1 and previous in was 0

        // Update previous input state
        prev_in <= in;
    end

endmodule