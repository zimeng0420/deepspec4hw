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

    reg [6:0] GHR; // Global History Register
    reg [1:0] PHT[127:0]; // Pattern History Table with 128 entries (2-bit saturating counters)
    wire [6:0] index; // XOR index for accessing PHT
    wire [1:0] counter_state; // Current state of the counter from PHT

    assign index = predict_pc ^ GHR; // Index for PHT using XOR
    assign counter_state = PHT[index]; // Current counter state from PHT

    always @(*) begin
        // Prediction logic: derive predict_taken from the current state of the counter
        predict_taken = (counter_state[1] | counter_state[0]) && !train_valid; // Taken if counter is 10 or 11
        predict_history = GHR; // Output for the branch history register
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0; // Reset GHR
            // Reset PHT - optional based on requirements
            integer i;
            for (i = 0; i < 128; i = i + 1) PHT[i] <= 2'b00; // Initialize to strongly not taken
        end else begin
            // Training logic: update PHT on train_valid
            if (train_valid) begin
                if (train_taken) begin
                    if (PHT[train_pc ^ GHR] < 2'b11) PHT[train_pc ^ GHR] <= PHT[train_pc ^ GHR] + 1; // Increment counter
                end else begin
                    if (PHT[train_pc ^ GHR] > 2'b00) PHT[train_pc ^ GHR] <= PHT[train_pc ^ GHR] - 1; // Decrement counter
                end
                
                // Handle misprediction
                if (train_mispredicted) begin
                    GHR <= train_history; // Recover GHR to state before misprediction
                end else begin
                    GHR <= {GHR[6:1], train_taken}; // Update GHR with new outcome
                end
            end else if (predict_valid) begin
                // If valid prediction, update GHR on next posedge
                GHR <= {GHR[6:1], counter_state[1]}; // Shift GHR and add predicted outcome
            end
        end
    end

endmodule