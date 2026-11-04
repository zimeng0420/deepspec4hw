module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        pedge <= in & ~prev_in; // Detect 0-to-1 transition for each bit
        prev_in <= in;         // Store the current input value for the next cycle
    end

endmodule