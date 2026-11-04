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

    reg [1:0] PHT[127:0]; // Pattern History Table (PHT) - 128 entries of 2-bit saturating counters
    reg [6:0] BHR;          // Global Branch History Register

    wire [6:0] index;       // PHT index
    wire [6:0] history_out; // History output for prediction
    wire update_BHR;        // Flag to update BHR 

    assign index = (predict_pc ^ BHR) & 7'b0111111; // XORing PC and BHR for index

    always @(*) begin
        if (predict_valid) begin
            predict_taken = (PHT[index] > 1); // 2-bit saturating counter interpretation
            predict_history = BHR; // Current BHR for prediction
        end else begin
            predict_taken = 0;
            predict_history = BHR;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            BHR <= 7'b0; // Reset BHR
            PHT[0] <= 2'b00; // Initializing PHT; can expand based on need
            // Note: PHT should be initialized, consider loop for all entries if needed
            integer i;
            for (i = 1; i < 128; i = i + 1) begin
                PHT[i] <= 2'b00;
            end
        end else begin
            if (train_valid) begin
                if (train_mispredicted) begin
                    // Recovering BHR to the state before misprediction
                    BHR <= train_history; 
                end else begin
                    // Update BHR with predicted direction
                    BHR <= {BHR[5:0], predict_taken}; 
                end

                // Update PHT based on actual outcome
                case (PHT[index])
                    2'b00: if (train_taken) PHT[index] <= 2'b01;
                    2'b01: if (train_taken) PHT[index] <= 2'b10; else PHT[index] <= 2'b00;
                    2'b10: if (train_taken) PHT[index] <= 2'b11; else PHT[index] <= 2'b01;
                    2'b11: if (!train_taken) PHT[index] <= 2'b10;
                endcase
            end else if (predict_valid) begin
                // The prediction output is already being computed in the combinational block
                // BHR will be updated with predicted taken direction, but this happens in next clk cycle
                BHR <= {BHR[5:0], predict_taken};
            end
        end
    end
endmodule