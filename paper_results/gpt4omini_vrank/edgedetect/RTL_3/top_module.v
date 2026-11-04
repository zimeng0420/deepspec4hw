module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);
    reg [7:0] in_d; // to hold the previous state

    always @(posedge clk) begin
        pedge <= in_d & ~in; // set output on transition from 0 to 1
        in_d <= in; // update previous state
    end
endmodule