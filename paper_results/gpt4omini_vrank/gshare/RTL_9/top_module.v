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

reg [1:0] PHT [127:0];
reg [6:0] GHR;
wire [6:0] index;
reg [1:0] curr_state;

assign index = (predict_pc ^ GHR) [6:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        GHR <= 7'b0;
        for (int i = 0; i < 128; i = i + 1) begin
            PHT[i] <= 2'b00;
        end
    end else begin
        // Handle predictions
        if (predict_valid) begin
            predict_taken <= PHT[index][1]; // Take the 2nd bit for prediction
            predict_history <= GHR;
            GHR <= {GHR[5:0], predict_taken}; // Update GHR with predicted taken
        end
        
        // Handle training
        if (train_valid) begin
            if (train_mispredicted) begin
                GHR <= train_history; // Restore GHR for mispredicted branches
            end
            
            // Update PHT
            case (PHT[index])
                2'b00: PHT[index] <= train_taken ? 2'b01 : 2'b00;
                2'b01: PHT[index] <= train_taken ? 2'b10 : 2'b00;
                2'b10: PHT[index] <= train_taken ? 2'b11 : 2'b01;
                2'b11: PHT[index] <= train_taken ? 2'b11 : 2'b10;
            endcase
        end
    end
end

endmodule