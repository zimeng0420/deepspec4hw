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
        pht[i] <= 2'b00;
      end
    end else begin
      if (train_valid) begin
        // Training takes precedence over prediction
        global_history <= train_history;
        
        // Update PHT
        integer index = train_pc ^ train_history;
        
        if (train_taken) begin
            if (pht[index] < 2'b11)
                pht[index] <= pht[index] + 1'b1;
        } else begin
            if (pht[index] > 2'b00)
                pht[index] <= pht[index] - 1'b1;
        end
      end else if (predict_valid) begin
        // Update global history based on prediction
        predict_history <= global_history; // Output the current global history
                
        integer index = predict_pc ^ global_history;
        
        predict_taken <= (pht[index] >= 2'b10);
        
        global_history <= {global_history[5:0], predict_taken};
      end
    end
  end
endmodule