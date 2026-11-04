module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

  // Define states
  typedef enum logic [2:0] {
    IDLE,
    START,
    BIT0,
    BIT1,
    BIT2,
    BIT3,
    BIT4,
    BIT5,
    BIT6,
    BIT7,
    STOP,
    ERROR
  } state_t;

  reg state, next_state;
  reg [2:0] bit_count;

  always_ff @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done <= 0;
      bit_count <= 0;
    end else begin
      state <= next_state;
    end
  end

  always_comb begin
    next_state = state;
    done = 0;

    case (state)
      IDLE: begin
        if (in == 0) begin
          next_state = START;
        end
      end
      START: begin
        next_state = BIT0;
        bit_count = 0;
      end
      BIT0: begin
        next_state = BIT1;
        bit_count = bit_count + 1;
      end
      BIT1: begin
        next_state = BIT2;
        bit_count = bit_count + 1;
      end
      BIT2: begin
        next_state = BIT3;
        bit_count = bit_count + 1;
      end
      BIT3: begin
        next_state = BIT4;
        bit_count = bit_count + 1;
      end
      BIT4: begin
        next_state = BIT5;
        bit_count = bit_count + 1;
      end
      BIT5: begin
        next_state = BIT6;
        bit_count = bit_count + 1;
      end
      BIT6: begin
        next_state = BIT7;
        bit_count = bit_count + 1;
      end
      BIT7: begin
        next_state = STOP;
        bit_count = bit_count + 1;
      end
      STOP: begin
        if (in == 1) begin
          next_state = IDLE;
          done = 1;
        } else begin
          next_state = ERROR;
        end
      end
      ERROR: begin
        if (in == 1) begin
          next_state = IDLE;
        end else begin
          next_state = ERROR;
        end
      end
      default: begin
        next_state = IDLE;
      end
    endcase
  end

endmodule