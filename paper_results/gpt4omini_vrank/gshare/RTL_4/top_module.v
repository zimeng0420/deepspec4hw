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

    reg [1:0] PHT [127:0]; // Pattern History Table
    reg [6:0] GHR; // Global History Register

    wire [6:0] index;
    wire [1:0] PHT_entry;
    wire taken_prediction;

    // Calculate index using XOR of pc and global history
    assign index = predict_pc ^ GHR;

    // Outputs the current PHT entry and its prediction
    assign PHT_entry = PHT[index];
    assign predict_taken = (PHT_entry[1] == 1'b1); // Predict taken if counter is 2 or 3
    assign predict_history = GHR;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset PHT and GHR
            for (integer i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b00; // Weakly not taken
            end
            GHR <= 7'b0000000;
        end else begin
            // Train phase logic
            if (train_valid) begin
                // Update the PHT entry
                if (train_mispredicted) begin
                    // Recover GHR if there was a misprediction
                    GHR <= train_history;
                end

                // Update PHT based on actual outcome
                if (train_taken) begin
                    if (PHT[train_pc ^ GHR] < 2'b11) // Increment
                        PHT[train_pc ^ GHR] <= PHT[train_pc ^ GHR] + 1;
                end else begin
                    if (PHT[train_pc ^ GHR] > 2'b00) // Decrement
                        PHT[train_pc ^ GHR] <= PHT[train_pc ^ GHR] - 1;
                end
            end

            // Prediction phase logic
            if (predict_valid) begin
                // Update GHR for predicted taken
                GHR <= {GHR[5:0], predict_taken}; // Shift and add the prediction
            end
        end
    end
endmodule