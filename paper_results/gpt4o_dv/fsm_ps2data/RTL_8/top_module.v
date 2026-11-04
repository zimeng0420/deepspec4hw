module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output reg [23:0] out_bytes,
	output reg done
);

	reg [1:0] state, next_state;
	reg [23:0] buffer;
	
	// State Encoding
	localparam IDLE = 2'b00, BYTE1 = 2'b01, BYTE2 = 2'b10, BYTE3 = 2'b11;

	// State Transition (Sequential Logic)
	always @(posedge clk) begin
		if (reset)
			state <= IDLE;
		else
			state <= next_state;
	end

	// Next State Logic and Output Logic (Combinational Logic)
	always @(*) begin
		// Default values
		next_state = state;
		done = 0;
		
		case (state)
			IDLE: begin
				if (in[3] == 1'b1) begin
					next_state = BYTE1;
					buffer[23:16] = in;
				end
			end
			
			BYTE1: begin
				next_state = BYTE2;
				buffer[15:8] = in;
			end
			
			BYTE2: begin
				next_state = BYTE3;
				buffer[7:0] = in;
			end
			
			BYTE3: begin
				done = 1;
				next_state = IDLE;
				out_bytes = buffer;
			end
		endcase
	end

endmodule