module top_module(
	input clk,
	input areset, 

	input predict_valid,
	input [6:0] predict_pc,
	output reg predict_taken, 
	output reg [6:0] predict_history,

	input train_valid,
	input train_taken,
	input train_mispredicted,
	input [6:0] train_history, 
	input [6:0] train_pc
);

	// 128-entry Pattern History Table (PHT) of 2-bit saturating counters
	reg [1:0] pht [0:127];
	integer i;

	// Global Branch History Register
	reg [6:0] global_history;

	// Initialize or reset logic
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			// Resetting all PHT counters and the global history register
			global_history <= 7'b0;
			for (i = 0; i < 128; i = i + 1) begin
				pht[i] <= 2'b01;  // weakly not taken state
			end
		end else begin
			if (train_valid) begin
				// Calculate index for training
				reg [6:0] train_index;
				train_index = train_pc ^ train_history;
				
				// Update PHT based on actual branch outcome
				if (train_taken) begin
					pht[train_index] <= (pht[train_index] == 2'b11) ? 2'b11 : pht[train_index] + 2'b1;
				end else begin
					pht[train_index] <= (pht[train_index] == 2'b00) ? 2'b00 : pht[train_index] - 2'b1;
				end

				// Update or recover the global history register
				if (train_mispredicted) begin
					global_history <= {train_history[5:0], train_taken};
				end else begin
					global_history <= {global_history[5:0], train_taken};
				end
			end
		end
	end

	// Predict logic
	always @(posedge clk) begin
		if (predict_valid) begin
			// Calculate index for prediction
			reg [6:0] predict_index;
			predict_index <= predict_pc ^ global_history;

			// Output the predicted state
			predict_taken <= (pht[predict_index] >= 2'b10) ? 1'b1 : 1'b0;
			predict_history <= global_history;
		end
	end

endmodule