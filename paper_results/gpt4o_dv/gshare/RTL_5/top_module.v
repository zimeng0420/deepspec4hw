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

    reg [1:0] PHT [0:127]; // 128-entry table of 2-bit saturating counters
    reg [6:0] GHR; // Global History Register

    integer i;
    initial begin
        for (i = 0; i < 128; i = i + 1) begin
            PHT[i] = 2'b01; // Initialize counters to weakly not taken
        end
    end

    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [6:0] train_index = train_pc ^ train_history;

    always @(*) begin
        if (predict_valid) begin
            predict_taken = (PHT[predict_index] >= 2'b10);
            predict_history = GHR;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
        end else if (train_valid) begin
            // Update global history register
            if (train_mispredicted) begin
                GHR <= {train_history[5:0], train_taken}; // Recover to state after mispredicted branch
            end else begin
                GHR <= {GHR[5:0], train_taken}; // Normal history update
            end

            // Update PHT
            if (train_taken) begin
                if (PHT[train_index] != 2'b11) begin
                    PHT[train_index] <= PHT[train_index] + 2'b01;
                end
            end else begin
                if (PHT[train_index] != 2'b00) begin
                    PHT[train_index] <= PHT[train_index] - 2'b01;
                end
            end
        end else if (predict_valid && !train_valid) begin
            // Update global history register for prediction only if training does not take precedence
            GHR <= {GHR[5:0], predict_taken};
        end
    end

endmodule