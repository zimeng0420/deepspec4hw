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

    reg [6:0] GHR; // 7-bit Global History Register
    reg [1:0] PHT[127:0]; // Pattern History Table with 128 entries
    wire [6:0] index; // Index for accessing PHT
    wire [1:0] counter; // Current counter value for prediction
    integer i;

    // Asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b00; // Initialize to strongly not taken
            end
        end
        else begin
            // Training update
            if (train_valid) begin
                index <= train_pc ^ GHR; // Calculate index
                if (train_taken) begin
                    if (PHT[index] < 2'b11)
                        PHT[index] <= PHT[index] + 1; // Increment counter
                end
                else begin
                    if (PHT[index] > 2'b00)
                        PHT[index] <= PHT[index] - 1; // Decrement counter
                end
                // Restore GHR if mispredicted
                if (train_mispredicted) begin
                    GHR <= train_history; // Restore GHR
                end
            end

            // Prediction update
            if (predict_valid) begin
                index <= predict_pc ^ GHR; // Calculate index
                counter <= PHT[index]; // Get current counter value
                predict_taken <= (counter[1] == 1'b1); // Strongly or weakly taken
                predict_history <= GHR; // Provide current GHR state
                
                // Update GHR for prediction
                GHR <= {GHR[6:1], predict_taken}; // Update GHR
            end
        end
    end

endmodule