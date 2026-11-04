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

    // Internal register for the 32-bit global history shift register
    logic [31:0] history_reg;

    // Combinational logic to determine the next value of the history register
    always_comb begin
        if (areset) begin
            history_reg = 32'b0; // Reset to all zeros
        end else if (train_mispredicted) begin
            // Misprediction: Load the history before the mispredicted branch,
            // concatenated with the actual result of the branch.
            history_reg = {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Prediction: Shift in the predicted branch direction.
            history_reg = {history_reg[30:0], predict_taken};
        end else begin
            // No prediction or misprediction: Keep the current history.
            history_reg = history_reg;
        end
    end

    // Assign the current history to the output
    assign predict_history = history_reg;

endmodule