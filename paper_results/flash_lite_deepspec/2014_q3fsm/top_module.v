module top_module (
	input clk,
	input reset,
	input s,
	input w,
	output reg z
);

	parameter A = 2'b00;
	parameter B = 2'b01;

	reg [1:0] state;
	reg [1:0] count;
	reg [2:0] w_history; // Store the last three values of w

	always @(posedge clk) begin
		if (reset) begin
			state <= A;
			z <= 0;
			count <= 2'b00;
			w_history <= 3'b000;
		end else begin
			case (state)
				A: begin
					z <= 0;
					if (s) begin
						state <= B;
						w_history <= {w, w_history[2:1]}; // Shift in the current w
					end else begin
						state <= A;
					end
				end
				B: begin
					w_history <= {w, w_history[2:1]}; // Shift in the current w
					count <= count + w; // Increment count if w is 1
					if (count == 2'b10) begin // Check if exactly two w's were 1
						z <= 1;
					end else if (count == 2'b11) begin
						z <= 0;
					end
					else begin
						z <= 0;
					end
					if (count == 2'b11) begin
						count <= 2'b00;
					end
					if (count == 2'b10) begin
						count <= 2'b00;
					end
					if (count == 2'b01) begin
						count <= 2'b01;
					end
					if (count == 2'b00) begin
						count <= 2'b00;
					end
					if (count == 2'b11) begin
						state <= B;
					end
					else if (count == 2'b10) begin
						state <= B;
					end
					else begin
						state <= B;
					end
				end
				default: begin
					state <= A;
					z <= 0;
					count <= 2'b00;
					w_history <= 3'b000;
				end
			endcase
		end
	end

endmodule