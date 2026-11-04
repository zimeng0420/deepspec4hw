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

    reg [6:0] GHR; // Global History Register
    reg [1:0] PHT [127:0]; // Pattern History Table
    wire [6:0] index;

    // Calculate index using XOR
    assign index = predict_pc ^ GHR;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b00; // Initialize PHT to strongly not taken
            end
        end else begin
            // Prediction logic
            if (predict_valid) begin
                predict_taken <= (PHT[index] == 2'b10 || PHT[index] == 2'b11);
                predict_history <= GHR;
            end

            // Training logic
            if (train_valid) begin
                // Update PHT based on actual outcome
                if (train_taken) begin
                    if (PHT[train_pc ^ train_history] != 2'b11) begin
                        PHT[train_pc ^ train_history] <= PHT[train_pc ^ train_history] + 1;
                    end
                end else begin
                    if (PHT[train_pc ^ train_history] != 2'b00) begin
                        PHT[train_pc ^ train_history] <= PHT[train_pc ^ train_history] - 1;
                    end
                end

                // Restore GHR if misprediction
                if (train_mispredicted) begin
                    GHR <= train_history;
                end else begin
                    // Update GHR for predicted branch
                    GHR <= {GHR[6:1], train_taken};
                end
            end else if (predict_valid) begin
                // Only update GHR when there is a prediction
                GHR <= {GHR[6:1], predict_taken};
            end
        end
    end

endmodule