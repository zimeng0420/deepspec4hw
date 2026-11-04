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
    reg [1:0] PHT [0:127]; // Pattern History Table
    reg [6:0] global_history; // Global History Register
    wire [6:0] index; // Hashed index
    reg [6:0] next_global_history;
    
    assign index = predict_pc ^ global_history; // Hashing PC and global history to get index

    initial begin
        // Initialize PHT and global history
        integer i;
        for (i = 0; i < 128; i = i + 1) begin
            PHT[i] = 2'b00; // Initialize PHT to weakly taken
        end
        global_history = 7'b0000000; // Initialize global history
    end

    // Prediction Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0000000; // Reset the global history
            predict_taken <= 0;
            predict_history <= 7'b0000000;
        end else begin
            if (predict_valid) begin
                predict_taken <= PHT[index][1]; // Take the MSB of the counter as prediction
                predict_history <= global_history; // Store current global history
                next_global_history <= {global_history[5:0], predict_taken}; // Update global history
            end
            
            if (train_valid) begin
                // Training logic
                if (train_mispredicted) begin
                    global_history <= train_history; // Recover global history on misprediction
                end else begin
                    // Update PHT based on branch outcome
                    if (train_taken) begin
                        if (PHT[train_pc ^ train_history] != 2'b11) // If not strongly taken
                            PHT[train_pc ^ train_history] <= PHT[train_pc ^ train_history] + 1; // Increment counter
                    end else begin
                        if (PHT[train_pc ^ train_history] != 2'b00) // If not strongly not taken
                            PHT[train_pc ^ train_history] <= PHT[train_pc ^ train_history] - 1; // Decrement counter
                    end
                end
            end
        end
    end

    // Updating global history at next clock edge
    always @(posedge clk) begin
        if (!areset) begin
            global_history <= next_global_history; // Update global history
        end
    end
endmodule