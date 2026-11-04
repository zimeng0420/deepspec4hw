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
    reg [1:0] PHT [127:0];
    wire [6:0] index;
    wire [1:0] counter_state;

    // Calculate index using XOR
    assign index = predict_pc ^ GHR;

    // Output prediction based on PHT
    always @(*) begin
        predict_taken = (PHT[index] >= 2'b10) ? 1'b1 : 1'b0; // Taken if counter state is 10 or 11
        predict_history = GHR;
    end

    // Training Logic and GHR update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            // Reset PHT entries
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b00;
            end
        end else begin
            // Training takes precedence
            if (train_valid) begin
                if (train_mispredicted) begin
                    GHR <= train_history; // Restore GHR on misprediction
                end else begin
                    GHR <= {GHR[5:0], train_taken}; // Update GHR
                end
                // Update the PHT based on train_taken
                case (PHT[index])
                    2'b00: PHT[index] <= (train_taken) ? 2'b01 : 2'b00;
                    2'b01: PHT[index] <= (train_taken) ? 2'b10 : 2'b00;
                    2'b10: PHT[index] <= (train_taken) ? 2'b11 : 2'b01;
                    2'b11: PHT[index] <= (train_taken) ? 2'b11 : 2'b10;
                endcase
            end else if (predict_valid) begin
                // Prediction would occur here based on GHR and PHT state
                // (handled in combinational logic)
            end
        end
    end

endmodule