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
    localparam PHT_SIZE = 128;
    localparam COUNTER_WIDTH = 2;
    localparam HISTORY_WIDTH = 7;
    localparam INDEX_WIDTH = 7;

    // Internal Signals
    reg [HISTORY_WIDTH-1:0] ghr;
    reg [COUNTER_WIDTH-1:0] pht [0:PHT_SIZE-1];
    wire [INDEX_WIDTH-1:0] predict_index;
    wire [INDEX_WIDTH-1:0] train_index;
    wire [COUNTER_WIDTH-1:0] pht_read_data;
    wire [COUNTER_WIDTH-1:0] pht_write_data;
    wire ghr_next_bit;
    wire [HISTORY_WIDTH-1:0] ghr_next;


    // ---------------------------------------------------------------------------
    // Combinational Logic for Index Calculation and Prediction
    // ---------------------------------------------------------------------------

    // Index Calculation (Predict)
    assign predict_index = predict_pc ^ ghr;

    // PHT Read (Prediction)
    assign pht_read_data = pht[predict_index];

    // Prediction Generation
    assign predict_taken = pht_read_data[COUNTER_WIDTH - 1];

    // Index Calculation (Train)
    assign train_index = train_pc ^ train_history;

    // ---------------------------------------------------------------------------
    // Saturating Counter Update Logic and GHR update logic (Combinational)
    // ---------------------------------------------------------------------------

    // Determine next GHR bit based on training
    assign ghr_next_bit = train_taken ? 1'b1 : 1'b0;

     // Determine next GHR value based on training (prioritizing training over prediction)
    assign ghr_next = train_valid ? (train_mispredicted ? train_history : {ghr[HISTORY_WIDTH-2:0], ghr_next_bit}) : {ghr[HISTORY_WIDTH-2:0], predict_taken};


    // Saturating Counter Update Logic
    always_comb begin
        if (train_valid) begin
            case (1'b1)
                train_taken: pht_write_data = (pht[train_index] == 3) ? 3 : pht[train_index] + 1;
                ~train_taken: pht_write_data = (pht[train_index] == 0) ? 0 : pht[train_index] - 1;
                default: pht_write_data = pht[train_index];
            endcase
        end else begin
            pht_write_data = pht[predict_index];
        end
    end


    // ---------------------------------------------------------------------------
    // Sequential Logic (Registers)
    // ---------------------------------------------------------------------------

    // GHR Update (Clocked)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= {HISTORY_WIDTH{1'b0}};
        end else if (train_valid) begin
            ghr <= ghr_next;
        end else if (predict_valid) begin
            ghr <= ghr_next;
        end
    end

    // PHT Update (Clocked)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
                pht[i] <= 2'b00;
            end
        end else if (train_valid) begin
           pht[train_index] <= pht_write_data;
        end
    end

    // Predict_history update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= {HISTORY_WIDTH{1'b0}};
        end else begin
            predict_history <= ghr;
        end
    end
endmodule