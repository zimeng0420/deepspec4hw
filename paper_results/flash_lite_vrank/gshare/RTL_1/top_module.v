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
	localparam INDEX_WIDTH = 7;
	localparam COUNTER_WIDTH = 2;
	localparam TABLE_SIZE = 128; // 2^INDEX_WIDTH

	// Signals
	reg [HISTORY_WIDTH-1:0] global_history;
	reg [COUNTER_WIDTH-1:0] pht [0:TABLE_SIZE-1];
	reg [HISTORY_WIDTH-1:0] next_global_history;
	reg [COUNTER_WIDTH-1:0] next_pht [0:TABLE_SIZE-1];

	// Internal Logic Signals
	wire [INDEX_WIDTH-1:0] predict_index;
	wire [INDEX_WIDTH-1:0] train_index;
	wire predict_pht_taken;
	wire train_pht_taken;
    wire update_history;
	wire [HISTORY_WIDTH-1:0] history_next;
	wire [COUNTER_WIDTH-1:0] predict_counter_value;
	wire [COUNTER_WIDTH-1:0] train_counter_value;
    wire pht_write_enable;
	
    // Prediction Index Calculation
	assign predict_index = predict_pc ^ global_history;

	// Training Index Calculation
	assign train_index = train_pc ^ train_history;

	// Predict Taken based on PHT
	assign predict_counter_value = pht[predict_index];
	assign predict_pht_taken = predict_counter_value[COUNTER_WIDTH-1];

	// Train Taken (for writing to the PHT)
	assign train_counter_value = pht[train_index];
	assign train_pht_taken = train_counter_value[COUNTER_WIDTH-1];

	// Predict Output
	assign predict_taken = predict_pht_taken;
	assign predict_history = global_history;

	// History update mux
	assign update_history = predict_valid & train_valid & (predict_index == train_index) ? 0 : (predict_valid | train_valid);

	always @(*) begin
		next_global_history = global_history;
		if (train_valid) begin
			if (train_mispredicted) begin
				next_global_history = train_history;
			end else begin
				next_global_history = {global_history[HISTORY_WIDTH-2:0], train_taken};
			end
		end
		else if (predict_valid) begin
				next_global_history = {global_history[HISTORY_WIDTH-2:0], predict_taken};
		end
		
		
	end

	// PHT update logic
    assign pht_write_enable = train_valid;
	
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			global_history <= {HISTORY_WIDTH{1'b0}};
			for (integer i = 0; i < TABLE_SIZE; i = i + 1) begin
				pht[i] <= 2'b00; // Initialize counters to weakly not taken.
			end
		end else begin
			global_history <= next_global_history;
			if (pht_write_enable) begin
				case (train_counter_value)
					2'b00: next_pht[train_index] <= train_taken ? 2'b01 : 2'b00;
					2'b01: next_pht[train_index] <= train_taken ? 2'b10 : 2'b00;
					2'b10: next_pht[train_index] <= train_taken ? 2'b11 : 2'b01;
					2'b11: next_pht[train_index] <= train_taken ? 2'b11 : 2'b10;
				endcase
			end
			for (integer i = 0; i < TABLE_SIZE; i = i + 1) begin
				if (i == train_index)
					pht[i] <= next_pht[i];
			end
		end
	end

endmodule