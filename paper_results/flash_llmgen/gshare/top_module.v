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
  reg [6:0] ghbr;        // Global Branch History Register
  wire [6:0] predict_index;
  wire [6:0] train_index;
  wire [1:0] pht_data_out;

  // Calculate PHT index for prediction
  assign predict_index = predict_pc ^ ghbr;

  // Calculate PHT index for training
  assign train_index = train_pc ^ train_history;

  // Read PHT data for prediction
  assign pht_data_out = pht[predict_index];

  // Prediction Logic
  always @(*) begin
    predict_history = ghbr; // Output current GBHR value
    predict_taken = (pht_data_out >= 2'b10); // Predict taken if counter >= 2
  end

  always @(posedge clk) begin
    if (areset) begin
      ghbr <= 7'b0;
      for (integer i = 0; i < 128; i = i + 1) begin
        pht[i] <= 2'b00; // Initialize to strongly not taken
      end
    end else begin
      // Training takes precedence
      if (train_valid) begin
        if (train_mispredicted) begin
          ghbr <= train_history; // Recover GBHR
        end else begin
          ghbr <= {ghbr[5:0], train_taken};
        end

        // Update PHT
        if (train_taken) begin
          if (pht[train_index] < 2'b11) begin
            pht[train_index] <= pht[train_index] + 2'b01; // Increment, saturate at 3
          end
        end else begin
          if (pht[train_index] > 2'b00) begin
            pht[train_index] <= pht[train_index] - 2'b01; // Decrement, saturate at 0
          end
        end
      end else if (predict_valid) begin
        // Update GBHR based on prediction
        ghbr <= {ghbr[5:0], predict_taken};
      end
    end
  end

endmodule