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
    reg [6:0] global_history_reg; // Global History Register
    wire [6:0] index; // Hashed index from PC and global history

    // Hashing PC and global history to get the index
    assign index = (predict_pc ^ global_history_reg) [6:0];

    // Prediction logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history_reg <= 7'b0;
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
            // Initialize PHT to weakly taken state
            for (int i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01; // Initial state
            end
        end else begin
            if (predict_valid) begin
                // Output prediction and current global history
                predict_taken <= PHT[index][1]; // Most significant bit for prediction
                predict_history <= global_history_reg;
            end
            
            if (train_valid) begin
                // Update the PHT based on training input
                if (train_taken && (PHT[index] < 2'b11)) begin
                    PHT[index] <= PHT[index] + 1; // Increment counter
                end else if (~train_taken && (PHT[index] > 2'b00)) begin
                    PHT[index] <= PHT[index] - 1; // Decrement counter
                end

                // If mispredicted, recover global history
                if (train_mispredicted) begin
                    global_history_reg <= train_history;
                end else begin
                    global_history_reg <= {global_history_reg[5:0], train_taken}; // Update global history
                end
            end else if (predict_valid) begin
                // Update global history for the predicted branch
                global_history_reg <= {global_history_reg[5:0], predict_taken}; // Update based on prediction
            end
        end
    end
endmodule