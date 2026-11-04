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
    reg [1:0] PHT [127:0]; // 128-entry Pattern History Table with 2-bit saturating counters
    reg [6:0] GHR; // 7-bit Global History Register

    wire [6:0] index; // index for PHT
    wire [1:0] counter_value; // current counter value for prediction
    wire [1:0] updated_counter; // updated counter value for training

    // Calculate index using XOR between PC and GHR
    assign index = (predict_pc ^ GHR) [6:0];
    assign counter_value = PHT[index];

    // Predict based on counter value
    always @(*) begin
        if (predict_valid) begin
            case (counter_value)
                2'b00: predict_taken = 0; // Strongly Not Taken
                2'b01: predict_taken = 0; // Weakly Not Taken
                2'b10: predict_taken = 1; // Weakly Taken
                2'b11: predict_taken = 1; // Strongly Taken
            endcase
            predict_history = GHR;
        end
    end

    // Update GHR and PHT on clock edge
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            PHT[0] <= 2'b00; // Initialize all PHT entries
            // Initialize remaining entries in similar way
        end else begin
            if (train_valid) begin
                // Training logic
                if (train_mispredicted) begin
                    GHR <= train_history; // Recover GHR
                end else begin
                    GHR <= {GHR[5:0], train_taken}; // Shift in the new prediction
                end
                
                // Update PHT
                if (train_taken) begin
                    if (PHT[train_pc ^ GHR][1]) begin
                        PHT[train_pc ^ GHR] <= 2'b11; // Saturate to Strongly Taken
                    end else begin
                        PHT[train_pc ^ GHR] <= PHT[train_pc ^ GHR] + 1; // Increment
                    end
                end else begin
                    if (~PHT[train_pc ^ GHR][0]) begin
                        PHT[train_pc ^ GHR] <= 2'b00; // Saturate to Strongly Not Taken
                    end else begin
                        PHT[train_pc ^ GHR] <= PHT[train_pc ^ GHR] - 1; // Decrement
                    end
                end
            end

            // Update GHR for prediction if not in training
            if (predict_valid) begin
                GHR <= {GHR[5:0], predict_taken}; // Shift in the new prediction
            end
        end
    end
endmodule