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

    // Parameters
    localparam PHT_SIZE = 128;
    localparam COUNTER_WIDTH = 2;
    localparam HISTORY_WIDTH = 7;
    localparam PC_WIDTH = 7;

    // Internal Signals
    reg [HISTORY_WIDTH-1:0] ghr;
    reg [COUNTER_WIDTH-1:0] pht [0:PHT_SIZE-1];
    reg [HISTORY_WIDTH-1:0] next_ghr;
    reg [COUNTER_WIDTH-1:0] next_pht [0:PHT_SIZE-1];
    wire [6:0] predict_index;
    wire [6:0] train_index;
    wire [COUNTER_WIDTH-1:0] pht_read_data;
    wire pht_write_enable;
    wire [COUNTER_WIDTH-1:0] pht_write_data;
    wire [HISTORY_WIDTH-1:0] index_pc;
    wire [HISTORY_WIDTH-1:0] index_ghr;

    // Index Calculation
    assign index_pc = train_valid ? train_pc : predict_pc;
    assign index_ghr = train_valid ? train_history : ghr;

    assign predict_index = index_pc ^ index_ghr;
    assign train_index = train_pc ^ train_history;

    // PHT Read
    assign pht_read_data = pht[predict_index];

    // Prediction Logic
    always @(*) begin
        predict_history = ghr;
        predict_taken = pht_read_data[COUNTER_WIDTH-1];
    end

    // Saturating Counter Update Logic
    always @(*) begin
        if (train_valid) begin
            // Training takes precedence
            casez ({train_taken, train_mispredicted})
                2'b10:  // Taken, not mispredicted
                    next_pht[train_index] = (pht[train_index] < 3) ? pht[train_index] + 1 : 3;
                2'b00:  // Not taken, not mispredicted
                    next_pht[train_index] = (pht[train_index] > 0) ? pht[train_index] - 1 : 0;
                2'b11: //Taken and Mispredicted
                   next_pht[train_index] = (pht[train_index] < 3) ? pht[train_index] + 1 : 3;
                2'b01: //Not taken and Mispredicted
                    next_pht[train_index] = (pht[train_index] > 0) ? pht[train_index] - 1 : 0;
            endcase
        end else begin
            // No training, so PHT remains unchanged.
            for (int i = 0; i < PHT_SIZE; i++) begin
                next_pht[i] = pht[i];
            end
        end
    end

    // GHR Update Logic (Next Cycle)
    always @(*) begin
        next_ghr = ghr;
        if (train_valid) begin
            if (train_mispredicted)
                next_ghr = train_history; // Restore GHR on mispredict
            else
                next_ghr = {ghr[HISTORY_WIDTH-2:0], train_taken}; //Shift in taken bit after successful training
        end else if (predict_valid) begin
            next_ghr = {ghr[HISTORY_WIDTH-2:0], predict_taken}; // Shift in prediction result.
        end
    end

    // Sequential Logic (Clocked Updates)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= {HISTORY_WIDTH{1'b0}};
            for (int i = 0; i < PHT_SIZE; i++) begin
                pht[i] <= 2'b00;
            end
        end else begin
            ghr <= next_ghr;
            for (int i = 0; i < PHT_SIZE; i++) begin
                pht[i] <= next_pht[i];
            end
        end
    end

endmodule