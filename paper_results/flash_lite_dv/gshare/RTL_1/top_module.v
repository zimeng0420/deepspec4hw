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
    reg [6:0] ghr;

    // Pattern History Table (PHT)
    reg [1:0] pht [0:127];

    // Internal Signals
    wire [6:0] predict_index;
    wire [6:0] train_index;
    wire [1:0] pht_read_data;
    wire [1:0] pht_write_data;
    wire [1:0] pht_entry_out;
    wire ghr_next;
    wire [6:0] ghr_next_value;

    // Index Calculation
    assign predict_index = predict_pc ^ ghr;
    assign train_index = train_pc ^ (train_valid ? train_history : ghr);

    // PHT Read Logic
    assign pht_entry_out = (predict_valid) ? pht[predict_index] : pht_read_data;


    // PHT Write Data Calculation (Saturating Counter)
    always @(*) begin
        if (train_valid) begin
            case (pht[train_index])
                2'b00: pht_write_data = train_taken ? 2'b01 : 2'b00;
                2'b01: pht_write_data = train_taken ? 2'b10 : 2'b00;
                2'b10: pht_write_data = train_taken ? 2'b11 : 2'b01;
                2'b11: pht_write_data = train_taken ? 2'b11 : 2'b10;
                default: pht_write_data = 2'b00;
            endcase
        end
        else begin
            pht_write_data = pht[train_index]; //keep current data
        end
    end


    // Prediction Logic
    always @(*) begin
        predict_taken = pht_entry_out[1]; // MSB determines prediction
        predict_history = ghr;

    end


    // GHR Update Logic
    always @(*) begin
        ghr_next_value = {ghr[5:0], (train_valid && !train_mispredicted) ? train_taken : (predict_valid ? ghr[6] : ghr[6])};

    end


    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b00;
            end
        end else begin
            if (train_valid && train_mispredicted) begin
              ghr <= train_history;
            end
            else if(train_valid && !train_mispredicted) begin
              ghr <= ghr_next_value;
            end
            else if(predict_valid) begin
              ghr <= ghr_next_value;
            end
        end
    end

    // PHT Update Logic
    always @(posedge clk or posedge areset) begin
        if (!areset && train_valid) begin
            pht[train_index] <= pht_write_data;
        end
    end

endmodule