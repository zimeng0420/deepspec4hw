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
  reg [1:0] pht [127:0];  // Pattern History Table (128 entries, 2-bit counters)

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'b0;
      for (integer i = 0; i < 128; i = i + 1) begin
        pht[i] <= 2'b11;  // Initialize to strongly taken
      end
    end else begin
      if (train_valid) begin
        // Training takes precedence
        
        // Calculate the PHT index
        reg [6:0] train_index;
        train_index = train_pc ^ train_history;
        
        // Update the PHT entry
        case (pht[train_index])
          2'b00: pht[train_index] <= train_taken ? 2'b01 : 2'b00;
          2'b01: pht[train_index] <= train_taken ? 2'b10 : 2'b00;
          2'b10: pht[train_index] <= train_taken ? 2'b11 : 2'b01;
          2'b11: pht[train_index] <= train_taken ? 2'b11 : 2'b10;
        endcase

        //Recover history register if mispredicted
        if (train_mispredicted)
            global_history <= train_history;

      end else if (predict_valid) begin
          //Update global history after prediction
        global_history <= {global_history[5:0], predict_taken};
      end
    end
  end
  
  always @(*) begin
    if(predict_valid) begin
      // Calculate the PHT index
      reg [6:0] predict_index;
      predict_index = predict_pc ^ global_history;

      // Make the prediction
      predict_taken = (pht[predict_index] >= 2'b10);
      predict_history = global_history;
    end else begin
      predict_taken = 1'b0; //Default Value
      predict_history = 7'b0; //Default Value
    end
  end

endmodule