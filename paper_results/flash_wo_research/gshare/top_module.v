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

    reg [6:0] history_register;
    reg [1:0] pht [127:0];

    // Prediction logic
    wire [6:0] predict_index = predict_pc ^ history_register;
    wire [1:0] pht_value = pht[predict_index];

    always @(*) begin
        predict_taken = (pht_value >= 2'b10);
        predict_history = history_register;
    end

    // Training logic
    wire [6:0] train_index = train_pc ^ train_history;

    always @(posedge clk) begin
        if (areset) begin
            history_register <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b10; // Initialize to weakly taken
            end
        end else begin
            // Training update
            if (train_valid) begin
                if (train_taken) begin
                    if (pht[train_index] < 2'b11) begin
                        pht[train_index] <= pht[train_index] + 2'b01;
                    end
                end else begin
                    if (pht[train_index] > 2'b00) begin
                        pht[train_index] <= pht[train_index] - 2'b01;
                    end
                end
            end

            // History update
            if (predict_valid) begin
                if (train_valid && train_mispredicted) begin
                    // Training takes precedence if mispredicted
                    history_register <= train_history;
                    if (train_taken) begin
                        history_register <= {history_register[5:0], 1'b1};
                    end else begin
                        history_register <= {history_register[5:0], 1'b0};
                    end
                end else begin
                    // Normal prediction update
                    if (predict_taken) begin
                        history_register <= {history_register[5:0], 1'b1};
                    end else begin
                        history_register <= {history_register[5:0], 1'b0};
                    end
                end
            end
        end
    end

endmodule