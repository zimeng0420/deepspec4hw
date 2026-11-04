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
	localparam PHT_ENTRIES = 128;
	localparam COUNTER_WIDTH = 2;
	localparam HISTORY_WIDTH = 7;
	localparam PC_WIDTH = 7;
	localparam INDEX_WIDTH = 7;

	// Internal Signals
	reg [COUNTER_WIDTH-1:0] pht [0:PHT_ENTRIES-1];
	reg [HISTORY_WIDTH-1:0] global_history;
	reg [HISTORY_WIDTH-1:0] next_global_history;
	reg [INDEX_WIDTH-1:0] predict_index;
	reg [INDEX_WIDTH-1:0] train_index;
	reg [COUNTER_WIDTH-1:0] predict_counter_value;
	reg [HISTORY_WIDTH-1:0] history_after_train;


	// Helper Functions
	function [INDEX_WIDTH-1:0] calculate_index;
		input [PC_WIDTH-1:0] pc;
		input [HISTORY_WIDTH-1:0] history;
		begin
			calculate_index = pc ^ history;
		end
	endfunction


	// Prediction Logic
	always @(*) begin
		predict_index = calculate_index(predict_pc, global_history);
		predict_counter_value = pht[predict_index];
		predict_taken = (predict_counter_value[COUNTER_WIDTH-1] == 1) ? 1 : 0;
		predict_history = global_history;
	end

	// Training Logic
	always @(*) begin
		history_after_train = global_history;

		if (train_valid) begin
			train_index = calculate_index(train_pc, train_history);

			//If mispredicted, recover global history
			if(train_mispredicted) begin
				history_after_train = train_history;
			end

		end
		
		// Update global history for next cycle, considering training.  Training takes precedence.
		next_global_history = {global_history[HISTORY_WIDTH-2:0], (train_valid ? train_taken : predict_taken)};
	end

	// PHT Update
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			for (integer i = 0; i < PHT_ENTRIES; i = i + 1) begin
				pht[i] <= 2'b00;
			end
			global_history <= {HISTORY_WIDTH{1'b0}};
		end else begin
			if (train_valid) begin
				// Update PHT
				case (pht[train_index])
					2'b00: pht[train_index] <= (train_taken ? 2'b01 : 2'b00);
					2'b01: pht[train_index] <= (train_taken ? 2'b10 : 2'b00);
					2'b10: pht[train_index] <= (train_taken ? 2'b11 : 2'b01);
					2'b11: pht[train_index] <= (train_taken ? 2'b11 : 2'b10);
					default: pht[train_index] <= pht[train_index];
				endcase
			end

			global_history <= history_after_train;
			
			if(!train_valid) begin //If no training, update global history with the current prediction's taken direction.
				
			end
			
		end
	end

endmodule