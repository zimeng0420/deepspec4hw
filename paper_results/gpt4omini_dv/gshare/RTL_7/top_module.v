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

    reg [6:0] GHR; // Global History Register
    reg [1:0] PHT[127:0]; // Pattern History Table with 128 entries of 2-bit saturating counters

    wire [6:0] index; // XORed index for PHT
    wire [1:0] counter; // Counter value from PHT

    assign index = predict_pc ^ GHR; // Index calculation using XOR

    // Prediction logic
    always @(*) begin
        if (predict_valid) begin
            counter = PHT[index]; // Read the counter value
            predict_taken = (counter[1] == 1'b1); // Predict taken if MSB of counter is 1
            predict_history = GHR; // Output the current GHR
        end
    end

    // Training logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0; // Reset GHR
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b00; // Reset PHT entries
            end
        end else begin
            // Update GHR and PHT based on training
            if (train_valid) begin
                GHR <= train_history; // Update GHR with training history
                if (train_mispredicted) begin
                    GHR <= GHR >> 1; // Restore GHR if mispredicted
                end

                // Update PHT
                case (PHT[index])
                    2'b00: PHT[index] <= (train_taken) ? 2'b01 : 2'b00; // Strongly Not Taken
                    2'b01: PHT[index] <= (train_taken) ? 2'b10 : 2'b00; // Weakly Not Taken
                    2'b10: PHT[index] <= (train_taken) ? 2'b11 : 2'b01; // Weakly Taken
                    2'b11: PHT[index] <= (train_taken) ? 2'b11 : 2'b10; // Strongly Taken
                endcase
            end
            
            // Prediction update occurs simultaneously if needed
            if (predict_valid) begin
                // Prediction logic is already handled in combinational always block
            end
        end
    end

endmodule