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
    reg [1:0] PHT[127:0]; // Pattern History Table with 128 entries of 2-bit saturating counters

    wire [6:0] index;
    wire [1:0] counter_value;
    
    // Calculate index using XOR between PC and GHR
    assign index = predict_pc ^ GHR;
    
    // Get current counter value from PHT
    assign counter_value = PHT[index];

    // Output prediction
    always @(*) begin
        predict_taken = (counter_value[1] || counter_value[0]); // Taken if counter is 10 or 11
    end

    // Update logic on clock edge
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0; // Reset GHR
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b00; // Reset PHT
            end
        end else begin
            if (train_valid) begin
                // Update PHT based on training signal
                if (train_taken) begin
                    if (PHT[index] != 2'b11) begin
                        PHT[index] <= PHT[index] + 1; // Increment counter
                    end
                end else begin
                    if (PHT[index] != 2'b00) begin
                        PHT[index] <= PHT[index] - 1; // Decrement counter
                    end
                end
                
                // Handle misprediction
                if (train_mispredicted) begin
                    GHR <= train_history; // Restore GHR to state prior to misprediction
                end
            end
            
            if (predict_valid) begin
                // Update GHR with predicted outcome
                GHR <= {GHR[5:0], train_taken}; // Shift left and add new outcome
            end
            
            // Update `predict_history` output
            predict_history <= GHR;
        end
    end
endmodule