module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge);

    reg [7:0] prev_in; // Register to store the previous value of 'in'

    always @(posedge clk) begin
        anyedge <= ((~prev_in) & in); // Detect 0-to-1 transitions and set the corresponding output bits
        prev_in <= in;               // Update the previous input value on each clock cycle
    end

endmodule