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

    reg [1:0] PHT [127:0]; // 128-entry table of 2-bit saturating counters
    reg [6:0] GHR;         // Global history register

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset
            GHR <= 7'b0;
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= 2'b01; // Initialize to weakly not taken
        end else begin
            // Update on clock edge
            if (train_valid) begin
                // Training logic
                integer idx = train_pc ^ train_history;

                if (train_taken) begin
                    if (PHT[idx] < 2'b11)
                        PHT[idx] <= PHT[idx] + 1;
                end else begin
                    if (PHT[idx] > 2'b00)
                        PHT[idx] <= PHT[idx] - 1;
                end

                if (train_mispredicted) begin
                    // Recover GHR to the state after mispredicted branch
                    GHR <= {GHR[5:0], train_taken};
                end else begin
                    // Normal GHR update
                    GHR <= {GHR[5:0], train_taken};
                end
            end
        end
    end

    always @(*) begin
        if (predict_valid) begin
            // Prediction logic
            integer predict_idx = predict_pc ^ GHR;
            predict_taken = PHT[predict_idx] >= 2'b10; // Taken if counter is 2 or 3
            predict_history = GHR; // Output current history state
        end
    end

endmodule