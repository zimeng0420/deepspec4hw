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
	localparam PHT_INDEX_WIDTH = 7;
	localparam COUNTER_WIDTH = 2;
	localparam PHT_SIZE = 128; // 2^PHT_INDEX_WIDTH

	// Internal Signals
	reg [HISTORY_WIDTH-1:0] global_history;
	reg [COUNTER_WIDTH-1:0] pht [0:PHT_SIZE-1];
	reg [HISTORY_WIDTH-1:0] next_global_history;
	reg [COUNTER_WIDTH-1:0] next_pht [0:PHT_SIZE-1];
	reg [PHT_INDEX_WIDTH-1:0] predict_index;
	reg [PHT_INDEX_WIDTH-1:0] train_index;
	reg [COUNTER_WIDTH-1:0] predict_counter;
    
	// Functions
	function [PHT_INDEX_WIDTH-1:0] calculate_index;
		input [6:0] pc;
		input [6:0] history;
		begin
			calculate_index = pc ^ history;
		end
	endfunction

	// Prediction Logic
	always @(*) begin
		if (predict_valid) begin
			predict_index = calculate_index(predict_pc, global_history);
			predict_counter = pht[predict_index];
		end else begin
            predict_counter = {COUNTER_WIDTH{1'b0}}; // Default to strongly not taken if no prediction
			predict_index = {PHT_INDEX_WIDTH{1'b0}};
		end
	end

	assign predict_taken = (predict_counter[COUNTER_WIDTH-1] == 1'b1) ? 1'b1 : 1'b0;
	assign predict_history = global_history;

	// Training Logic
	always @(*) begin
		// Default values
		next_global_history = global_history;
		for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
			next_pht[i] = pht[i];
		end

		if (train_valid) begin
			train_index = calculate_index(train_pc, train_history);

			// Update PHT
			case (pht[train_index])
				2'b00: next_pht[train_index] = train_taken ? 2'b01 : 2'b00; // Strongly Not Taken
				2'b01: next_pht[train_index] = train_taken ? 2'b10 : 2'b00; // Weakly Not Taken
				2'b10: next_pht[train_index] = train_taken ? 2'b11 : 2'b01; // Weakly Taken
				2'b11: next_pht[train_index] = train_taken ? 2'b11 : 2'b10; // Strongly Taken
			endcase

			// Update global history
			next_global_history = {global_history[HISTORY_WIDTH-2:0], train_taken};

			// Misprediction Recovery
			if (train_mispredicted) begin
				next_global_history = train_history;
			end
		end
		else if (predict_valid) {
			// Update global history based on prediction (if no training happens)
			next_global_history = {global_history[HISTORY_WIDTH-2:0], predict_taken};
		}
	end

	// Sequential Logic
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			global_history <= {HISTORY_WIDTH{1'b0}};
			for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
				pht[i] <= 2'b00; // Initialize to Strongly Not Taken
			end
		end else begin
			global_history <= next_global_history;
			for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
				pht[i] <= next_pht[i];
			end
		end
	end

endmodule