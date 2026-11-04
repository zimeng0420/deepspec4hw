module top_module (
	input clk,
	input reset,
	input in,
	output disc,
	output flag,
	output err
);

	// State Definition
	parameter IDLE = 3'b000;
	parameter ONE = 3'b001;
	parameter TWO = 3'b010;
	parameter THREE = 3'b011;
	parameter FOUR = 3'b100;
	parameter FIVE = 3'b101;
	parameter SIX = 3'b110;
	parameter SEVEN = 3'b111;

	// State Register
	reg [2:0] state, next_state;
	
	// Output Registers
	reg disc_reg, flag_reg, err_reg;

	// State Transition Logic
	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			disc_reg <= 1'b0;
			flag_reg <= 1'b0;
			err_reg <= 1'b0;
		end else begin
			state <= next_state;
			disc_reg <= 1'b0;
			flag_reg <= 1'b0;
			err_reg <= 1'b0;
		end
	end
		
	// Next State and Output Logic
	always @(*) begin
		next_state = IDLE;
		disc = 1'b0;
		flag = 1'b0;
		err = 1'b0;

		case (state)
			IDLE: begin
				if (in)
					next_state = ONE;
				else
					next_state = IDLE;
			end
			ONE: begin
				if (in)
					next_state = TWO;
				else
					next_state = IDLE;
			end
			TWO: begin
				if (in)
					next_state = THREE;
				else
					next_state = IDLE;
			end
			THREE: begin
				if (in)
					next_state = FOUR;
				else
					next_state = IDLE;
			end
			FOUR: begin
				if (in)
					next_state = FIVE;
				else
					next_state = IDLE;
			end
			FIVE: begin
				if (in)
					next_state = SIX;
				else begin
					next_state = IDLE;
					disc = 1'b1;
				end
			end
			SIX: begin
				if (in)
					next_state = SEVEN;
				else begin
					next_state = IDLE;
					flag = 1'b1;
				end
			end
			SEVEN: begin
				next_state = SEVEN;
				err = 1'b1;
			end
			default: next_state = IDLE;
		endcase
	end

	// Output Assignment
	always @(posedge clk) begin
		if(reset) begin
			disc <= 1'b0;
			flag <= 1'b0;
			err <= 1'b0;
		end else begin
			disc <= disc_reg;
			flag <= flag_reg;
			err <= err_reg;
		end
	end

endmodule