module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;
reg [7:0] delayed_pedge;

always @(posedge clk) begin
    // Detect positive edges and store the result in delayed_pedge
    delayed_pedge <= (in & ~prev_in);

    // Update the previous input value
    prev_in <= in;

    // Delay the positive edge signal by one clock cycle
    pedge <= delayed_pedge;
end

endmodule