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
	localparam HISTORY_LEN = 7;
	localparam PHT_SIZE = 128;
	localparam COUNTER_WIDTH = 2;

	// Signals
	reg [HISTORY_LEN-1:0] global_history;
	reg [COUNTER_WIDTH-1:0] pht [0:PHT_SIZE-1];
	reg [HISTORY_LEN-1:0] predict_history_reg;
	reg predict_taken_reg;

	// Internal wires
	wire [6:0] pht_index_predict;
	wire [6:0] pht_index_train;
	wire [COUNTER_WIDTH-1:0] pht_read_data;
	wire [COUNTER_WIDTH-1:0] pht_write_data;
	wire update_global_history;
    wire update_global_history_value;
    wire mispredict_train_history_enable;

	// Calculate PHT index for prediction
	assign pht_index_predict = predict_pc ^ global_history;

	// Calculate PHT index for training
	assign pht_index_train = train_pc ^ train_history;

	// Read PHT entry
	assign pht_read_data = pht[predict_valid ? pht_index_predict : 0];  // Read the entry for prediction, or dummy read when predict_valid is low.

	// Determine prediction based on PHT counter
	always @(*) begin
		case (pht_read_data)
			2'b00, 2'b01: predict_taken_reg = 1'b0;
			2'b10, 2'b11: predict_taken_reg = 1'b1;
			default: predict_taken_reg = 1'b0; // Should not happen, but default to not taken
		endcase
	end

    // Prepare prediction history
	always @(*) begin
		predict_history_reg = global_history;
	end

	// Update global history (prediction stage)
    always @(posedge clk or posedge areset) begin
		if (areset) begin
			global_history <= {HISTORY_LEN{1'b0}};
		end else begin
			if (update_global_history) begin
				global_history <= {global_history[HISTORY_LEN-2:0], update_global_history_value};
			end
		end
	end

	// Update PHT (training stage)
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
				pht[i] <= 2'b00;
			end
		end else begin
            if (train_valid) begin
			    case (pht[pht_index_train])
					2'b00: pht[pht_index_train] <= train_taken ? 2'b01 : 2'b00;
					2'b01: pht[pht_index_train] <= train_taken ? 2'b10 : 2'b00;
					2'b10: pht[pht_index_train] <= train_taken ? 2'b11 : 2'b01;
					2'b11: pht[pht_index_train] <= train_taken ? 2'b11 : 2'b10;
					default: pht[pht_index_train] <= train_taken ? 2'b01 : 2'b00;
				endcase
            end
        end
	end

    // Restore history when misprediction happens.
    assign mispredict_train_history_enable = train_valid && train_mispredicted;
    
	// Update global history based on the prediction
    assign update_global_history = predict_valid || (train_valid && !mispredict_train_history_enable);
	assign update_global_history_value = predict_valid ? predict_taken_reg : (train_valid && !mispredict_train_history_enable ? train_taken : 1'b0);

	// Outputs
	assign predict_taken = predict_taken_reg;
	assign predict_history = predict_history_reg;
endmodule