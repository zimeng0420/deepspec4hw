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

// Registers
reg [31:0] history_reg;

// Process execution based on signals
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset
        history_reg <= 32'b0;
    end else if (train_mispredicted) begin
        // Update history in case of misprediction
        history_reg <= {train_history[30:0], train_taken};
    end else if (predict_valid) begin
        // Update history on prediction
        history_reg <= {history_reg[30:0], predict_taken};
    end
end

// Output
assign predict_history = history_reg;

endmodule