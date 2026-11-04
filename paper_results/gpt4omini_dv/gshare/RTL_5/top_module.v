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
    reg [1:0] PHT [127:0]; // Pattern History Table (128 entries of 2-bit saturating counters)
    wire [6:0] index;
    wire [1:0] counter_value;

    // Index calculation
    assign index = predict_pc ^ GHR;

    // Assign current counter value
    assign counter_value = PHT[index];

    always @(*) begin
        if (predict_valid) begin
            // Determine prediction taken based on counter value
            predict_taken = (counter_value[1] == 1'b1); // 10 or 11 results in taken
            predict_history = GHR; // Output current GHR
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0; // Reset GHR
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b00; // Reset all PHT counters
            end
        end else begin
            // Update GHR on prediction
            if (predict_valid) begin
                GHR <= {GHR[6:1], predict_taken}; // Shift and insert prediction
            end
            
            // Handle Training
            if (train_valid) begin
                // Update PHT based on training outcome
                if (train_taken) begin
                    if (PHT[index] != 2'b11) begin
                        PHT[index] <= PHT[index] + 1; // Increment the counter
                    end
                end else begin
                    if (PHT[index] != 2'b00) begin
                        PHT[index] <= PHT[index] - 1; // Decrement the counter
                    end
                end
                
                // Handle misprediction recovery
                if (train_mispredicted) begin
                    GHR <= train_history; // Recover GHR
                end
            end
        end
    end

endmodule