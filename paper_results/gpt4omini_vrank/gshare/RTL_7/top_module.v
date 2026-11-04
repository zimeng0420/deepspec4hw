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
    
    reg [1:0] pht [127:0]; // Pattern History Table
    reg [6:0] ghr; // Global History Register

    wire [6:0] index = predict_pc[6:0] ^ ghr; // Hashed index for PHT
    wire [1:0] pht_state = pht[index]; // Current state of PHT

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            // Reset the PHT to weakly not taken
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b00;
            end
        end else begin
            // Prediction Logic
            if (predict_valid) begin
                predict_taken <= (pht_state[1]); // Most significant bit indicates taken
                predict_history <= ghr; // Output current GHR
            end
            
            // Training Logic
            if (train_valid) begin
                if (train_mispredicted) begin
                    ghr <= train_history; // Recover GHR on misprediction
                end else begin
                    ghr <= {ghr[5:0], train_taken}; // Update GHR with the outcome
                end
                
                // Update PHT
                case (pht_state)
                    2'b00: if (train_taken) pht[index] <= 2'b01; // weakly taken
                    2'b01: if (train_taken) pht[index] <= 2'b10; // strongly taken
                    2'b10: if (!train_taken) pht[index] <= 2'b01; // weakly taken
                    2'b11: if (!train_taken) pht[index] <= 2'b10; // strongly taken to weakly taken
                endcase
            end
        end
    end

endmodule