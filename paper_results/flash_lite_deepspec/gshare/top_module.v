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

	// Internal Signals
	reg [6:0] ghr;
	reg [1:0] pht [0:127];
	reg [6:0] pht_index;
	reg [1:0] pht_read_data;
	wire [6:0] predict_index;
	wire [1:0] pht_write_data;
	wire ghr_update_enable;
	wire [6:0] ghr_next;
	wire pht_update_enable;
	wire [6:0] train_index;
	wire [1:0] pht_entry_before_training;

	// Index Calculation
	assign predict_index = predict_pc ^ ghr;
	assign train_index = train_pc ^ train_history;

	// PHT Read
	always @(*) begin
		if (predict_valid) begin
			pht_read_data = pht[predict_index];
		end else begin
			pht_read_data = 2'b00; // Default value if no prediction
		end
	end

	// Prediction Generation
	assign predict_taken = pht_read_data[1];
	assign predict_history = ghr;

	// Saturating Counter Logic
	always @(*) begin
		if (train_valid) begin
			if (train_taken) begin
				if (pht[train_index] < 2'b11) begin
					pht_write_data = pht[train_index] + 1'b1;
				end else begin
					pht_write_data = pht[train_index];
				end
			end else begin
				if (pht[train_index] > 2'b00) begin
					pht_write_data = pht[train_index] - 1'b1;
				end else begin
					pht_write_data = pht[train_index];
				end
			end
		end else begin
			pht_write_data = pht[train_index]; // No change if no training
		end
	end

	// GHR Update Logic
	assign ghr_update_enable = train_valid || predict_valid;
	assign ghr_next = train_valid ? (train_mispredicted ? train_history : {ghr[5:0], train_taken}) : {ghr[5:0], predict_taken};

	// PHT Update Enable
	assign pht_update_enable = train_valid;

	// Sequential Logic
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			ghr <= 7'b0;
			for (integer i = 0; i < 128; i = i + 1) begin
				pht[i] <= 2'b00;
			end
		end else begin
			if (ghr_update_enable) begin
				ghr <= ghr_next;
			end
			if (pht_update_enable) begin
				pht[train_index] <= pht_write_data;
			end
		end
	end

endmodule