module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

  // Define the states of the FSM
  typedef enum logic [2:0] {
    IDLE,
    RECEIVE_DATA,
    CHECK_STOP,
    WAIT_FOR_STOP
  } state_t;

  reg state, next_state;
  reg [3:0] bit_count; // Counter for data bits

  // State Transition Logic
  always_comb begin
    next_state = state;
    case (state)
      IDLE: begin
        if (in == 0) begin // Start bit detected
          next_state = RECEIVE_DATA;
          bit_count = 0;
        end else begin
          next_state = IDLE;
        end
      end
      RECEIVE_DATA: begin
        if (bit_count == 7) begin // Received 8 data bits
          next_state = CHECK_STOP;
        end else begin
          next_state = RECEIVE_DATA;
        end
      end
      CHECK_STOP: begin
        if (in == 1) begin // Stop bit detected
          next_state = IDLE;
        end else begin // Invalid stop bit
          next_state = WAIT_FOR_STOP;
        end
      end
      WAIT_FOR_STOP: begin
        if (in == 1) begin // Stop bit detected
          next_state = IDLE;
        end else begin
          next_state = WAIT_FOR_STOP;
        end
      end
      default: next_state = IDLE; // Should not happen, but good practice
    endcase
  end

  // State Update Logic (Sequential)
  always_ff @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 0;
    end else begin
      state <= next_state;
      if (state == RECEIVE_DATA) begin
        bit_count <= bit_count + 1;
      end
    end
  end

  // Output Logic
  always_ff @(posedge clk) begin
    if (reset) begin
      done <= 0;
    end else begin
      if (state == CHECK_STOP && in == 1) begin
        done <= 1; // Assert done for one clock cycle when stop bit is valid
      end else begin
        done <= 0;
      end
    end
  end

endmodule