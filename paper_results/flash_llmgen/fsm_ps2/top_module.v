module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

  // Define the states
  typedef enum logic [1:0] {IDLE, BYTE1, BYTE2, BYTE3} state_t;

  // State variable
  reg state_t current_state, next_state;

  // State transition logic
  always_comb begin
    case (current_state)
      IDLE: begin
        if (in[3] == 1) begin
          next_state = BYTE1;
        end else begin
          next_state = IDLE;
        end
        done = 0;
      end
      BYTE1: begin
        next_state = BYTE2;
        done = 0;
      end
      BYTE2: begin
        next_state = BYTE3;
        done = 0;
      end
      BYTE3: begin
        next_state = IDLE;
        done = 1;
      end
      default: begin
        next_state = IDLE;
        done = 0;
      end
    endcase
  end

  // State update logic
  always_ff @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
      done <= 0;
    end else begin
      current_state <= next_state;
      if (current_state == BYTE3)
        done <= 0; // De-assert done in the next cycle after BYTE3
    end
  end

endmodule