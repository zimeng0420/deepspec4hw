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

    reg [1:0] PHT [127:0]; // Pattern History Table, 128 entries of 2-bit saturating counters
    reg [6:0] GHR;         // Global History Register
    wire [6:0] index;      // Index for the PHT

    // Hashing the PC and GHR to get the index
    assign index = (predict_pc ^ GHR) [6:0];

    // Predict the direction based on PHT and update history register
    always @(*) begin
        if (predict_valid) begin
            predict_taken = (PHT[index] >= 2'b10); // Taken if counter >= 2
            predict_history = GHR; // Output the current state of the GHR
        end
    end
    
    // Update logic for PHT and GHR on the positive edge of the clock
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0; // Reset GHR on asynchronous reset
            // Resetting PHT
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b0; // Resetting the PHT entries
            end
        end else begin
            // Training logic
            if (train_valid) begin
                // Update PHT based on training input
                if (train_taken && (PHT[index] < 2'b11))
                    PHT[index] <= PHT[index] + 1; // Increment counter
                else if (!train_taken && (PHT[index] > 2'b00))
                    PHT[index] <= PHT[index] - 1; // Decrement counter
                
                // Recovery of GHR on misprediction
                if (train_mispredicted) begin
                    GHR <= train_history; // Recover GHR to the state immediately after the mispredict
                end else begin
                    GHR <= {GHR[5:0], train_taken}; // Update GHR
                end
            end else if (predict_valid) begin
                // Update GHR for the predicted branch
                GHR <= {GHR[5:0], predict_taken};
            end
        end
    end

endmodule