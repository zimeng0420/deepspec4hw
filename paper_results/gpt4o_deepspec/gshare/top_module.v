module top_module(
	input clk,
	input areset, 

	input predict_valid,
	input [6:0] predict_pc,
	output reg predict_taken, 
	output reg [6:0] predict_history,

	input train_valid,
	input train_taken,
	input train_mispredicted,
	input [6:0] train_history, 
	input [6:0] train_pc
);

// Local Parameters
parameter PHT_SIZE = 128; // Size of Pattern History Table
parameter PHT_ENTRY_WIDTH = 2; // Each entry is a 2-bit saturating counter
parameter HISTORY_BITS = 7; // Global History Register width

// Registers
reg [PHT_ENTRY_WIDTH-1:0] PHT [0:PHT_SIZE-1]; // Pattern History Table
reg [6:0] global_history_register; // 7-bit Global History Register

// Wires & Indices
wire [6:0] predict_index;
wire [6:0] train_index;
wire [1:0] current_pht_value;

// XOR for index calculation
assign predict_index = predict_pc ^ global_history_register;
assign train_index = train_pc ^ train_history;
assign current_pht_value = PHT[predict_index];

// Predict Logic
always @(*) begin
	if (predict_valid) begin
		predict_history = global_history_register;
		// If PHT value is 2'b10 or 2'b11, predict branch as taken
		predict_taken = (current_pht_value[1] == 1);
	end else begin
		predict_taken = 1'b0;
		predict_history = global_history_register; // Default to current GHR
	end
end

// Training and State Update Logic
integer i;
always @(posedge clk or posedge areset) begin
	if (areset) begin
		// Asynchronous Reset
		global_history_register <= 7'b0;
		for (i = 0; i < PHT_SIZE; i = i + 1)
			PHT[i] <= 2'b01; // Reset saturating counters to weak not-taken
	end else begin
		if (train_valid) begin
			// Update the PHT on a training request
			if (train_taken) begin
				// Increment counter for taken branch, saturate at 3
				if (PHT[train_index] != 2'b11)
					PHT[train_index] <= PHT[train_index] + 1;
			end else begin
				// Decrement counter for not-taken branch, saturate at 0
				if (PHT[train_index] != 2'b00)
					PHT[train_index] <= PHT[train_index] - 1;
			end

			// Update or recover global history register
			if (train_mispredicted) begin
				// Recover GHR after mispredicted branch
				global_history_register <= train_history;
			end else begin
				// Update GHR by shifting in actual branch outcome
				global_history_register <= {global_history_register[5:0], train_taken};
			end
		end else if (predict_valid) begin
			// Update GHR on a prediction
			global_history_register <= {global_history_register[5:0], predict_taken};
		end
	end
end

endmodule