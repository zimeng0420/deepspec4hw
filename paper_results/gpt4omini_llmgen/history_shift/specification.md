```verilog
module top_module
(
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    output logic [31:0] predict_history,
    
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history
);

    logic [31:0] history; // Shift register to hold the branch history

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0; // Reset the history to zero
        end else if (train_mispredicted) begin
            // Load new history on mispredicted branch
            history <= {train_history[30:0], train_taken}; // Shift and load new value
        end else if (predict_valid) begin
            // Shift in the new value if prediction is valid
            history <= {history[30:0], predict_taken}; // Shift in predicted direction
        end 
    end

    assign predict_history = history; // Output the current history state
 
endmodule
``` 

### Technical Specifications:
1. **Inputs**:
   - `clk`: Clock signal for synchronizing operations.
   - `areset`: Asynchronous reset signal (active high) to clear the shift register.
   - `predict_valid`: Indicates if the branch prediction is valid (active high).
   - `predict_taken`: Direction of the predicted branch (1 for taken, 0 for not taken).
   - `train_mispredicted`: Indicates if a branch misprediction has occurred (active high).
   - `train_taken`: Actual direction of the mispredicted branch (1 for taken, 0 for not taken).
   - `train_history`: 32-bit history of branches prior to the misprediction.

2. **Outputs**:
   - `predict_history`: The current state of the 32-bit branch history register.

3. **Functionality**:
   - On the rising edge of `clk`, if `areset` is high, the history register `history` is cleared to zero.
   - If `train_mispredicted` is active, load the `train_taken` value into the history register after shifting out the oldest history (MSB is discarded).
   - If `predict_valid` is active and no misprediction occurred, shift in the `predict_taken` value into the history.
   - The priority is given to `train_mispredicted` when both predictions and mispredictions occur simultaneously.

4. **Behavior**:
   - Implements a 32-bit shift register capable of recording branch history with the ability to roll back state on branch mispredictions.
   - Facilitates the analysis of branch prediction accuracy in hardware architectures using an efficient and synchronized approach.

5. **Synthesis Properties**:
   - The module is suitable for FPGA/ASIC implementation and can be integrated as a submodule for branch predictor designs.
   - It is fully synchronous except for the asynchronous reset, ensuring deterministic time analysis for each state transition based on clock frequency.