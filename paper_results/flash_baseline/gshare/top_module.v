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

    reg [6:0] global_history;
    reg [1:0] pht [127:0]; // Pattern History Table (PHT)

    // Prediction Logic
    wire [6:0] predict_index = predict_pc ^ global_history;

    always @(*) begin
        predict_history = global_history; // Output the current history for prediction
        if (predict_valid) begin
            predict_taken = (pht[predict_index] >= 2'b10); // Predict taken if counter >= 2
        end else begin
            predict_taken = 0; // Default prediction when not valid
        end
    end

    // Training Logic
    wire [6:0] train_index = train_pc ^ train_history;

    always @(posedge clk) begin
        if (areset) begin
            global_history <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b10; // Initialize to weakly taken
            end
        end else begin
            if (train_valid) begin
                if (train_taken) begin
                    if (pht[train_index] < 2'b11) begin
                        pht[train_index] <= pht[train_index] + 1'b1; // Increment counter
                    end
                end else begin
                    if (pht[train_index] > 2'b00) begin
                        pht[train_index] <= pht[train_index] - 1'b1; // Decrement counter
                    end
                end

                if (train_mispredicted) begin
                    global_history <= train_history; // Recover history on misprediction
                end else if (predict_valid == 0 || train_pc != predict_pc) begin
                    global_history <= {global_history[5:0], train_taken}; // Update history with actual outcome
                end
            end else if (predict_valid) begin
                global_history <= {global_history[5:0], predict_taken}; // Update history with predicted outcome
            end
        end
    end

endmodule