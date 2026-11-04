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

    reg [1:0] pattern_history_table [0:127];
    reg [6:0] global_branch_history;

    integer i;

    // Asynchronous reset
    always @(posedge areset or posedge clk) begin
        if (areset) begin
            global_branch_history <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pattern_history_table[i] <= 2'b01;  // Initialize to weakly not taken
            end
        end else if (clk) begin
            if (train_valid) begin
                // Compute index for training
                int train_index = train_pc ^ train_history;
                
                // Update pattern history table based on actual branch outcome
                if (train_taken) begin
                    if (pattern_history_table[train_index] != 2'b11) begin
                        pattern_history_table[train_index] <= pattern_history_table[train_index] + 1;
                    end
                end else begin
                    if (pattern_history_table[train_index] != 2'b00) begin
                        pattern_history_table[train_index] <= pattern_history_table[train_index] - 1;
                    end
                end
                
                // Update or recover global branch history
                if (train_mispredicted) begin
                    global_branch_history <= {train_history[5:0], train_taken};
                end else begin
                    global_branch_history <= {global_branch_history[5:0], train_taken};
                end
            end else if (predict_valid) begin
                // Only update global_branch_history if no training in progress
                global_branch_history <= {global_branch_history[5:0], predict_taken};
            end
        end
    end

    // Combinational logic for prediction
    always @(*) begin
        if (predict_valid) begin
            // Compute index for prediction
            int predict_index = predict_pc ^ global_branch_history;
            
            // Get prediction from the pattern history table
            case (pattern_history_table[predict_index])
                2'b00, 2'b01: predict_taken = 1'b0;  // Not taken
                2'b10, 2'b11: predict_taken = 1'b1;  // Taken
                default: predict_taken = 1'b0;
            endcase
            
            // Output current global history
            predict_history = global_branch_history;
        end
    end

endmodule