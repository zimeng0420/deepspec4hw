module top_module (
	input clk,
	input in,
	input reset,
	output reg [7:0] out_byte,
	output reg done
);

	typedef enum logic [2:0] {
		IDLE,
		START_BIT,
		DATA_RECEIVE_0,
		DATA_RECEIVE_1,
		DATA_RECEIVE_2,
		DATA_RECEIVE_3,
		DATA_RECEIVE_4,
		DATA_RECEIVE_5,
		DATA_RECEIVE_6,
		DATA_RECEIVE_7,
		STOP_BIT,
		ERROR
	} state_t;

	state_t current_state, next_state;
	reg [2:0] bit_count;

	always_ff @(posedge clk or posedge reset) begin
		if (reset) begin
			current_state <= IDLE;
			bit_count <= 0;
			out_byte <= 8'b0;
			done <= 0;
		end else begin
			current_state <= next_state;
		end
	end

	always_ff @(posedge clk) begin
		if (current_state == DATA_RECEIVE_0) out_byte[0] <= in;
		else if (current_state == DATA_RECEIVE_1) out_byte[1] <= in;
		else if (current_state == DATA_RECEIVE_2) out_byte[2] <= in;
		else if (current_state == DATA_RECEIVE_3) out_byte[3] <= in;
		else if (current_state == DATA_RECEIVE_4) out_byte[4] <= in;
		else if (current_state == DATA_RECEIVE_5) out_byte[5] <= in;
		else if (current_state == DATA_RECEIVE_6) out_byte[6] <= in;
		else if (current_state == DATA_RECEIVE_7) out_byte[7] <= in;
	end

	always_comb begin
		next_state = current_state;
		done = 0;

		case (current_state)
			IDLE: begin
				if (in == 0) // Start bit detected
					next_state = START_BIT;
			end

			START_BIT: begin
				if (bit_count == 7) begin
					next_state = STOP_BIT; // Check for stop bit after data reception
				end else begin
					next_state = DATA_RECEIVE_0 + bit_count;
				end
			end

			DATA_RECEIVE_0: bit_count = 0;
			DATA_RECEIVE_1: bit_count = 1;
			DATA_RECEIVE_2: bit_count = 2;
			DATA_RECEIVE_3: bit_count = 3;
			DATA_RECEIVE_4: bit_count = 4;
			DATA_RECEIVE_5: bit_count = 5;
			DATA_RECEIVE_6: bit_count = 6;
			DATA_RECEIVE_7: bit_count = 7;

			STOP_BIT: begin
				if (in == 1) begin
					done = 1; // Stop bit verified
					next_state = IDLE; // Go back to idle to wait for the next byte
				end else begin
					next_state = ERROR; // Error if stop bit is not detected
				end
			end

			ERROR: begin
				if (in == 1) begin
					next_state = IDLE; // Reset on idle
				end
			end
		endcase
	end

endmodule