module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q
);

// Temporary register to hold next state
reg [511:0] q_next;

always @(*) begin
    // Compute the next state of each cell
    q_next[0] = (q[0] & q[1]) ? 0 : (q[1] ? 1 : 0); // q[-1] = 0
    q_next[511] = (q[510] & q[511]) ? 0 : (q[510] ? 1 : 0); // q[512] = 0
    
    for (int i = 1; i < 511; i = i + 1) begin
        case ({q[i-1], q[i], q[i+1]})
            3'b111: q_next[i] = 0;
            3'b110: q_next[i] = 1;
            3'b101: q_next[i] = 1;
            3'b100: q_next[i] = 0;
            3'b011: q_next[i] = 1;
            3'b010: q_next[i] = 1;
            3'b001: q_next[i] = 1;
            3'b000: q_next[i] = 0;
        endcase
    end
end

always @(posedge clk) begin
    if (load) begin
        q <= data; // Load new state
    end else begin
        q <= q_next; // Update to next state
    end
end

endmodule