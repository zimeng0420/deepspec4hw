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

    reg [1:0] PHT [0:127]; // 128-entry table of two-bit saturating counters
    reg [6:0] global_history; // 7-bit global branch history register
    integer i;

    // Initialize the PHT and global history
    initial begin
        for(i = 0; i < 128; i = i + 1) begin
            PHT[i] = 2'b01; // Weakly not taken (01)
        end
        global_history = 7'b0;
    end

    // Asynchronous reset logic
    always @(posedge areset or posedge clk) begin
        if (areset) begin
            for(i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            global_history <= 7'b0;
        end
        else begin
            if (train_valid) begin
                // Calculate the index for training
                integer train_index = train_pc ^ train_history;
                // Update the PHT based on the actual outcome
                if (train_taken) begin
                    if (PHT[train_index] != 2'b11) begin
                        PHT[train_index] <= PHT[train_index] + 2'b01;
                    end
                end 
                else begin
                    if (PHT[train_index] != 2'b00) begin
                        PHT[train_index] <= PHT[train_index] - 2'b01;
                    end
                end
                // Update global_history if misprediction
                if (train_mispredicted) begin
                    global_history <= train_history;
                end
            end
            // Update global history only if no misprediction training
            else if (predict_valid) begin
                global_history <= {global_history[5:0], predict_taken};
            end
        end
    end

    // Prediction logic
    always @* begin
        // Default outputs
        predict_taken = 0;
        predict_history = global_history;

        if (predict_valid) begin
            // Calculate index using XOR of PC and global history
            integer predict_index = predict_pc ^ global_history;
            // Based on PHT value, determine if branch is taken
            case (PHT[predict_index])
                2'b00, 2'b01: predict_taken = 1'b0; // Not taken
                2'b10, 2'b11: predict_taken = 1'b1; // Taken
            endcase
            // Return current global history
            predict_history = global_history;
        end
    end
endmodule