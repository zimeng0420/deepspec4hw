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

    reg [1:0] PHT [0:127]; // 128-entry table of 2-bit saturating counters
    reg [6:0] global_history; // 7-bit global branch history register

    // Initialize PHT and global history on reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            integer i;
            global_history <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01; // initialize to weakly not taken
            end
        end else begin
            if (train_valid) begin
                // Compute index from train_pc and train_history
                reg [6:0] index;
                index = train_pc ^ train_history;

                // Update PHT based on actual branch outcome
                if (train_taken) begin
                    if (PHT[index] < 2'b11) PHT[index] <= PHT[index] + 1'b1; // Increment counter
                end else begin
                    if (PHT[index] > 2'b00) PHT[index] <= PHT[index] - 1'b1; // Decrement counter
                end

                // If mispredicted, recover global history register
                if (train_mispredicted) begin
                    global_history <= {train_history[5:0], train_taken};
                end else begin
                    // Update global history register for normal training
                    global_history <= {train_history[5:0], train_taken};
                end
            end else if (predict_valid) begin
                // Update global history for branch prediction
                global_history <= {global_history[5:0], predict_taken}; 
            end
        end
    end

    // Prediction logic
    always @* begin
        if (predict_valid) begin
            // Compute index from predict_pc and global_history
            reg [6:0] index;
            index = predict_pc ^ global_history;
            
            // Make prediction based on the counter value
            case (PHT[index])
                2'b00, 2'b01: predict_taken = 1'b0;
                2'b10, 2'b11: predict_taken = 1'b1;
            endcase
            
            // Output the current global history
            predict_history = global_history;
        end
    end

endmodule