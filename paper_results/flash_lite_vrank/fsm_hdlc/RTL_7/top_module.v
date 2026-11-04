module top_module (
	input clk,
	input reset,
	input in,
	output disc,
	output flag,
	output err
);

	// Define states
	localparam S_ZERO = 4'b0000;
	localparam S_ONE = 4'b0001;
	localparam S_ONE_ONE = 4'b0010;
	localparam S_ONE_ONE_ONE = 4'b0011;
	localparam S_ONE_ONE_ONE_ONE = 4'b0100;
	localparam S_ONE_ONE_ONE_ONE_ONE = 4'b0101;
	localparam S_ONE_ONE_ONE_ONE_ONE_ONE = 4'b0110;
	localparam S_ONE_ONE_ONE_ONE_ONE_ONE_ONE = 4'b0111;
	localparam S_DISC = 4'b1000;
	localparam S_FLAG = 4'b1001;
	localparam S_ERR = 4'b1010;
	
	// State register
	reg [3:0] state, next_state;

	// Output registers
	reg disc_r, flag_r, err_r;

	// State transition logic
	always @(posedge clk) begin
		if (reset) begin
			state <= S_ZERO;
			disc_r <= 1'b0;
			flag_r <= 1'b0;
			err_r <= 1'b0;
		end else begin
			state <= next_state;
			disc_r <= disc;
			flag_r <= flag;
			err_r <= err;
		end
	end
	
	// Next state and output logic
	always @(*) begin
		next_state = S_ZERO;
		disc = 1'b0;
		flag = 1'b0;
		err = 1'b0;
		
		case (state)
			S_ZERO: begin
				if (in) next_state = S_ONE;
			end
			S_ONE: begin
				if (in) next_state = S_ONE_ONE; else next_state = S_ZERO;
			end
			S_ONE_ONE: begin
				if (in) next_state = S_ONE_ONE_ONE; else next_state = S_ZERO;
			end
			S_ONE_ONE_ONE: begin
				if (in) next_state = S_ONE_ONE_ONE_ONE; else next_state = S_ZERO;
			end
			S_ONE_ONE_ONE_ONE: begin
				if (in) next_state = S_ONE_ONE_ONE_ONE_ONE; else next_state = S_ZERO;
			end
			S_ONE_ONE_ONE_ONE_ONE: begin
				if (in) begin
					next_state = S_ONE_ONE_ONE_ONE_ONE_ONE;
				end else begin
					next_state = S_DISC;
					disc = 1'b1;
				end
			end
			S_ONE_ONE_ONE_ONE_ONE_ONE: begin
				if (in) begin
					next_state = S_ONE_ONE_ONE_ONE_ONE_ONE_ONE;
				end else begin
					next_state = S_FLAG;
					flag = 1'b1;
				end
			end
			S_ONE_ONE_ONE_ONE_ONE_ONE_ONE: begin
				next_state = S_ERR;
				err = 1'b1;
			end
			S_DISC: begin
				next_state = S_ZERO;
			end
			S_FLAG: begin
				next_state = S_ZERO;
			end
			S_ERR: begin
				next_state = S_ZERO;
			end
			default: begin
				next_state = S_ZERO;
			end
		endcase
	end
	
endmodule