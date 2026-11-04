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
    reg [1:0] PHT [0:127]; // Pattern History Table with 128 two-bit counters

    wire [6:0] index;
    wire [1:0] counter_value;

    // Calculate index for PHT using XOR of PC and GHR
    assign index = predict_pc ^ GHR;

    // Read the value from the PHT
    assign counter_value = PHT[index];

    // Prediction logic
    always @* begin
        predict_taken = (counter_value[1] == 1'b1); // Strongly Taken or Weakly Taken
        predict_history = GHR; // Output current GHR state
    end

    // Update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0; // Reset GHR
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b00; // Reset PHT entries
            end
        end else begin
            if (train_valid) begin
                // Update the PHT based on the actual outcome
                if (train_taken) begin
                    if (PHT[train_pc ^ GHR] < 2'b11)
                        PHT[train_pc ^ GHR] <= PHT[train_pc ^ GHR] + 1;
                end else begin
                    if (PHT[train_pc ^ GHR] > 2'b00)
                        PHT[train_pc ^ GHR] <= PHT[train_pc ^ GHR] - 1;
                end
                
                // Recover GHR if misprediction
                if (train_mispredicted) begin
                    GHR <= train_history; // Restore GHR to pre-misprediction state
                end
            end
            
            if (predict_valid) begin
                // Update GHR with the predicted outcome
                GHR <= {predict_taken, GHR[6:1]}; // Shift GHR and insert prediction
            end
        end
    end
endmodule