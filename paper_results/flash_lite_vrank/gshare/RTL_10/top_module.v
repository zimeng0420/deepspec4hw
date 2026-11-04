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

  // Parameters
  localparam HISTORY_WIDTH = 7;
  localparam PC_WIDTH = 7;
  localparam PHT_INDEX_WIDTH = 7;
  localparam PHT_ENTRIES = 128;  // 2**7 = 128
  localparam COUNTER_WIDTH = 2;

  // Internal signals
  reg [HISTORY_WIDTH-1:0] global_history;
  reg [COUNTER_WIDTH-1:0] pht [0:PHT_ENTRIES-1]; // Pattern History Table
  reg [HISTORY_WIDTH-1:0] predict_history_reg;
  reg predict_taken_reg;


  // Helper functions
  function [PHT_INDEX_WIDTH-1:0] hash;
    input [PC_WIDTH-1:0] pc;
    input [HISTORY_WIDTH-1:0] history;
    begin
      hash = pc ^ history;
    end
  endfunction


  // Prediction Logic
  always @(*) begin
    predict_history_reg = global_history;
    predict_taken_reg = 1'b0; // Default: not taken

    if (predict_valid) begin
      predict_taken_reg = (pht[hash(predict_pc, global_history)] [COUNTER_WIDTH-1]) ; // MSB is taken bit
      predict_history_reg = global_history;
    end
  end


  // Training Logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= {HISTORY_WIDTH{1'b0}};
      for (integer i = 0; i < PHT_ENTRIES; i = i + 1) begin
        pht[i] <= {COUNTER_WIDTH{1'b0}}; // Initialize all counters to strongly not taken
      end
    end else begin
      // Update global history
      if (train_valid) begin
          global_history <= {global_history[HISTORY_WIDTH-2:0], train_taken};
      end
      
      if(predict_valid && train_valid && (hash(train_pc, train_history) == hash(predict_pc, predict_history_reg))  ) begin // Check if training and prediction access the same PHT entry
      // PHT update is based on training
      if(train_valid) begin
            // Update PHT
            case(pht[hash(train_pc, train_history)])
                2'b00: pht[hash(train_pc, train_history)] <= train_taken ? 2'b01 : 2'b00;
                2'b01: pht[hash(train_pc, train_history)] <= train_taken ? 2'b10 : 2'b00;
                2'b10: pht[hash(train_pc, train_history)] <= train_taken ? 2'b11 : 2'b01;
                2'b11: pht[hash(train_pc, train_history)] <= train_taken ? 2'b11 : 2'b10;
            endcase
      end
      end else if (train_valid) begin
        // Update PHT
        case(pht[hash(train_pc, train_history)])
            2'b00: pht[hash(train_pc, train_history)] <= train_taken ? 2'b01 : 2'b00;
            2'b01: pht[hash(train_pc, train_history)] <= train_taken ? 2'b10 : 2'b00;
            2'b10: pht[hash(train_pc, train_history)] <= train_taken ? 2'b11 : 2'b01;
            2'b11: pht[hash(train_pc, train_history)] <= train_taken ? 2'b11 : 2'b10;
        endcase
      end
      
      
      if(train_valid && train_mispredicted) begin //Recover mispredicted branch history
          global_history <= train_history;
      end
    end
  end


  // Outputs
  assign predict_taken = predict_taken_reg;
  assign predict_history = predict_history_reg;

endmodule