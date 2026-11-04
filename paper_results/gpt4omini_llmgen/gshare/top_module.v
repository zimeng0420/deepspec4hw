module top_module (
    input clk,                       // Clock signal
    input areset,                    // Asynchronous active-high reset 

    // Prediction Interface
    input predict_valid,             // Valid signal for prediction request
    input [6:0] predict_pc,          // 7-bit Program Counter for prediction
    output reg predict_taken,         // Output for predicted branch direction (taken/not taken)
    output reg [6:0] predict_history, // Output for the history register value used for prediction

    // Training Interface
    input train_valid,               // Valid signal for training request
    input train_taken,               // Actual branch outcome for training
    input train_mispredicted,        // Flag indicating if there was a misprediction
    input [6:0] train_history,       // Branch history value used for training
    input [6:0] train_pc             // 7-bit Program Counter for training
);

    // Constants and parameters
    localparam PHT_SIZE = 128;       // Pattern History Table size
    localparam COUNTER_WIDTH = 2;    // Size of saturating counter bits

    reg [COUNTER_WIDTH-1:0] pht[PHT_SIZE-1:0]; // Pattern History Table
    reg [6:0] ghistory;             // Global History register (7-bits)
    wire [6:0] hashed_index;        // Hashed index for PHT access

    // Hashing Logic: XOR PC and Global History
    assign hashed_index = (predict_pc ^ ghistory) [6:0]; // Hashing using XOR

    // Prediction and Training logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghistory <= 7'b0; // Reset the global history register
            // Reset the pattern history table
            integer i;
            for (i = 0; i < PHT_SIZE; i = i + 1) 
                pht[i] <= 2'b00; // Initialize all counters to '00'
        end else begin
            // Prediction logic
            if (predict_valid) begin
                predict_taken <= (pht[hashed_index] > 2'b01); // Predict taken if counter is 02 or higher
                predict_history <= ghistory; // Output current global history
            end
            
            // Training logic occurs at the next positive clock edge after the prediction
            if (train_valid) begin
                // Update the PHT based on actual outcome
                if (train_mispredicted) begin
                    // Recover ghistory to the state after the mispredicted branch
                    ghistory <= train_history; 
                end
                
                // Update PHT entry based on actual outcome
                if (train_taken) begin
                    if (pht[hashed_index] < 2'b11) 
                        pht[hashed_index] <= pht[hashed_index] + 1; // Increment counter
                end else begin
                    if (pht[hashed_index] > 2'b00)
                        pht[hashed_index] <= pht[hashed_index] - 1; // Decrement counter
                end

                // Update global history register
                ghistory <= {ghistory[5:0], train_taken}; // Shift left and add new outcome
            end
        end
    end
endmodule