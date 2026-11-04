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
	localparam PHT_SIZE = 128; // 2^7

	// Internal Signals
	reg [HISTORY_WIDTH-1:0] global_history;
	reg [COUNTER_WIDTH-1:0] pht [0:PHT_SIZE-1];
	reg [COUNTER_WIDTH-1:0] pht_read_data;
	reg [INDEX_WIDTH-1:0] predict_index;
	reg [INDEX_WIDTH-1:0] train_index;
	reg [HISTORY_WIDTH-1:0] history_next;
	reg [HISTORY_WIDTH-1:0] history_read;
	reg history_update_en;
	reg [COUNTER_WIDTH-1:0] pht_write_data;
	reg pht_write_en;
	reg [INDEX_WIDTH-1:0] pht_write_index;
	reg mispredict_history_restore;

	// Index Calculation (XOR of PC and global history)
	always @(*) begin
		predict_index = predict_pc ^ global_history;
		train_index = train_pc ^ train_history;
	end

	// PHT Read Logic
	always @(*) begin
		pht_read_data = pht[predict_index];
		history_read = global_history;
	end

	// Prediction Logic
	always @(*) begin
		predict_taken = (pht_read_data[COUNTER_WIDTH-1] == 1);
		predict_history = history_read;
	end


	// History Update Logic (Next State)
	always @(*) begin
		history_next = global_history;
		history_update_en = 0;
		if (train_valid) begin
			history_next = {train_history[HISTORY_WIDTH-2:0], train_taken};

			if(train_mispredicted) begin
				history_update_en = 1;
			end
			
		end else if (predict_valid) begin
				history_next = {global_history[HISTORY_WIDTH-2:0], predict_taken};
				history_update_en = 1;
		end
	end


	// Global History Register Update
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			global_history <= {HISTORY_WIDTH{1'b0}};
		end else if (history_update_en) begin
			global_history <= history_next;
		end
	end


	// PHT Write Logic
	always @(*) begin
		pht_write_en = 0;
		pht_write_data = pht[train_index];
		pht_write_index = train_index;
		mispredict_history_restore = 0;

		if (train_valid) begin
			pht_write_en = 1;
			
			//Saturating counter update
			if(train_taken) begin
				if(pht[train_index] < {(COUNTER_WIDTH-1){1'b1}, 1'b1})
					pht_write_data = pht[train_index] + 1;
			end else begin
				if(pht[train_index] > 0)
					pht_write_data = pht[train_index] - 1;
			end
		end

		if (train_mispredicted) begin
			mispredict_history_restore = 1;
		end
	end

	// PHT Update
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
				pht[i] <= 2'b00;
			end
		end else if (pht_write_en) begin
			pht[pht_write_index] <= pht_write_data;
		end
	end
end