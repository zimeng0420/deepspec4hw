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

    reg [6:0] global_history;
    reg [1:0] pattern_history_table [0:127]; // 128-entry PHT with 2-bit counters

    wire [6:0] predict_index = predict_pc ^ global_history;
    wire [6:0] train_index = train_pc ^ train_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                pattern_history_table[i] <= 2'b01; // Weakly taken state
            end
        end
        else begin
            // Prediction logic
            if (predict_valid) begin
                predict_taken = pattern_history_table[predict_index][1]; // MSB is the prediction
                predict_history = global_history;
                if (!train_valid || (train_valid && !train_mispredicted)) begin
                    global_history <= {global_history[5:0], predict_taken};
                end
            end

            // Training logic
            if (train_valid) begin
                case (pattern_history_table[train_index])
                    2'b00: pattern_history_table[train_index] <= (train_taken ? 2'b01 : 2'b00);
                    2'b01: pattern_history_table[train_index] <= (train_taken ? 2'b10 : 2'b00);
                    2'b10: pattern_history_table[train_index] <= (train_taken ? 2'b11 : 2'b01);
                    2'b11: pattern_history_table[train_index] <= (train_taken ? 2'b11 : 2'b10);
                endcase

                if (train_mispredicted) begin
                    global_history <= {train_history[5:0], train_taken};
                end
                // Else, global_history updates as per predict_valid if !train_mispredicted
            end
        end
    end
endmodule