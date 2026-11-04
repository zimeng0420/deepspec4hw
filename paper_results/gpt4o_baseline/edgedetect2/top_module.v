module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Detect any edge (rising or falling) by comparing current and previous inputs
        anyedge <= (in ^ prev_in) & ~prev_in;
        prev_in <= in; // Update the previous input on every clock cycle
    end

endmodule