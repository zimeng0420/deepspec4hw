module top_module (
	input clk,
	input a,
	input b,
	output reg q,
	output reg state
);

reg next_state;

always @(posedge clk) begin
    state <= next_state;
end

always @(*) begin
    // Determine next state and output
    if (a & b) begin
        next_state = ~state;
    end else if (a & ~b) begin
        next_state = 1;
    end else if (~a & b) begin
        next_state = 0;
    end else begin
        next_state = state;
    end
    
    q = next_state;
end

endmodule