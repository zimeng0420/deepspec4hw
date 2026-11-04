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
    localparam PHT_ENTRIES = 128;
    localparam COUNTER_WIDTH = 2;
    localparam HISTORY_WIDTH = 7;
    localparam PC_WIDTH = 7;

    // Internal Signals
    reg [HISTORY_WIDTH-1:0] ghr;
    reg [COUNTER_WIDTH-1:0] pht [0:PHT_ENTRIES-1];
    reg [6:0] pht_index_reg;
    reg [COUNTER_WIDTH-1:0] pht_data_reg;
    reg [6:0] ghr_next;

    // Combinational Logic for Index Calculation
    wire [PC_WIDTH-1:0] xor_input;
    wire [6:0] pht_index;

    assign xor_input = train_valid ? train_pc : predict_pc; // Select PC for training or prediction
    assign pht_index = xor_input ^ (train_valid ? train_history : ghr); // XOR PC and GHR/train_history

    // Combinational Logic for PHT read
    wire [COUNTER_WIDTH-1:0] pht_entry;
    assign pht_entry = pht[pht_index];
    
    // Combinational Logic for Prediction
    assign predict_taken = pht_entry[COUNTER_WIDTH-1]; // MSB of counter determines prediction
    assign predict_history = ghr;

    // Combinational Logic for PHT update
    wire [COUNTER_WIDTH-1:0] pht_next;
    wire [HISTORY_WIDTH-1:0] ghr_next_temp;

    always @(*) begin
        pht_next = pht_entry;
        ghr_next_temp = ghr;

        if (train_valid) begin
            pht_index_reg = pht_index;
            
            if (train_taken) begin
                if (pht_entry < 3) begin
                    pht_next = pht_entry + 1;
                end
            end else begin
                if (pht_entry > 0) begin
                    pht_next = pht_entry - 1;
                end
            end
        end
    
        if (train_valid) begin
          if (train_mispredicted) begin
            ghr_next_temp = train_history;
          end else begin
            ghr_next_temp = {ghr_next_temp[5:0], train_taken};
          end
        end else begin
          ghr_next_temp = {ghr_next_temp[5:0], predict_taken}; //shift and insert prediction
        end
    end


    // Sequential Logic (Clocked)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= {HISTORY_WIDTH{1'b0}};
            for (integer i = 0; i < PHT_ENTRIES; i = i + 1) begin
                pht[i] <= 2'b01; // Initialize counters (e.g., strongly taken).
            end
        end else begin
            ghr <= ghr_next_temp;
            if (train_valid) begin
              pht[pht_index_reg] <= pht_next;
            end
        end
    end
endmodule