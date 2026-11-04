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
    reg [1:0] PHT [0:127];  // 128-entry table of 2-bit saturating counters

    // XOR pc and global history to generate index
    wire [6:0] predict_index = predict_pc ^ global_history;
    wire [6:0] train_index = train_pc ^ train_history;

    // Process prediction
    always @(*) begin
        if (predict_valid) begin
            predict_history = global_history;
            case (PHT[predict_index])
                2'b00, 2'b01: predict_taken = 0;
                2'b10, 2'b11: predict_taken = 1;
                default: predict_taken = 0;
            endcase
        end
        else begin
            predict_taken = 0;
            predict_history = global_history;
        end
    end

    // Process training
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;  // Weakly not taken
            end
        end
        else if (train_valid) begin
            // Update PHT
            if (train_taken) begin
                if (PHT[train_index] < 2'b11)
                    PHT[train_index] <= PHT[train_index] + 1;
            end
            else begin
                if (PHT[train_index] > 2'b00)
                    PHT[train_index] <= PHT[train_index] - 1;
            end

            // Update global history
            if (train_mispredicted) begin
                global_history <= {train_history[5:0], train_taken};
            end
            else begin
                global_history <= {global_history[5:0], predict_taken};
            end
        end
        else if (predict_valid && !train_valid) begin
            global_history <= {global_history[5:0], predict_taken};
        end
    end
endmodule