module top_module(
	input clk,
	input areset,
	input predict_valid,
	input [6:0] predict_pc,
	output predict_taken,
	output [6:0] predict_history,
	input train_valid,
	input train_taken,
	input train_mispredicted,
	input [6:0] train_history,
	input [6:0] train_pc
);

	// 128-entry Pattern History Table (PHT) of 2-bit counters
	reg [1:0] PHT [0:127];
	// 7-bit global branch history register
	reg [6:0] GHR;

	// Output assignments
	reg predict_taken_reg;
	assign predict_taken = predict_taken_reg;
	reg [6:0] predict_history_reg;
	assign predict_history = predict_history_reg;

	// XOR-based index hashing
	wire [6:0] predict_index;
	assign predict_index = predict_pc ^ GHR;

	wire [6:0] train_index;
	assign train_index = train_pc ^ train_history;

	integer i;
	
	always @(posedge clk or posedge areset) begin
		// Asynchronous reset
		if (areset) begin
			// Initialize GHR and PHT on reset
			GHR <= 7'b0;
			for (i = 0; i < 128; i = i + 1) begin
				PHT[i] <= 2'b01; // Initialize to weakly taken
			end
		end else begin
			// Training logic
			if (train_valid) begin
				// Update PHT counter
				case (PHT[train_index])
					2'b00: PHT[train_index] <= train_taken ? 2'b01 : 2'b00;
					2'b01: PHT[train_index] <= train_taken ? 2'b10 : 2'b00;
					2'b10: PHT[train_index] <= train_taken ? 2'b11 : 2'b01;
					2'b11: PHT[train_index] <= train_taken ? 2'b11 : 2'b10;
				endcase
				
				// Update GHR based on training result
				if (train_mispredicted) begin
					GHR <= {train_history, train_taken};
				end else begin
					GHR <= {GHR[5:0], train_taken};
				end
			end else if (predict_valid) begin
				// Prediction logic
				case (PHT[predict_index])
					2'b00, 2'b01: predict_taken_reg <= 1'b0;
					2'b10, 2'b11: predict_taken_reg <= 1'b1;
				endcase

				// Update GHR for prediction
				GHR <= {GHR[5:0], predict_taken_reg};
				predict_history_reg <= GHR;
			end
		end
	end
endmodule