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

    wire [6:0] predict_index;
    wire [6:0] train_index;

    assign predict_index = predict_pc ^ global_history;
    assign train_index = train_pc ^ train_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b11;
            end
        end else begin
            if (train_valid) begin
                case (train_taken)
                    1'b1: begin
                        case (pht[train_index])
                            2'b00: pht[train_index] <= 2'b01;
                            2'b01: pht[train_index] <= 2'b10;
                            2'b10: pht[train_index] <= 2'b11;
                            2'b11: pht[train_index] <= 2'b11;
                        endcase
                    end
                    1'b0: begin
                        case (pht[train_index])
                            2'b00: pht[train_index] <= 2'b00;
                            2'b01: pht[train_index] <= 2'b00;
                            2'b10: pht[train_index] <= 2'b01;
                            2'b11: pht[train_index] <= 2'b10;
                        endcase
                    end
                endcase

                if (train_mispredicted) begin
                    global_history <= train_history;
                end
            end else if (predict_valid) begin
              case (pht[predict_index])
                  2'b00: global_history <= {global_history[5:0], 1'b0};
                  2'b01: global_history <= {global_history[5:0], 1'b0};
                  2'b10: global_history <= {global_history[5:0], 1'b1};
                  2'b11: global_history <= {global_history[5:0], 1'b1};
              endcase
            end
        end
    end

    always @(*) begin
        if (predict_valid) begin
            predict_history = global_history;
            case (pht[predict_index])
                2'b00: predict_taken = 1'b0;
                2'b01: predict_taken = 1'b0;
                2'b10: predict_taken = 1'b1;
                2'b11: predict_taken = 1'b1;
            endcase
        end else begin
            predict_taken = 1'b0;
            predict_history = 7'b0;
        end
    end

endmodule