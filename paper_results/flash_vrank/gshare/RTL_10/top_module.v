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

  // Parameters
  localparam PHT_SIZE = 128;
  localparam HISTORY_LENGTH = 7;

  // Internal signals
  reg [HISTORY_LENGTH-1:0] global_history;
  reg [1:0] pattern_history_table [PHT_SIZE-1:0];

  // Prediction Logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 0;
      for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
        pattern_history_table[i] <= 2; // Initialize to weakly taken
      end
    end else begin
      if (predict_valid) begin
        // Calculate index into PHT
        integer index = predict_pc ^ global_history;

        // Assign prediction outputs
        predict_taken <= (pattern_history_table[index[6:0]] >= 2);
        predict_history <= global_history;

        // Update global history (for next cycle) with *predicted* outcome, unless training takes precedence
        if (!train_valid) begin
          global_history <= {global_history[HISTORY_LENGTH-2:0], predict_taken};
        end
      end

      // Training Logic
      if (train_valid) begin
        // Calculate index into PHT
        integer index = train_pc ^ train_history;

        // Update PHT entry
        case (pattern_history_table[index[6:0]])
          2'b00: pattern_history_table[index[6:0]] <= train_taken ? 2'b01 : 2'b00;
          2'b01: pattern_history_table[index[6:0]] <= train_taken ? 2'b10 : 2'b00;
          2'b10: pattern_history_table[index[6:0]] <= train_taken ? 2'b11 : 2'b01;
          2'b11: pattern_history_table[index[6:0]] <= train_taken ? 2'b11 : 2'b10;
          default: pattern_history_table[index[6:0]] <= 2'b10; // Should not happen, but handle anyway
        endcase

        // Recover global history if mispredicted
        if (train_mispredicted) begin
          global_history <= train_history;
        end else begin
          //Update global history (only if no misprediction recovery)
          global_history <= {train_history[HISTORY_LENGTH-2:0], train_taken};
        end
      end
    end
  end

endmodule