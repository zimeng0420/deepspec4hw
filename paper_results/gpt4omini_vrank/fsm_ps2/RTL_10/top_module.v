module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output reg done
);

typedef enum reg [1:0] {
	IDLE = 2'b00,
	RECEIVING = 2'b01,
	DONE = 2'b10
} state_t;

state_t current_state, next_state;
reg [1:0] byte_count;

always @(posedge clk) begin
	if (reset) begin
		current_state <= IDLE;
		byte_count <= 0;
		done <= 0;
	end else begin
		current_state <= next_state;
		if (next_state == DONE) begin
			done <= 1;
		end else begin
			done <= 0;
		end
	end
end

always @(*) begin
	case (current_state)
		IDLE: begin
			if (in[3] == 1) begin
				next_state = RECEIVING;
				byte_count = 1;
			end else begin
				next_state = IDLE;
				byte_count = 0;
			end
		end

		RECEIVING: begin
			if (byte_count < 2) begin
				if (in[3] == 0) begin
					byte_count = byte_count + 1;
					next_state = RECEIVING;
				end else begin
					byte_count = byte_count + 1;
					if (byte_count == 2) begin
						next_state = DONE;
					end else begin
						next_state = RECEIVING;
					end
				end
			end
		end

		DONE: begin
			next_state = IDLE;
			byte_count = 0;
		end

		default: begin
			next_state = IDLE;
			byte_count = 0;	
		end
	endcase
end

endmodule