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

    reg [1:0] PHT[127:0]; // Pattern History Table
    reg [6:0] GHR; // Global History Register

    wire [6:0] index; 
    assign index = (predict_pc ^ GHR) [6:0]; // hashing with XOR

    // Prediction on predict_valid
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0; 
            predict_taken <= 1'b0; 
            predict_history <= 7'b0; 
            for (integer i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b00; // Initialize PHT to weakly not taken
            end
        end else begin
            if (predict_valid) begin
                predict_taken <= (PHT[index] >= 2'b10); // Taken if counter is 2 or 3
                predict_history <= GHR;
            end

            if (train_valid) begin
                // Update the PHT
                if (train_taken) begin
                    if (PHT[train_pc[6:0] ^ train_history] < 2'b11)
                        PHT[train_pc[6:0] ^ train_history] <= PHT[train_pc[6:0] ^ train_history] + 1;
                end else begin
                    if (PHT[train_pc[6:0] ^ train_history] > 2'b00)
                        PHT[train_pc[6:0] ^ train_history] <= PHT[train_pc[6:0] ^ train_history] - 1;
                end
                // Update GHR
                if (train_mispredicted) begin
                    GHR <= train_history; // Recover GHR if mispredicted
                end else begin
                    GHR <= {GHR[5:0], train_taken}; // Update GHR with the prediction
                end
            end
        end
    end
endmodule