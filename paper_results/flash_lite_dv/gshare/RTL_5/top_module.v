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

    // Internal Signals
    reg [6:0] ghr;
    reg [1:0] pht [0:127];
    reg [6:0] ghr_next;
    reg [1:0] pht_next [0:127];
    
    // Helper Signals
    wire [6:0] predict_index;
    wire [6:0] train_index;
    wire [6:0] index;
    wire [1:0] pht_entry;
    wire [1:0] pht_entry_next;

    // Index Calculation
    assign predict_index = predict_pc ^ ghr;
    assign train_index = train_pc ^ train_history;
    assign index = train_valid ? train_index : predict_index; // Select index based on train_valid

    // PHT Read
    assign pht_entry = pht[predict_index]; // Read PHT during prediction

    // Prediction Generation
    always @(*) begin
        predict_taken = pht_entry[1]; // MSB of counter determines prediction
        predict_history = ghr;
    end

    // Saturating Counter Update Logic
    always @(*) begin
        pht_entry_next = pht[index];
        if (train_valid) begin
            if (train_taken) begin
                if (pht_entry_next < 3) begin
                    pht_entry_next = pht_entry_next + 1'b1;
                end
            end else begin
                if (pht_entry_next > 0) begin
                    pht_entry_next = pht_entry_next - 1'b1;
                end
            end
        end
    end

    // GHR Update Logic (Prioritizes training over prediction)
    always @(*) begin
        ghr_next = ghr;
        if (train_valid) begin
            if (train_mispredicted) begin
                ghr_next = train_history;
            end else begin
                ghr_next = {ghr[5:0], train_taken};
            end
        end else if (predict_valid) begin
            ghr_next = {ghr[5:0], predict_taken};
        end
    end

    // Sequential Logic (Clocked Updates)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (int i = 0; i < 128; i++) begin
                pht[i] <= 2'b0;
            end
        end else begin
            ghr <= ghr_next;
            if(train_valid) begin
                pht[index] <= pht_entry_next;
            end
        end
    end
endmodule