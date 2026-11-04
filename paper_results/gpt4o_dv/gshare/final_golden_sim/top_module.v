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

    // Global Registers
    reg [6:0] global_history;
    reg [1:0] PHT [0:127];

    // Compute the index using XOR of PC and Global History
    wire [6:0] predict_index = predict_pc ^ global_history;
    wire [6:0] train_index = train_pc ^ train_history;

    // Prediction Logic
    always @(*) begin
        predict_history = global_history;
        if(predict_valid) begin
            case (PHT[predict_index])
                2'b00, 2'b01: predict_taken = 0; // Not Taken
                2'b10, 2'b11: predict_taken = 1; // Taken
            endcase
        end
    end

    // Asynchronous Reset
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 0;
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= 2'b01; // Weakly Not Taken - Initial State
        end else begin
            // Update Logic on Clock Edge
            if (train_valid) begin
                // Update the PHT based on actual outcome
                if (train_taken) begin
                    if (PHT[train_index] < 2'b11)
                        PHT[train_index] <= PHT[train_index] + 1'b1;
                end else begin
                    if (PHT[train_index] > 2'b00)
                        PHT[train_index] <= PHT[train_index] - 1'b1;
                end
                
                // Recover GHR on Misprediction
                if (train_mispredicted) begin
                    global_history <= {train_history[6:1], train_taken}; // Recover
                end else begin
                    // Update Global History
                    global_history <= {global_history[6:1], train_taken};
                end
            end else if (predict_valid && !train_valid) begin
                // Update GHR for predictions only when no training
                global_history <= {global_history[6:1], predict_taken};
            end
        end
    end
endmodule