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

    reg [6:0] ghr; // Global History Register
    reg [1:0] PHT [0:127]; // 128-entry PHT, each entry is a 2-bit counter
    reg [1:0] predict_counter;

    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    integer i;

    // Asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01; // Initialize counters to weakly not taken (01)
            end
        end
    end

    // Prediction
    always @(*) begin
        if (predict_valid) begin
            predict_counter = PHT[predict_index];
            predict_taken = (predict_counter[1] == 1'b1); // 10 or 11 means taken
        end
    end

    // Output the current state of global history register used for prediction
    always @(posedge clk) begin
        if (predict_valid) begin
            predict_history <= ghr;
            ghr <= {ghr[5:0], predict_taken}; // Update GHR based on prediction
        end
    end

    // Training and PHT Update
    always @(posedge clk) begin
        if (train_valid) begin
            // Update the PHT based on the actual outcome
            if (train_taken) begin
                PHT[train_index] <= (PHT[train_index] != 2'b11) ? PHT[train_index] + 2'b01 : PHT[train_index];
            end else begin
                PHT[train_index] <= (PHT[train_index] != 2'b00) ? PHT[train_index] - 2'b01 : PHT[train_index];
            end

            // Update or recover the Global History Register
            if (train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken}; // Recover GHR on misprediction
            end else begin
                ghr <= {ghr[5:0], train_taken}; // Normal GHR update
            end
        end
    end
endmodule