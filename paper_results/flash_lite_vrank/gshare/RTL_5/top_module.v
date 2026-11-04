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
	localparam PHT_SIZE = 128;
	localparam HISTORY_WIDTH = 7;
	localparam PC_WIDTH = 7;
	localparam COUNTER_WIDTH = 2;

	// Internal signals
	reg [COUNTER_WIDTH-1:0] pht [0:PHT_SIZE-1];
	reg [HISTORY_WIDTH-1:0] global_history;
	reg [HISTORY_WIDTH-1:0] next_global_history;
	reg predict_taken_reg;
	reg [HISTORY_WIDTH-1:0] predict_history_reg;
	
	// Functions
	function integer log2;
		input integer size;
		begin
			log2 = 0;
			while (size > 1) begin
				log2 = log2 + 1;
				size = size >> 1;
			end
		end
	endfunction

	// Helper function to calculate the index into the PHT
	function [log2(PHT_SIZE)-1:0] calculate_pht_index;
		input [PC_WIDTH-1:0] pc;
		input [HISTORY_WIDTH-1:0] history;
		begin
			calculate_pht_index = pc ^ history;
		end
	endfunction

	// Prediction logic
	always @(*) begin
		predict_taken_reg = 1'b0;
		predict_history_reg = global_history;
		if (predict_valid) begin
			predict_history_reg = global_history;
			
			// Calculate PHT index
			integer pht_index = calculate_pht_index(predict_pc, global_history);
			
			// Predict based on counter value
			predict_taken_reg = (pht[pht_index][COUNTER_WIDTH-1] == 1) ? 1'b1 : 1'b0;
		end
	end

	// Training and history update logic
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			// Asynchronous reset
			for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
				pht[i] <= 2'b00;
			end
			global_history <= {HISTORY_WIDTH{1'b0}};
			next_global_history <= {HISTORY_WIDTH{1'b0}};
			predict_taken_reg <= 1'b0;
			predict_history_reg <= {HISTORY_WIDTH{1'b0}};
		end else begin
			// Default values
			next_global_history = global_history;

			// Prediction
			predict_taken <= predict_taken_reg;
			predict_history <= predict_history_reg;


			// Training Logic
			if (train_valid) begin
				integer train_index = calculate_pht_index(train_pc, train_history);

				// Update PHT
				if (train_taken && pht[train_index] < 2'b11) begin
					pht[train_index] <= pht[train_index] + 1'b1;
				end else if (!train_taken && pht[train_index] > 2'b00) begin
					pht[train_index] <= pht[train_index] - 1'b1;
				end
				
				// Update history
				next_global_history = {train_history[HISTORY_WIDTH-2:0], train_taken};
				
				// Recover History for Misprediction
				if (train_mispredicted) begin
					next_global_history = train_history;
				end

			end else begin
                //Default
                
                // Update History
                if (predict_valid) begin
                    next_global_history = {global_history[HISTORY_WIDTH-2:0], predict_taken_reg};
                end
            end

			global_history <= next_global_history;
		end
	end

endmodule