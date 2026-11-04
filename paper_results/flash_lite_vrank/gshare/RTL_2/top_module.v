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
	localparam PHT_INDEX_WIDTH = 7;
	localparam PHT_SIZE = 128;
	localparam COUNTER_WIDTH = 2;

	// Internal signals
	reg [HISTORY_WIDTH-1:0] global_history;
	reg [COUNTER_WIDTH-1:0] pht [PHT_SIZE-1:0];
	reg [PHT_INDEX_WIDTH-1:0] predict_index;
	reg [PHT_INDEX_WIDTH-1:0] train_index;
	reg predict_taken_internal;
	reg [HISTORY_WIDTH-1:0] predict_history_internal;
	reg [COUNTER_WIDTH-1:0] pht_read_data;
	
	// Index calculation
	function [PHT_INDEX_WIDTH-1:0] calculate_index;
		input [PC_WIDTH-1:0] pc;
		input [HISTORY_WIDTH-1:0] history;
		begin
			calculate_index = pc ^ history;
		end
	endfunction
	
	// Prediction Logic
	always @(*) begin
		predict_index = calculate_index(predict_pc, global_history);
		pht_read_data = pht[predict_index];
		predict_taken_internal = (pht_read_data[COUNTER_WIDTH-1] == 1) ? 1 : 0;
		predict_history_internal = global_history;
	end

	// Training Logic
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			global_history <= {HISTORY_WIDTH{1'b0}};
			for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
				pht[i] <= 2'b00;
			end
		end else begin
			// Apply training before prediction update in case of conflict
			if (train_valid) begin
				train_index = calculate_index(train_pc, train_history);
				// Update PHT
				if (train_taken) begin
					if (pht[train_index] < ((1 << COUNTER_WIDTH) - 1)) begin
						pht[train_index] <= pht[train_index] + 1'b1;
					end
				end else begin
					if (pht[train_index] > 0) begin
						pht[train_index] <= pht[train_index] - 1'b1;
					end
				end
				// Recover global history if mispredicted
				if (train_mispredicted) begin
					global_history <= train_history;
				end
			end

			// Update global history (after training, so training takes precedence)
			if (predict_valid) begin
				global_history <= {global_history[HISTORY_WIDTH-2:0], predict_taken_internal};
			end
		end
	end

	// Outputs
	assign predict_taken = predict_taken_internal;
	assign predict_history = predict_history_internal;
endmodule