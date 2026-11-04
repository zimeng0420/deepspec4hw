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
    // Declare the pattern history table (PHT)
    reg [1:0] PHT [127:0];
    // Global history register
    reg [6:0] GHR;

    // Compute index for prediction
    wire [6:0] predict_index = predict_pc ^ GHR;

    // Compute index for training
    wire [6:0] train_index = train_pc ^ train_history;

    // Asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01; // Initialize to weakly not taken
            end
        end else begin
            // Handle training
            if (train_valid) begin
                // Update the PHT entry
                case ({train_taken, PHT[train_index]})
                    3'b000: PHT[train_index] <= 2'b00;
                    3'b001: PHT[train_index] <= 2'b00;
                    3'b010: PHT[train_index] <= 2'b01;
                    3'b011: PHT[train_index] <= 2'b10;
                    3'b100: PHT[train_index] <= 2'b10;
                    3'b101: PHT[train_index] <= 2'b11;
                    3'b110: PHT[train_index] <= 2'b11;
                    3'b111: PHT[train_index] <= 2'b11;
                endcase
                // Update or recover global history register
                if (train_mispredicted) begin
                    GHR <= train_history;
                end else begin
                    GHR <= {GHR[5:0], train_taken}; // Shift in the result
                end
            end else if (predict_valid) begin
                // Update the global history register with prediction
                GHR <= {GHR[5:0], predict_taken};
            end
        end
    end

    // Combinational logic for prediction
    always @(*) begin
        if (predict_valid) begin
            predict_taken = (PHT[predict_index] >= 2'b10);
            predict_history = GHR;
        end else begin
            predict_taken = 0;
            predict_history = 7'b0;
        end
    end
endmodule