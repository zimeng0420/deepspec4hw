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
	reg [INDEX_WIDTH-1:0] predict_index;
	reg [INDEX_WIDTH-1:0] train_index;
	reg [COUNTER_WIDTH-1:0] predict_counter;
	reg [HISTORY_WIDTH-1:0] next_history;
	reg [HISTORY_WIDTH-1:0] history_to_write;
	reg write_history;
	reg [COUNTER_WIDTH-1:0] pht_write_data;
	reg [INDEX_WIDTH-1:0] pht_write_index;
	reg pht_write_enable;
	reg [HISTORY_WIDTH-1:0] history_to_recover;
	reg recover_history;

	// Index Calculation
	always @(*) begin
		predict_index = predict_pc ^ global_history;
		train_index = train_pc ^ train_history;
	end

	// Prediction Logic
	always @(*) begin
		predict_counter = pht[predict_index];
		predict_taken = (predict_counter[COUNTER_WIDTH-1] == 1);
		predict_history = global_history;
	end

	// PHT Update Logic
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
				pht[i] <= 2'b00; // Initialize to weakly not taken
			end
			global_history <= {HISTORY_WIDTH{1'b0}};
			write_history <= 1'b0;
			pht_write_enable <= 1'b0;
			recover_history <= 1'b0;
		end else begin
			// History Recovery
			if (recover_history) begin
				global_history <= history_to_recover;
				recover_history <= 1'b0;
			end

			// History Update
			if (write_history) begin
				global_history <= history_to_write;
				write_history <= 1'b0;
			end

			// PHT Write
			if (pht_write_enable) begin
				pht[pht_write_index] <= pht_write_data;
				pht_write_enable <= 1'b0;
			end
		end
	end

	// Next History Calculation
	always @(*) begin
		next_history = {global_history[HISTORY_WIDTH-2:0], predict_taken};
	end

	// Training Logic
	always @(*) begin
		pht_write_enable = 1'b0;
		pht_write_data = pht[train_index];
		pht_write_index = train_index;
		write_history = 1'b0;
		history_to_write = global_history;
		recover_history = 1'b0;
		history_to_recover = global_history;

		if (train_valid) begin
			// PHT Update
			pht_write_enable = 1'b1;
			if (train_taken) begin
				if (pht[train_index] < 3) begin
					pht_write_data = pht[train_index] + 1'b1;
				end else begin
					pht_write_data = pht[train_index];
				end
			end else begin
				if (pht[train_index] > 0) begin
					pht_write_data = pht[train_index] - 1'b1;
				end else begin
					pht_write_data = pht[train_index];
				end
			end

			// History Update
			if (train_mispredicted) begin
				recover_history = 1'b1;
				history_to_recover = train_history;
			end

			// History Update
			write_history = 1'b1;
			history_to_write = {train_history[HISTORY_WIDTH-2:0], train_taken};
		end else if (predict_valid) begin
			write_history = 1'b1;
			history_to_write = next_history;
		end
	end
end