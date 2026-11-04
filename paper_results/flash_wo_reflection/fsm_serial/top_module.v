module top_module (
    input clk,
    input in,
    input reset,
    output done
);

  // Define states
  typedef enum logic [2:0] {
    IDLE,
    START_BIT,
    DATA_BITS,
    STOP_BIT,
    WAIT_STOP
  } state_t;

  // State register
  reg state_t current_state, next_state;

  // Data register
  reg [7:0] data_byte;

  // Bit counter
  reg [3:0] bit_count;

  // Done register
  reg done_r;

  // Combinational logic for next state and output
  always_comb begin
    next_state = current_state;
    done_r = 0; // Default value for done

    case (current_state)
      IDLE: begin
        if (in == 0) begin
          next_state = START_BIT;
        end
      end
      START_BIT: begin
        next_state = DATA_BITS;
        bit_count = 0;
      end
      DATA_BITS: begin
        if (bit_count < 8) begin
          next_state = DATA_BITS;
        end else begin
          next_state = STOP_BIT;
        end
      end
      STOP_BIT: begin
        if (in == 1) begin
          next_state = IDLE;
          done_r = 1;
        end else begin
          next_state = WAIT_STOP;
        end
      end
      WAIT_STOP: begin
        if (in == 1) begin
          next_state = IDLE;
        end else begin
          next_state = WAIT_STOP;
        end
      end
      default: next_state = IDLE;
    endcase
  end

  // Sequential logic for state update and data capture
  always_ff @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
      data_byte <= 0;
      bit_count <= 0;
    end else begin
      current_state <= next_state;

      if (current_state == DATA_BITS && bit_count < 8) begin
        data_byte[bit_count] <= in;
        bit_count <= bit_count + 1;
      end
    end
  end

  assign done = done_r;

endmodule