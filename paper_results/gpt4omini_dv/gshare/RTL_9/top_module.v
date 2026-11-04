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
    reg [6:0] GHR;
    reg [1:0] PHT[127:0];
    wire [6:0] index;
    wire [1:0] counter_value;

    // Calculate index by XORing PC and GHR
    assign index = predict_pc ^ GHR;
    assign counter_value = PHT[index];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset
            GHR <= 7'b0;
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b00; // Reset PHT to strongly not taken
            end
        end else begin
            // Prediction Logic
            if (predict_valid) begin
                predict_taken <= (counter_value[1] == 1'b1); // Taken if counter value is 10 or 11
                predict_history <= GHR; // Output current state of GHR
            end
            
            // Training Logic
            if (train_valid) begin
                if (train_mispredicted) begin
                    GHR <= train_history; // Restore GHR if mispredicted
                end else begin
                    GHR <= {GHR[6:1], train_taken}; // Shift GHR and insert new branch outcome
                end
                
                // Update PHT based on the actual branch outcome
                case (PHT[index])
                    2'b00: PHT[index] <= (train_taken ? 2'b01 : 2'b00); // Strongly Not Taken
                    2'b01: PHT[index] <= (train_taken ? 2'b10 : 2'b00); // Weakly Not Taken
                    2'b10: PHT[index] <= (train_taken ? 2'b11 : 2'b01); // Weakly Taken
                    2'b11: PHT[index] <= (train_taken ? 2'b11 : 2'b10); // Strongly Taken
                endcase
            end
            
            // Update GHR for prediction
            if (predict_valid && !train_valid) begin
                GHR <= {GHR[6:1], counter_value[1]}; // Update GHR with prediction
            end
        end
    end
endmodule