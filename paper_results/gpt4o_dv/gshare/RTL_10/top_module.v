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
    
    reg [1:0] PHT [127:0]; // 128-entry table with 2-bit saturating counters
    reg [6:0] global_history; // Global branch history register
    
    // Initialize PHT and global history on reset
    integer i;
    always @(posedge areset or posedge clk) begin
        if (areset) begin
            global_history <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01; // Initialize to weakly not taken state
            end
        end
        else begin
            // Training logic
            if (train_valid) begin
                // Compute index for training
                reg [6:0] train_index;
                train_index = train_pc ^ train_history;
                
                // Update PHT entry based on actual outcome
                if (train_taken) begin
                    if (PHT[train_index] < 2'b11)
                        PHT[train_index] <= PHT[train_index] + 1;
                end else begin
                    if (PHT[train_index] > 2'b00)
                        PHT[train_index] <= PHT[train_index] - 1;
                end
                
                // Update global history register
                if (train_mispredicted) begin
                    global_history <= train_history;
                end else begin
                    global_history <= {global_history[5:0], train_taken};
                end
            end else begin
                // Normal global history update on prediction
                if (predict_valid) begin
                    global_history <= {global_history[5:0], predict_taken};
                end
            end
        end
    end

    // Prediction logic
    always @(*) begin
        // Compute index for prediction
        reg [6:0] predict_index;
        predict_index = predict_pc ^ global_history;

        // Determine prediction from PHT
        case (PHT[predict_index])
            2'b00, 2'b01: predict_taken = 1'b0; // Not taken
            2'b10, 2'b11: predict_taken = 1'b1; // Taken
        endcase

        // Output the current global history for the prediction
        predict_history = global_history;
    end

endmodule