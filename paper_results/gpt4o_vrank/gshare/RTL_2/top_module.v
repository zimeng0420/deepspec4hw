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

    reg [1:0] PHT [0:127]; // 128-entry table of 2-bit saturating counters
    reg [6:0] global_history;

    integer i;

    // asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01; // Initialize to weakly not taken
            end
        end
    end

    // Prediction logic: combinational
    wire [6:0] index;
    assign index = predict_pc ^ global_history;
    always @(*) begin
        if (predict_valid) begin
            predict_taken = (PHT[index] >= 2'b10); // Predict 'taken' if counter is 2 or 3
            predict_history = global_history;
        end
    end

    // Update logic: synchronous with priority to training
    always @(posedge clk) begin
        if (train_valid) begin
            // Update global history for the trained branch
            if (train_mispredicted) begin
                global_history <= (train_history << 1) | train_taken;
            end else begin
                global_history <= (global_history << 1) | train_taken;
            end
            
            // Update PHT for the trained branch
            if (train_taken) begin
                if (PHT[train_pc ^ train_history] < 2'b11)
                    PHT[train_pc ^ train_history] <= PHT[train_pc ^ train_history] + 1;
            end else begin
                if (PHT[train_pc ^ train_history] > 2'b00)
                    PHT[train_pc ^ train_history] <= PHT[train_pc ^ train_history] - 1;
            end
        end else if (predict_valid) begin
            // Update global history for the predicted branch if no training happens
            global_history <= (global_history << 1) | predict_taken;
        end
    end

endmodule