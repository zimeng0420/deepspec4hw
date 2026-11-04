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

    // Constants
    localparam PHT_INDEX_WIDTH = 7;
    localparam PHT_ENTRY_WIDTH = 2;
    localparam PHT_SIZE = 128;

    // Internal Signals
    reg [6:0] ghr;
    reg [PHT_ENTRY_WIDTH-1:0] pht [0:PHT_SIZE-1];
    reg [PHT_INDEX_WIDTH-1:0] pht_index;
    reg [PHT_ENTRY_WIDTH-1:0] pht_entry;
    reg [PHT_ENTRY_WIDTH-1:0] pht_entry_next;
    wire [PHT_INDEX_WIDTH-1:0] predict_index;
    wire [PHT_INDEX_WIDTH-1:0] train_index;
    wire [PHT_ENTRY_WIDTH-1:0] new_pht_entry;

    // Combinational Logic for Prediction
    assign predict_index = predict_pc ^ ghr;

    // Combinational Logic for Training Index Calculation
    assign train_index = train_pc ^ train_history;

    // PHT Read - Prediction
    always @(*) begin
        if (predict_valid) begin
            pht_index = predict_index;
            pht_entry = pht[predict_index];
        end
    end

    // Prediction Generation
    always @(*) begin
        if (predict_valid) begin
            predict_taken = pht_entry[PHT_ENTRY_WIDTH-1];
        end
    end

    always @(*) begin
        if (predict_valid) begin
            predict_history = ghr;
        end
    end

    // PHT Update Logic (Saturating Counter)
    always @(*) begin
        pht_entry_next = pht[train_index]; // Default, no change
        if (train_valid) begin
            if (train_taken) begin
                pht_entry_next = (pht[train_index] < 3) ? pht[train_index] + 1 : 3;
            end else begin
                pht_entry_next = (pht[train_index] > 0) ? pht[train_index] - 1 : 0;
            end
        end
    end

    // Sequential Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
                pht[i] <= 2'b0;
            end
        end else begin
            // PHT Update
            if (train_valid) begin
                pht[train_index] <= pht_entry_next;
            end
            // GHR Update
            if (train_valid && train_mispredicted) begin
                ghr <= train_history; // Recover from misprediction
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};  // Update GHR for predicted branch direction
            end
        end
    end

endmodule