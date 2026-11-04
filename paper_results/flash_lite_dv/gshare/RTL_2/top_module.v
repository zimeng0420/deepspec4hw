module top_module(
    input clk,
    input areset,
    // Prediction Interface
    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,
    // Training Interface
    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // Global History Register
    reg [6:0] global_history;

    // Pattern History Table (PHT)
    reg [1:0] pht [0:127];

    // Internal Signals
    wire [6:0] predict_index;
    wire [1:0] pht_entry;
    wire [6:0] train_index;
    wire [1:0] new_pht_entry;
    wire ghr_update_taken;
    wire [6:0] ghr_next;
    wire [6:0] ghr_reset_value;
    wire ghr_reset_enable;


    // Index Calculation (Prediction)
    assign predict_index = predict_pc ^ global_history;

    // Index Calculation (Training)
    assign train_index = train_pc ^ train_history;

    // PHT Access (Read - Prediction)
    assign pht_entry = pht[predict_index];

    // Prediction Generation
    assign predict_taken = pht_entry[1];

    // Saturating Counter Update Logic
    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                if (pht[train_index] < 2'b11) begin
                    new_pht_entry = pht[train_index] + 1;
                end else begin
                    new_pht_entry = pht[train_index];
                end
            end else begin
                if (pht[train_index] > 2'b00) begin
                    new_pht_entry = pht[train_index] - 1;
                end else begin
                    new_pht_entry = pht[train_index];
                end
            end
        end else begin
            new_pht_entry = pht[train_index]; // Keep the current value in case there is no training
        end
    end


    // Global History Register Update Logic

    assign ghr_update_taken = (train_valid) ? train_taken : predict_taken;
    assign ghr_reset_enable = train_valid && train_mispredicted;
    assign ghr_reset_value = train_history;

    assign ghr_next = ghr_reset_enable ? ghr_reset_value : {global_history[5:0], ghr_update_taken};



    // Sequential Logic (Clocked)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            for (int i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b00;
            end
        end else begin
            // Update GHR first, in case there is a conflict
            if (train_valid && train_mispredicted)
                global_history <= train_history;
            else if (train_valid)
                global_history <= {global_history[5:0], train_taken};
            else if (predict_valid)
                global_history <= {global_history[5:0], predict_taken};

            //Update PHT
            if(train_valid)
                pht[train_index] <= new_pht_entry;
            
            predict_history <= global_history;
        end
    end

endmodule