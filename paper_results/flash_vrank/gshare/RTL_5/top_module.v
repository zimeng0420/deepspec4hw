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

  reg [6:0] global_history;
  reg [1:0] pht [127:0];

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'b0;
      for (integer i = 0; i < 128; i = i + 1) begin
        pht[i] <= 2'b11; // Strongly taken
      end
    end else begin
      if (train_valid) begin
        // Training takes precedence

        integer index = train_pc ^ train_history;
        index = index[6:0]; // Ensure 7-bit index
        
        if (train_taken) begin
          if (pht[index] < 2'b11) begin
            pht[index] <= pht[index] + 1;
          end
        end else begin
          if (pht[index] > 2'b00) begin
            pht[index] <= pht[index] - 1;
          end
        end

        if (train_mispredicted) begin
          global_history <= train_history;
        end

      end else if (predict_valid) begin
        // Update global history with the predicted taken/not taken.
        integer index = predict_pc ^ global_history;
        index = index[6:0]; // Ensure 7-bit index

        if (pht[index] >= 2'b10) begin
          global_history <= {global_history[5:0], 1'b1};
        end else begin
          global_history <= {global_history[5:0], 1'b0};
        end
      end
    end
  end

  always @(*) begin
    if (predict_valid) begin
      integer index = predict_pc ^ global_history;
      index = index[6:0]; // Ensure 7-bit index

      predict_history = global_history;

      if (pht[index] >= 2'b10) begin
        predict_taken = 1'b1;
      end else begin
        predict_taken = 1'b0;
      end
    end else begin
      predict_taken = 1'b0; //default value when not predicting
	  predict_history = 7'bx; //Default
    end
  end

endmodule