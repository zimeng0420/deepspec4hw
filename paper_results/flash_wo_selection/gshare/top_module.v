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

    reg [6:0] history_reg;
    reg [1:0] pht [127:0];

    // Asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01; // Initialize to weakly not-taken
            end
        end else begin
            // Prediction logic (combinational)
            reg predict_taken_temp;
            reg [6:0] predict_history_temp;
            integer index;

            index = predict_pc ^ history_reg;

            predict_taken_temp = pht[index][1];
            predict_history_temp = history_reg;

            if (predict_valid) begin
                predict_taken <= predict_taken_temp;
                predict_history <= predict_history_temp;
            end

            // Training logic (sequential)
            if (train_valid) begin
                integer train_index;
                train_index = train_pc ^ train_history;

                if (train_taken) begin
                    if (pht[train_index] < 2'b11) begin
                        pht[train_index] <= pht[train_index] + 1;
                    end
                end else begin
                    if (pht[train_index] > 2'b00) begin
                        pht[train_index] <= pht[train_index] - 1;
                    end
                end
            end

            // Branch history update
            if (train_valid && train_mispredicted) begin
                history_reg <= train_history;
            end else if (predict_valid) begin
                history_reg <= {history_reg[5:0], predict_taken_temp};
            end
        end
    end

endmodule