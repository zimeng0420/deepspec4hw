module top_module (
	input clk,
	input reset,
	input in,
	output disc,
	output flag,
	output err
);

	// Define states
	localparam IDLE = 3'b000;
	localparam ONE = 3'b001;
	localparam TWO = 3'b010;
	localparam THREE = 3'b011;
	localparam FOUR = 3'b100;
	localparam FIVE = 3'b101;
	localparam SIX = 3'b110;
	localparam SEVEN = 3'b111;


	// State register
	reg [2:0] state, next_state;

	// Output registers
	reg disc_reg, flag_reg, err_reg;


	// State transition logic
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
            
			case (next_state)
                SIX: disc_reg <= 1'b1;
                SEVEN: err_reg <= 1'b1;
                SIX: flag_reg <= in; // flag on 0 after six 1s
            endcase
		end
	end

	// Next state logic
	always @(*) begin
		next_state = IDLE; // Default next state

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
				else
					next_state = IDLE;
			end
			SIX: begin
				if (in)
					next_state = SEVEN;
				else
					next_state = IDLE;
			end
			SEVEN: begin
				if (in)
					next_state = SEVEN; // Stay in error state
				else
					next_state = IDLE;
			end
			default: next_state = IDLE;
		endcase
	end

	// Output assignments
	assign disc = disc_reg;
	assign flag = flag_reg;
	assign err = err_reg;

endmodule