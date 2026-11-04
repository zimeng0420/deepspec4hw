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

reg [1:0] PHT [127:0]; // Pattern History Table
reg [6:0] GHR; // Global History Register
wire [6:0] index; // Hashed index
wire [1:0] pht_entry; // PHT entry

// Compute index from PC and GHR using XOR
assign index = predict_pc ^ GHR;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        GHR <= 7'b0;
        // Initialize PHT to weakly taken
        integer i;
        for (i = 0; i < 128; i = i + 1) begin
            PHT[i] <= 2'b01; // Weakly taken
        end
    end else begin
        // Prediction logic
        if (predict_valid) begin
            predict_history <= GHR;
            predict_taken <= (PHT[index] >> 1); // Predict taken if counter is 2 or 3
        end
        
        // Update logic for the global history register
        if (train_valid) begin
            if (train_mispredicted) begin
                GHR <= train_history; // Recover GHR on misprediction
            end else begin
                GHR <= {GHR[5:0], train_taken}; // Update GHR
            end
            
            // Train the PHT
            if (train_taken) begin
                if (PHT[index] < 2'b11) PHT[index] <= PHT[index] + 1; // Increment if taken
            end else begin
                if (PHT[index] > 2'b00) PHT[index] <= PHT[index] - 1; // Decrement if not taken
            end
        end else if (predict_valid) begin
            // Predicting does not change the GHR immediately
            GHR <= {GHR[5:0], predict_taken}; // Update GHR for the predicted branch
        end
    end
end

endmodule