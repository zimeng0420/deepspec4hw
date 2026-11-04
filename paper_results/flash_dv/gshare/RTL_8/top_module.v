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

    reg [1:0] PHT [127:0];
    reg [6:0] global_history;

    // Prediction Logic
    wire [6:0] predict_index;
    assign predict_index = predict_pc ^ global_history;

    always @(*) begin
        if (areset) begin
            predict_taken = 0;
            predict_history = 0;
        end else if (predict_valid) begin
            predict_taken = PHT[predict_index][1];
            predict_history = global_history;
        end else begin
            predict_taken = 0;
            predict_history = 0;
        end
    end

    // Training Logic
    wire [6:0] train_index;
    assign train_index = train_pc ^ train_history;

    always @(posedge clk) begin
        if (areset) begin
            global_history <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b00;
            end
        end else begin
            // Training takes precedence
            if (train_valid) begin
                // Update PHT
                if (train_taken) begin
                    if (PHT[train_index] < 2'b11) begin
                        PHT[train_index] <= PHT[train_index] + 1'b1;
                    end
                end else begin
                    if (PHT[train_index] > 2'b00) begin
                        PHT[train_index] <= PHT[train_index] - 1'b1;
                    end
                end

                // Update global history if mispredicted
                if (train_mispredicted) begin
                    global_history <= train_history;
                end else begin
                    global_history <= {global_history[5:0], train_taken};
                end
            } else if (predict_valid) begin
                // Update global history with *predicted* outcome
                global_history <= {global_history[5:0], predict_taken};
            end
        end
    end

endmodule