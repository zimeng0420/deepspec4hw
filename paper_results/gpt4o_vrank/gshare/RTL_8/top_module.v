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

    // Define the Pattern History Table (PHT) with 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];

    // Global Branch History Register
    reg [6:0] global_history;

    // Asynchronous reset to clear the predictors' state
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else if (predict_valid) begin
            predict_history <= global_history;
            if (PHT[predict_pc ^ global_history] >= 2'b10) 
                predict_taken <= 1'b1; // Strongly/Weakly Taken
            else
                predict_taken <= 1'b0; // Strongly/Weakly Not Taken
            
            // Update global history with the prediction
            global_history <= {global_history[5:0], predict_taken};
        end
    end

    // Training logic
    always @(posedge clk) begin
        if (train_valid) begin
            // Compute the index
            reg [6:0] index = train_pc ^ train_history;
            
            // Update saturating counters based on real outcome
            if (train_taken) begin
                if (PHT[index] != 2'b11)
                    PHT[index] <= PHT[index] + 1'b1;
            end else begin
                if (PHT[index] != 2'b00)
                    PHT[index] <= PHT[index] - 1'b1;
            end
            
            // Recover global history if mispredicted
            if (train_mispredicted) begin
                global_history <= {train_history[5:0], train_taken};
            end
        end
    end

endmodule