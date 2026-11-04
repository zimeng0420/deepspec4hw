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

    // Internal components
    reg [6:0] ghr; // Global History Register
    reg [1:0] pht [0:127]; // Pattern History Table: 128 entries of 2-bit counters

    // Predict procedure
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else if (predict_valid) begin
            // Update GHR
            ghr <= {ghr[5:0], predict_taken};
        end else if (train_valid && train_mispredicted) begin
            // Recover GHR on misprediction
            ghr <= train_history;
        end
    end

    // Helper function to get PHT index
    function [6:0] get_pht_index(input [6:0] pc, input [6:0] hist);
        get_pht_index = pc ^ hist;
    endfunction

    always @(*) begin
        if (predict_valid) begin
            // Generate index and access PHT
            predict_history = ghr;
            predict_taken = pht[get_pht_index(predict_pc, ghr)][1];
        end
    end

    // Train procedure
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01; // Weakly taken
            end
        end else if (train_valid) begin
            // Compute PHT index for training
            reg [6:0] train_index;
            train_index = get_pht_index(train_pc, train_history);

            // Update PHT based on actual outcome
            if (train_taken) begin
                if (pht[train_index] < 2'b11) begin
                    pht[train_index] <= pht[train_index] + 2'b01;
                end
            end else begin
                if (pht[train_index] > 2'b00) begin
                    pht[train_index] <= pht[train_index] - 2'b01;
                end
            end
        end
    end

endmodule