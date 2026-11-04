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

	// Parameters
	localparam HISTORY_WIDTH = 7;
	localparam PC_WIDTH = 7;
	localparam INDEX_WIDTH = 7;
	localparam COUNTER_WIDTH = 2;
	localparam PHT_SIZE = 128;

	// Internal Signals
	reg [HISTORY_WIDTH-1:0] global_history;
	reg [COUNTER_WIDTH-1:0] pht [0:PHT_SIZE-1];
	reg [COUNTER_WIDTH-1:0] pht_read_data;
	reg [INDEX_WIDTH-1:0] predict_index;
	reg [INDEX_WIDTH-1:0] train_index;

	// Prediction Logic
	assign predict_index = predict_pc ^ global_history;
	assign predict_taken = (pht_read_data[COUNTER_WIDTH-1] == 1) ? 1'b1 : 1'b0;
	assign predict_history = global_history;
	
	// PHT Read Logic
	always @(*) begin
		pht_read_data = pht[predict_index];
	end
	

	// History Update Logic (Handles both Prediction and Training)
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			global_history <= {HISTORY_WIDTH{1'b0}};
			for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
				pht[i] <= 2'b00; // Initialize all counters to weakly not taken
			end
		end else begin
			// Training takes precedence
			if (train_valid) begin
				train_index = train_pc ^ train_history;
				
				// Update PHT
				if (train_taken) begin
					if (pht[train_index] < 2'b11) begin
						pht[train_index] <= pht[train_index] + 1'b1;
					end
				end else begin
					if (pht[train_index] > 2'b00) begin
						pht[train_index] <= pht[train_index] - 1'b1;
					end
				end
				
				//History recovery
				if (train_mispredicted) begin
					global_history <= train_history; // Restore history if mispredicted
				end
				else begin
				// Update history based on the trained branch
				global_history <= {global_history[HISTORY_WIDTH-2:0], train_taken}; // Update based on actual outcome
				end
			end
			// Only update global history for prediction if no training happens
			else if (predict_valid) begin
				global_history <= {global_history[HISTORY_WIDTH-2:0], predict_taken};
			end
		end
	end

endmodule