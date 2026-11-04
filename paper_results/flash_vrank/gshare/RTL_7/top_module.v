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

    reg [6:0] global_history;
    reg [1:0] pht [127:0]; // Pattern History Table (128 entries, 2-bit counters)

    // Indexing function (XOR hashing)
    function [6:0] get_index;
        input [6:0] pc;
        input [6:0] history;
        begin
            get_index = pc ^ history;
        end
    endfunction

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b00;
            end
        end else begin
            // Training logic
            if (train_valid) begin
                reg [6:0] train_index;
                train_index = get_index(train_pc, train_history);

                if (train_taken) begin
                    if (pht[train_index] < 2'b11) begin
                        pht[train_index] <= pht[train_index] + 1;
                    end
                end else begin
                    if (pht[train_index] > 2'b00) begin
                        pht[train_index] <= pht[train_index] - 1;
                    end
                end

                if (train_mispredicted) begin
                    global_history <= train_history;
                end
            end

            // Prediction logic: Update global history after prediction, unless training takes precedence
            if (predict_valid && !train_valid) begin
                if (predict_taken) begin
                    global_history <= {global_history[5:0], 1'b1};
                end else begin
                    global_history <= {global_history[5:0], 1'b0};
                end
            end else if(predict_valid && train_valid){
                //When this happens, training takes precedence, because the branch being predicted will be discarded anyway.
            }
        end
    end

    // Prediction output logic
    always @(*) begin
        reg [6:0] predict_index;
        predict_index = get_index(predict_pc, global_history);
        
        predict_history = global_history; // Output the history used for prediction
        
        predict_taken = (pht[predict_index] >= 2'b10);
    end

endmodule