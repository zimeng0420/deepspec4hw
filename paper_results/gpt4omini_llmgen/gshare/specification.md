```verilog
module top_module (
    input clk,                       // Clock signal
    input areset,                    // Asynchronous active-high reset 

    // Prediction Interface
    input predict_valid,             // Valid signal for prediction request
    input [6:0] predict_pc,          // 7-bit Program Counter for prediction
    output predict_taken,            // Output for predicted branch direction (taken/not taken)
    output reg [6:0] predict_history, // Output for the history register value used for prediction

    // Training Interface
    input train_valid,               // Valid signal for training request
    input train_taken,               // Actual branch outcome for training
    input train_mispredicted,        // Flag indicating if there was a misprediction
    input [6:0] train_history,        // Branch history value used for training
    input [6:0] train_pc              // 7-bit Program Counter for training
);

    // Constants and parameters
    localparam PHT_SIZE = 128;       // Pattern History Table size
    localparam COUNTER_WIDTH = 2;    // Size of saturating counter bits

    reg [COUNTER_WIDTH-1:0] pht[PHT_SIZE-1:0]; // Pattern History Table
    reg [6:0] ghistory;             // Global History register (7-bits)
    wire [6:0] hashed_index;        // Hashed index for PHT access

    // Hashing Logic: XOR PC and Global History
    assign hashed_index = (predict_pc ^ ghistory) [6:0]; // Hashing using XOR

    // Prediction logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghistory <= 7'b0; // Reset the global history register
            // Reset the pattern history table
            integer i;
            for (i = 0; i < PHT_SIZE; i = i + 1) 
                pht[i] <= 2'b00; // Initialize all counters to '00'
        end else begin
            // Prediction at the edge of the clock
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
```
### Specifications:
1. **Inputs/Outputs**:
    - `clk`: System clock.
    - `areset`: Asynchronous reset for initializing the predictor.
    - `predict_valid`: Indicates a valid prediction request.
    - `predict_pc`: 7-bit Program Counter for prediction.
    - `predict_taken`: Output for predicted branch direction.
    - `predict_history`: Output for current state of the global history register.
    - `train_valid`: Indicates a valid training request.
    - `train_taken`: Outcome of the training branch.
    - `train_mispredicted`: Flag for mispredicted training branches.
    - `train_history`: History value to recover for mispredicted branches.
    - `train_pc`: PC for the branch being trained.

2. **Branch Predictor Data Structure**:
    - Pattern History Table (PHT) of size 128 with 2-bit saturating counters for each entry.

3. **History Register**:
    - Global History Register: 7 bits to track recent branch outcomes.

4. **Operation Logic**:
    - XOR operation used to hash `predict_pc` and `ghistory` into a 7-bit index.
    - Saturating counter logic for updating predictions based on training outcomes.

5. **Reset Logic**: 
    - Global history and PHT get initialized on `areset`.

6. **Training vs. Prediction**:
   - Training takes precedence over prediction when they occur simultaneously.
   - Predictions use the pre-trained PHT state before any training updates in the same cycle.

7. **Timing Behavior**:
   - PHT updates happen at the next positive clock edge after handling training requests. 

This structure adheres to optimal module design principles for a gshare branch predictor with critical feedback mechanisms for learning from previous predictions.
