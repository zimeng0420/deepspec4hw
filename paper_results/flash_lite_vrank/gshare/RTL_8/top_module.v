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
	localparam HISTORY_BITS = 7;
	localparam PC_BITS = 7;
	localparam COUNTER_BITS = 2;

	// Internal Signals
	reg [COUNTER_BITS-1:0] pht [0:PHT_SIZE-1]; // Pattern History Table
	reg [HISTORY_BITS-1:0] global_history;
	reg [HISTORY_BITS-1:0] next_global_history;
	reg [HISTORY_BITS-1:0] predict_history_reg;
	reg predict_taken_reg;

	// Helper functions
	function [6:0] hash_pc_history;
		input [6:0] pc;
		input [6:0] history;
		begin
			hash_pc_history = pc ^ history;
		end
	endfunction

	// Prediction Logic
	always @(*) begin
		predict_history_reg = global_history;
		predict_taken_reg = (pht[hash_pc_history(predict_pc, global_history)] > 1);
		
		if (predict_valid) begin
			predict_history_reg = global_history;
			predict_taken_reg = (pht[hash_pc_history(predict_pc, global_history)] > 1);
		end else begin
			predict_history_reg = global_history;
			predict_taken_reg = 1'b0;
		end
	end
	
	// Training Logic
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
				pht[i] <= 2'b00;
			end
			global_history <= {HISTORY_BITS{1'b0}};
		end else begin
			//Update PHT
			if (train_valid) begin
				integer index = hash_pc_history(train_pc, train_history);

				if (train_taken && (pht[index] < {COUNTER_BITS{1'b1}})) begin
					pht[index] <= pht[index] + 1;
				end
				else if (!train_taken && (pht[index] > {COUNTER_BITS{1'b0}})) begin
					pht[index] <= pht[index] - 1;
				end
			end
			
			//Update global history. Training takes precedence
			next_global_history = global_history;

			if (train_valid) begin
				next_global_history = {next_global_history[HISTORY_BITS-2:0], train_taken};
			end
			else begin
				next_global_history = {global_history[HISTORY_BITS-2:0], predict_taken_reg};
			end

			if (train_valid && train_mispredicted) begin
				global_history <= train_history; // recover the history
			end
			else begin
				global_history <= next_global_history;
			end
		end
	end

	// Outputs
	assign predict_taken = predict_taken_reg;
	assign predict_history = predict_history_reg;

endmodule