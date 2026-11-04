module top_module(
    input clk,
    input areset, 

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken, 
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history, 
    input [6:0] train_pc
);

    // Table and registers declaration
    reg [1:0] PHT [0:127];    // 128-entry table of two-bit saturating counters
    reg [6:0] GBR;            // Global Branch History Register
    wire [6:0] index;

    // XOR to create the index for PHT
    assign index = predict_pc ^ GBR;

    // Output the prediction taken based on predict_valid
    assign predict_taken = predict_valid ? PHT[index][1] : 1'b0;

    // Output the current global branch history
    assign predict_history = GBR;

    // Update logic for the PHT on the posedge clk when train_valid is high
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GBR <= 7'b0;
        end else begin
            if (train_valid) begin
                // Recover the branch history register if mispredicted
                if (train_mispredicted) begin
                    GBR <= {train_history[5:0], train_taken}; // Updated history after the branch
                end else begin
                    GBR <= {GBR[5:0], train_taken}; // Update GBR for next branch prediction
                end

                // Update PHT
                case ({train_taken, PHT[train_pc ^ train_history]})
                    3'b000: PHT[train_pc ^ train_history] <= 2'b01; // Weak not taken
                    3'b001: PHT[train_pc ^ train_history] <= 2'b00; // Strong not taken
                    3'b010: PHT[train_pc ^ train_history] <= 2'b11; // Strong taken
                    3'b011: PHT[train_pc ^ train_history] <= 2'b10; // Weak taken
                    3'b100: PHT[train_pc ^ train_history] <= 2'b01; // Weak not taken
                    3'b101: PHT[train_pc ^ train_history] <= 2'b00; // Strong not taken
                    3'b110: PHT[train_pc ^ train_history] <= 2'b11; // Strong taken
                    3'b111: PHT[train_pc ^ train_history] <= 2'b10; // Weak taken
                endcase
            end else if (predict_valid) begin
                GBR <= {GBR[5:0], predict_taken};  // Update GBR with the prediction
            end
        end
    end

endmodule