module top_module(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output logic [1:0] state
);

  // Define the reset value (weakly not-taken)
  localparam RESET_VALUE = 2'b01;

  // Next state logic
  logic [1:0] next_state;

  always_comb begin
    next_state = state; // Default: retain current state

    if (train_valid) begin
      if (train_taken) begin
        // Increment, saturate at 3
        if (state == 2'b11) begin
          next_state = 2'b11; // Saturate at maximum value
        end else begin
          next_state = state + 1'b1;
        end
      end else begin
        // Decrement, saturate at 0
        if (state == 2'b00) begin
          next_state = 2'b00; // Saturate at minimum value
        end else begin
          next_state = state - 1'b1;
        end
      end
    end
  end

  // Sequential logic (state update)
  always_ff @(posedge clk, posedge areset) begin
    if (areset) begin
      state <= RESET_VALUE;
    end else begin
      state <= next_state;
    end
  end

endmodule