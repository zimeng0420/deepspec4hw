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

    // Parameters
    localparam PHT_SIZE = 128;
    localparam COUNTER_WIDTH = 2;
    localparam HISTORY_WIDTH = 7;
    localparam INDEX_WIDTH = 7;

    // Internal Signals
    reg [HISTORY_WIDTH-1:0] ghr;
    reg [COUNTER_WIDTH-1:0] pht [0:PHT_SIZE-1];
    reg [INDEX_WIDTH-1:0] pht_index;
    reg [COUNTER_WIDTH-1:0] pht_read_data;
    wire [INDEX_WIDTH-1:0] predict_index;
    wire [INDEX_WIDTH-1:0] train_index;
    wire ghr_update_enable;
    wire [HISTORY_WIDTH-1:0] ghr_next;
    wire [COUNTER_WIDTH-1:0] pht_write_data;
    wire pht_write_enable;

    // Combinational Logic for Index Calculation
    assign predict_index = predict_pc ^ ghr;
    assign train_index = train_pc ^ train_history;

    // Combinational Logic for Prediction Generation
    always @(*) begin
        if (predict_valid) begin
            pht_index = predict_index;
            predict_history = ghr;
            predict_taken = pht[predict_index][COUNTER_WIDTH-1]; //MSB
        end
    end

    // PHT Read
    always @(*) begin
        if (predict_valid) begin
            pht_read_data = pht[predict_index];
        end
    end

    // Combinational Logic for PHT Write Data Generation
    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment counter
                pht_write_data = pht[train_index] + 1'b1;
                if (pht_write_data == 2'b11) begin //saturation
                    pht_write_data = 2'b11;
                end
            end else begin
                // Decrement counter
                pht_write_data = pht[train_index] - 1'b1;
                if (pht_write_data == 2'b00) begin //saturation
                    pht_write_data = 2'b00;
                end
            end
        end
        else begin
            pht_write_data = pht[pht_index]; // keep the old value
        end
    end

    // Clocked Logic for PHT Update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
                pht[i] <= 2'b00;
            end
        end
        else if (train_valid) begin
            pht[train_index] <= pht_write_data;
        end
    end

    // GHR Update Enable
    assign ghr_update_enable = train_valid || predict_valid;


    // GHR Next state Calculation
    always @(*) begin
        if (train_valid) begin
            if (train_mispredicted) begin
                ghr_next = train_history;
            end else begin
                ghr_next = {ghr[HISTORY_WIDTH-2:0], train_taken};
            end
        end
        else if (predict_valid) begin
            ghr_next = {ghr[HISTORY_WIDTH-2:0], predict_taken};
        end
        else begin
            ghr_next = ghr;
        end
    end

    // Clocked Logic for GHR Update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= {HISTORY_WIDTH{1'b0}};
        end
        else if (ghr_update_enable) begin
            ghr <= ghr_next;
        end
    end

endmodule