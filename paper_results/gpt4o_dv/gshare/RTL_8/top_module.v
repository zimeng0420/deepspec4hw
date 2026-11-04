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

reg [1:0] PHT [127:0];  // 128-entry table of 2-bit saturating counters
reg [6:0] global_history; // 7-bit global history register

always @(posedge clk or posedge areset) begin
    if (areset) begin
        integer i;
        for (i = 0; i < 128; i = i + 1)
            PHT[i] <= 2'b00;  // Reset all PHT entries
        global_history <= 7'b0; // Reset global history
    end
    else if (train_valid) begin
        // Calculate index for training
        integer index;
        index = train_pc ^ train_history;
        
        // Update PHT with saturating counter logic
        if (train_taken) begin
            if (PHT[index] < 2'b11)
                PHT[index] <= PHT[index] + 2'b01;
        end else begin
            if (PHT[index] > 2'b00)
                PHT[index] <= PHT[index] - 2'b01;
        end

        // Update global history register based on actual outcome
        if (train_mispredicted) begin
            global_history <= {train_history[5:0], train_taken};
        end else begin
            global_history <= {global_history[5:0], train_taken};
        end
    end
    // Note: Predict valid updates history for prediction path,
    // handled in non-blocking always further down
end

always @(*) begin
    if (predict_valid) begin
        // Calculate index for prediction
        integer index;
        index = predict_pc ^ global_history;

        // Determine prediction
        predict_taken = (PHT[index] >= 2'b10);
        predict_history = global_history;
    end
end

endmodule