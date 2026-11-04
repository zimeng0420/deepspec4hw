module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Positive edge detection logic for each bit
        pedge <= in & ~prev_in;
        // Update prev_in with current input value
        prev_in <= in;
    end

endmodule