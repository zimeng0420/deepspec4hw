module top_module(
    input clk,
    input areset, 

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken, 
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history, 
    input [6:0] train_pc
);

    reg [1:0] PHT[127:0]; // 128 2-bit saturating counters
    reg [6:0] global_history; // 7-bit global history register
    wire [6:0] index; // 7-bit index
    reg [6:0] next_global_history; // Next state of global history register
    
    // Predicting branch direction
    assign index = predict_pc ^ global_history; // Hashing
    assign predict_taken = (PHT[index] >= 2'd2); // Predict taken if counter >= 2
    assign predict_history = global_history;

    // On clock edge
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b00; // Reset PHT
            end
        end else begin
            if (train_valid) begin
                if (train_mispredicted) begin
                    global_history <= train_history; // Recover history on misprediction
                end else begin
                    // Update global history register
                    global_history <= {global_history[5:0], train_taken}; 
                end
                
                // Update the PHT based on training
                if (train_taken) begin
                    if (PHT[train_pc ^ train_history] < 2'd3) begin
                        PHT[train_pc ^ train_history] <= PHT[train_pc ^ train_history] + 1; // Increment the counter
                    end
                end else begin
                    if (PHT[train_pc ^ train_history] > 2'd0) begin
                        PHT[train_pc ^ train_history] <= PHT[train_pc ^ train_history] - 1; // Decrement the counter
                    end
                end
            end
            
            if (predict_valid) begin
                // Update global history for the predicted branch
                next_global_history <= {global_history[5:0], predict_taken};
            end
        end
    end

endmodule