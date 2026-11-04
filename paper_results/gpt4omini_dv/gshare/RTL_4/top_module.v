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
    reg [1:0] PHT[127:0]; // Pattern History Table
    wire [6:0] index;

    // XOR operation for index calculation
    assign index = predict_pc ^ GHR;

    // Predict logic
    always @(*) begin
        if (predict_valid) begin
            predict_taken = (PHT[index] == 2'b10 || PHT[index] == 2'b11);
            predict_history = GHR;
        end
    end

    // Training Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b00;
            end
        end else begin
            if (train_valid) begin
                if (train_mispredicted) begin
                    GHR <= train_history; // Restore GHR on misprediction
                end else begin
                    GHR <= {GHR[6:1], train_taken}; // Shift in the new outcome
                end

                // Update the PHT
                case (PHT[index])
                    2'b00: PHT[index] <= train_taken ? 2'b01 : 2'b00;
                    2'b01: PHT[index] <= train_taken ? 2'b10 : 2'b00;
                    2'b10: PHT[index] <= train_taken ? 2'b11 : 2'b01;
                    2'b11: PHT[index] <= 2'b11; // Remain strong taken
                endcase
            end

            // If predicting during training on the same index, don't change predict logic
            if(predict_valid && !train_valid) begin
                predict_history <= GHR;
                predict_taken <= (PHT[index] == 2'b10 || PHT[index] == 2'b11);
            end
        end
    end
endmodule