module top_module (
	input clk,
	input reset,
	input in,
	output disc,
	output flag,
	output err
);

	parameter S_START = 3'b000; // Initial state (treat previous input as 0)
	parameter S_ONE = 3'b001;
	parameter S_TWO = 3'b010;
	parameter S_THREE = 3'b011;
	parameter S_FOUR = 3'b100;
	parameter S_FIVE = 3'b101;
	parameter S_SIX = 3'b110;
	parameter S_ERROR = 3'b111;

	reg [2:0] state, next_state;
	reg disc_reg, flag_reg, err_reg;

	// State register
	always @(posedge clk) begin
		if (reset)
			state <= S_START;
		else
			state <= next_state;
	end

	// Output register
	always @(posedge clk) begin
		if (reset) begin
			disc_reg <= 1'b0;
			flag_reg <= 1'b0;
			err_reg <= 1'b0;
		end else begin
			disc_reg <= disc;
			flag_reg <= flag;
			err_reg <= err;
		end
	end

	// Next state logic and output logic
	always @(*) begin
		next_state = S_START; // Default next state
		disc = 1'b0;
		flag = 1'b0;
		err = 1'b0;

		case (state)
			S_START: begin
				if (in)
					next_state = S_ONE;
				else
					next_state = S_START;
			end
			S_ONE: begin
				if (in)
					next_state = S_TWO;
				else
					next_state = S_START;
			end
			S_TWO: begin
				if (in)
					next_state = S_THREE;
				else
					next_state = S_START;
			end
			S_THREE: begin
				if (in)
					next_state = S_FOUR;
				else
					next_state = S_START;
			end
			S_FOUR: begin
				if (in)
					next_state = S_FIVE;
				else
					next_state = S_START;
			end
			S_FIVE: begin
				if (in)
					next_state = S_SIX;
				else begin
					next_state = S_START;
					disc = 1'b1;
				end
			end
			S_SIX: begin
				if (in) begin
					next_state = S_ERROR;
				end
				else begin
					next_state = S_START;
					flag = 1'b1;
				end

			end
			S_ERROR: begin
				next_state = S_ERROR;
				err = 1'b1;
			end
			default:
				next_state = S_START;

		endcase
	end

	assign disc = disc_reg;
	assign flag = flag_reg;
	assign err = err_reg;

endmodule