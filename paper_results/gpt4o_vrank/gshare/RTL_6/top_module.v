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

    reg [1:0] PHT [127:0];  // Pattern History Table with 128 entries of 2-bit saturating counters
    reg [6:0] GHR;          // Global History Register

    integer i;
    
    // Asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset all PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= 2'b01;
            
            GHR <= 7'b0;
        end else begin
            // Training logic
            if (train_valid) begin
                // Calculate the index using XOR of PC and history
                reg [6:0] train_index = train_pc ^ train_history;
                
                // Saturating counter update
                if (train_taken) begin
                    if (PHT[train_index] < 2'b11)
                        PHT[train_index] <= PHT[train_index] + 1;
                end else begin
                    if (PHT[train_index] > 2'b00)
                        PHT[train_index] <= PHT[train_index] - 1;
                end

                // If mispredicted, recover the GHR
                if (train_mispredicted) begin
                    GHR <= {train_history[5:0], train_taken};
                end
            end

            // Global History Register update
            if (predict_valid && !train_mispredicted) begin
                GHR <= {GHR[5:0], predict_taken};
            end
        end
    end

    // Prediction logic
    always @(*) begin
        if (predict_valid) begin
            // Calculate the index
            reg [6:0] predict_index = predict_pc ^ GHR;

            // Predict taken if counter is in 10 or 11 state
            predict_taken = PHT[predict_index] >= 2'b10;
            // Pass the current GHR
            predict_history = GHR;
        end else begin
            predict_taken = 1'b0;
            predict_history = 7'b0;
        end
    end

endmodule