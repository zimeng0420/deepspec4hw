module top_module (
	input clk,
	input resetn,
	input [3:1] r,
	output [3:1] g
);

	// State Definitions
	parameter A = 2'b00;
	parameter B = 2'b01;
	parameter C = 2'b10;
    parameter D = 2'b11;

	// Internal Signals
	reg [1:0] state, next_state;

	// Output Assignments
	always @(*) begin
		case (state)
			B: g[1] = 1'b1;
			C: g[2] = 1'b1;
			D: g[3] = 1'b1;
			default: g[1] = 1'b0;
					 g[2] = 1'b0;
					 g[3] = 1'b0;
		endcase
	end

	// State Table (Combinational Logic)
	always @(*) begin
		case (state)
			A: begin
				if (r[1])
					next_state = B;
				else if (r[2])
					next_state = C;
				else if (r[3])
                    next_state = D;
                else
					next_state = A;
			end
			B: begin
				if (r[1])
					next_state = B;
				else
					next_state = A;
			end
			C: begin
				if (r[2])
					next_state = C;
				else
					next_state = A;
			end
            D: begin
                if (r[1] | r[2] | r[3])
                    next_state = A;
                else
                    next_state = D;
            end
			default: next_state = A;
		endcase
	end

	// State Flip-Flops (Sequential Logic)
	always @(posedge clk or negedge resetn) begin
		if (!resetn)
			state <= A;
		else
			state <= next_state;
	end

endmodule