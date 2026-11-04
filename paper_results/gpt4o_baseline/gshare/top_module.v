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

	// Parameters
	localparam TABLE_SIZE = 128;

	// Branch history register
	reg [6:0] global_history;

	// Pattern history table of 2-bit saturating counters
	reg [1:0] PHT[TABLE_SIZE-1:0];

	wire [6:0] predict_index;
	wire [6:0] train_index;

	// XOR operation for indexing
	assign predict_index = predict_pc ^ global_history;
	assign train_index = train_pc ^ train_history;

	// Predict logic
	always @(*) begin
		if (predict_valid) begin
			predict_taken = (PHT[predict_index] >= 2'b10); // Predict taken if counter >= 2
			predict_history = global_history;
		end else begin
			predict_taken = 0;
			predict_history = 0;
		end
	end

	// Training logic
	integer i;
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			// Reset the system
			global_history <= 7'b0;
			for (i = 0; i < TABLE_SIZE; i = i + 1) begin
				PHT[i] <= 2'b01; // Reset to weakly not taken
			end
		end else begin
			if (train_valid) begin
				// Update the PHT for the training branch
				if (train_taken) begin
					if (PHT[train_index] < 2'b11) begin
						PHT[train_index] <= PHT[train_index] + 1; // Move towards strongly taken
					end
				end else begin
					if (PHT[train_index] > 2'b00) begin
						PHT[train_index] <= PHT[train_index] - 1; // Move towards strongly not taken
					end
				end

				// Update or recover global history register if mispredicted
				if (train_mispredicted) begin
					global_history <= {train_history[5:0], train_taken}; // Recover history
				end else begin
					global_history <= {global_history[5:0], train_taken}; // Update history on correct prediction
				end
			end else if (predict_valid) begin
				// Update history for the predicted branch
				global_history <= {global_history[5:0], predict_taken};
			end
		end
	end

endmodule