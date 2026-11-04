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

    // Internal Signals and Registers
    reg [6:0] ghr; // Global History Register
    reg [1:0] pht [0:127]; // Pattern History Table
    wire [6:0] index;
    wire [1:0] pht_entry;
    reg [1:0] pht_entry_next;
    reg [6:0] ghr_next;

    // Index Calculation
    assign index = predict_pc ^ ghr;

    // Prediction Logic
    always @(*) begin
        predict_history = ghr;
        pht_entry = pht[index];
        predict_taken = (pht_entry[1] == 1); // Taken if MSB is 1
    end

    // PHT Update Logic
    always @(*) begin
        pht_entry_next = pht[index]; // Default: Keep current value
        ghr_next = ghr; // Default: Keep current value

        if (train_valid) begin
            // Determine the index for training
            wire [6:0] train_index = train_pc ^ train_history;

            // PHT Update
            if (train_index == index) begin // Training targets the same entry
                if (train_taken) begin
                    if (pht[index] < 2'b11)
                        pht_entry_next = pht[index] + 1;
                end else begin
                    if (pht[index] > 2'b00)
                        pht_entry_next = pht[index] - 1;
                end
            end
            // GHR Update (if not a misprediction, update the GHR with the outcome)
            if (!train_mispredicted) begin
                ghr_next = {ghr[5:0], train_taken};
            end else begin
                ghr_next = train_history; // Restore GHR to the state before the misprediction
            end
        end else if (predict_valid) begin
            // GHR Update (if no training, update the GHR with the prediction)
            ghr_next = {ghr[5:0], predict_taken};
        end
    end

    // Sequential Logic (Clocked Updates)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b00; // Initialize PHT to Strongly Not Taken
            end
        end else begin
            ghr <= ghr_next;
            if (train_valid) begin
                // Determine the index for training
                wire [6:0] train_index = train_pc ^ train_history;
                if (train_index == index) begin
                    pht[index] <= pht_entry_next;
                end
            end
        end
    end

endmodule