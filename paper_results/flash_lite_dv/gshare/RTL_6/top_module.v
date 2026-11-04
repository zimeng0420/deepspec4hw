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

    // Internal Signals
    reg [6:0] ghr;
    reg [1:0] pht [0:PHT_SIZE-1];
    reg [6:0] pht_index;
    reg [1:0] pht_read_data;
    wire [6:0] index;
    wire [1:0] pht_write_data;
    wire ghr_update_taken;
    wire ghr_update_mispredicted;
    wire [6:0] ghr_next;
    reg [6:0] ghr_out;


    // Index Calculation
    always @(*) begin
        if (train_valid) begin
            index = train_pc ^ train_history;
        end else begin
            index = predict_pc ^ ghr;
        end
    end


    // PHT Read
    always @(*) begin
        if (predict_valid) begin
            pht_index = index;
        end
    end
    
    always @(*) begin
        pht_read_data = pht[pht_index];
    end
    
    // Prediction Generation
    always @(*) begin
        if (predict_valid) begin
            predict_taken = pht_read_data[COUNTER_WIDTH-1];
        end
    end
    
    // Output the GHR for prediction
    always @(*) begin
        if (predict_valid) begin
            predict_history = ghr;
        end
    end

    // Saturating Counter Update Logic
    always @(*) begin
        if (train_valid) begin
          if (train_taken) begin
                if (pht[index] < 3) begin
                    pht_write_data = pht[index] + 1'b1;
                end else begin
                    pht_write_data = pht[index];
                end
          end else begin
                if (pht[index] > 0) begin
                    pht_write_data = pht[index] - 1'b1;
                end else begin
                    pht_write_data = pht[index];
                end
          end
        end else begin
            pht_write_data = pht[index];
        end
    end

    // GHR Update Logic
    always @(*) begin
        if (train_valid) begin
            ghr_out = train_history;
            if (train_mispredicted) begin
                ghr_out = train_history;
            end else begin
                ghr_out = {ghr[5:0], train_taken};
            end
        end
        else begin
           ghr_out = {ghr[5:0], predict_taken};
        end
    end

    // GHR Update on Clock Edge
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else if (train_valid) begin
            if (train_mispredicted) begin
                ghr <= train_history;
            end else begin
                ghr <= {ghr[5:0], train_taken};
            end
        end
        else if (predict_valid) begin
            ghr <= {ghr[5:0], predict_taken};
        end
    end

    // PHT Update on Clock Edge
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
          for (i = 0; i < PHT_SIZE; i = i + 1) begin
            pht[i] <= 2'b00;
          end
        end else if (train_valid) begin
            pht[index] <= pht_write_data;
        end
    end

endmodule