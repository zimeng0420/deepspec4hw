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
    localparam PC_WIDTH = 7;

    // Internal signals
    reg [HISTORY_WIDTH-1:0] ghr;
    reg [COUNTER_WIDTH-1:0] pht [0:PHT_SIZE-1];
    reg [6:0] pht_index;
    reg [COUNTER_WIDTH-1:0] pht_entry;
    wire [6:0] predict_index;
    wire [6:0] train_index;
    wire pht_we;
    wire [COUNTER_WIDTH-1:0] next_pht_entry;
    wire [HISTORY_WIDTH-1:0] next_ghr;


    // Index calculation
    assign predict_index = predict_pc ^ ghr;
    assign train_index = train_pc ^ train_history;

    // PHT read
    always @(*) begin
        if (predict_valid) begin
            pht_index = predict_index;
            pht_entry = pht[predict_index];
        end
    end

    // Prediction generation
    always @(*) begin
        if (predict_valid) begin
            predict_taken = pht_entry[COUNTER_WIDTH - 1];
            predict_history = ghr;
        end
    end
    
    // Saturating counter update logic
    always @(*) begin
        if (train_valid) begin
            case ({train_taken, train_mispredicted})
                2'b10:  next_pht_entry = (pht[train_index] < 3) ? pht[train_index] + 1 : 3;
                2'b00:  next_pht_entry = (pht[train_index] > 0) ? pht[train_index] - 1 : 0;
                default: next_pht_entry = pht[train_index];
            endcase
        end else begin
            next_pht_entry = pht[train_index];
        end
    end

    // GHR update logic
    always @(*) begin
        if (train_valid && train_mispredicted) begin
            next_ghr = train_history;
        end else begin
            next_ghr = {ghr[HISTORY_WIDTH-2:0], (predict_valid && !train_valid) ? predict_taken : (train_valid && !train_mispredicted ? train_taken : ghr[HISTORY_WIDTH-2])};
        end
    end

    // PHT write enable
    assign pht_we = train_valid;
    
    // Synchronous updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= {HISTORY_WIDTH{1'b0}};
            for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
                pht[i] <= 2'b00;
            end
        end else begin
            if (pht_we) begin
                pht[train_index] <= next_pht_entry;
            end
            ghr <= next_ghr;
        end
    end

endmodule