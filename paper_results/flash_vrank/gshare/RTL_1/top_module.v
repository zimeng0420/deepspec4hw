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
    reg [1:0] pht [127:0];

    wire [6:0] index_predict;
    wire [6:0] index_train;

    assign index_predict = predict_pc ^ global_history;
    assign index_train = train_pc ^ train_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b11;
            end
        end else begin
            if (train_valid) begin
                // Training takes precedence over prediction

                // Update PHT
                case (train_taken)
                    1'b1: begin
                        if (pht[index_train] < 2'b11) begin
                            pht[index_train] <= pht[index_train] + 1;
                        end
                    end
                    1'b0: begin
                        if (pht[index_train] > 2'b00) begin
                            pht[index_train] <= pht[index_train] - 1;
                        end
                    end
                endcase

                // Recover global history if mispredicted
                if (train_mispredicted) begin
                    global_history <= train_history;
                end
            end else if (predict_valid) begin
                // Update global history based on prediction
                global_history <= {global_history[5:0], predict_taken};
            end
        end
    end

    always @(*) begin
        predict_taken = (pht[index_predict] [1] == 1'b1);
        predict_history = global_history;
    end

endmodule