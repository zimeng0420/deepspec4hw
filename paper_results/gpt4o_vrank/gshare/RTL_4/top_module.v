module top_module(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // Pattern History Table (PHT)
    reg [1:0] PHT [0:127];

    // Global history register
    reg [6:0] global_history;

    // Internal signals
    wire [6:0] predict_index, train_index;
    reg [6:0] next_global_history;
    reg [1:0] predict_counter, train_counter;

    assign predict_index = predict_pc ^ global_history;
    assign train_index = train_pc ^ train_history;

    assign predict_history = global_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
        end else begin
            if (train_valid && train_mispredicted) begin
                global_history <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                global_history <= next_global_history;
            end
        end
    end

    // Predictor logic
    always @(*) begin
        predict_counter = PHT[predict_index];
        next_global_history = {global_history[5:0], predict_counter[1]};
    end

    assign predict_taken = predict_counter[1];

    // Training logic
    always @(posedge clk) begin
        if (train_valid) begin
            train_counter = PHT[train_index];

            if (train_taken) begin
                if (train_counter != 2'b11) begin
                    PHT[train_index] <= train_counter + 1;
                end
            end else begin
                if (train_counter != 2'b00) begin
                    PHT[train_index] <= train_counter - 1;
                end
            end
        end
    end

endmodule