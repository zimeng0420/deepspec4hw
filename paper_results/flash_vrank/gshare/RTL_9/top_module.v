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
  reg [1:0] PHT [127:0]; // 128-entry table of 2-bit saturating counters

  // Asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'b0;
      for (integer i = 0; i < 128; i = i + 1) begin
        PHT[i] <= 2'b00;
      end
    end else begin
      if (train_valid && train_mispredicted) begin
        global_history <= train_history;
      end else if (predict_valid) begin
        global_history <= {global_history[5:0], predict_taken};
      end
    end
  end

  // Prediction logic
  always @(*) begin
    integer index;
    index = predict_pc ^ global_history; // XOR hashing
    predict_history = global_history;

    if (PHT[index] >= 2'b10) begin
      predict_taken = 1'b1;
    end else begin
      predict_taken = 1'b0;
    end
  end

  // Training logic
  always @(posedge clk) begin
    if (train_valid) begin
      integer index;
      index = train_pc ^ train_history;
      case (PHT[index])
        2'b00: PHT[index] <= train_taken ? 2'b01 : 2'b00;
        2'b01: PHT[index] <= train_taken ? 2'b10 : 2'b00;
        2'b10: PHT[index] <= train_taken ? 2'b11 : 2'b01;
        2'b11: PHT[index] <= train_taken ? 2'b11 : 2'b10;
      endcase
    end
  end

endmodule