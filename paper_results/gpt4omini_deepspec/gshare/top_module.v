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
    reg [1:0] PHT[127:0]; // Pattern History Table (PHT) with 128 two-bit saturating counters

    wire [6:0] index;
    wire [1:0] counter_value;

    // XOR logic to calculate the index
    assign index = predict_pc ^ GHR;

    // Reading the PHT value
    assign counter_value = PHT[index];

    // Prediction logic
    always @(*) begin
        if (predict_valid) begin
            predict_taken = (counter_value[1] == 1'b1); // Strongly Taken or Weakly Taken
            predict_history = GHR; // Current history
        end
    end

    // Training logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b00; // Initialize PHT to Strongly Not Taken
            end
        end else begin
            // Handle training
            if (train_valid) begin
                if (train_mispredicted) begin
                    GHR <= train_history; // Recover GHR on misprediction
                end else begin
                    GHR <= {GHR[6:1], train_taken}; // Update GHR
                end

                // Update the PHT entry
                case (PHT[index])
                    2'b00: PHT[index] <= train_taken ? 2'b01 : 2'b00;
                    2'b01: PHT[index] <= train_taken ? 2'b10 : 2'b00;
                    2'b10: PHT[index] <= train_taken ? 2'b11 : 2'b01;
                    2'b11: PHT[index] <= train_taken ? 2'b11 : 2'b10;
                endcase
            end

            // Handle prediction on valid signal
            if (predict_valid) begin
                // The prediction is already performed at the combinational logic level
            end
        end
    end
endmodule