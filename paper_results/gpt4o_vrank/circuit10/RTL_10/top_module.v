module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output state
);

reg state_ff;

assign state = state_ff;

always @(posedge clk) begin
    state_ff <= (a & b) | (state_ff & ~a & ~b);
    q <= state_ff;
end

endmodule