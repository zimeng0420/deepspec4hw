module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

  // State definition
  typedef enum logic [3:0] {
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
    WAIT_STOP
  } state_t;

  reg state_t current_state, next_state;
  reg [2:0] bit_count;
  reg [7:0] data_reg;

  // State transition logic
  always_comb begin
    next_state = current_state;
    case (current_state)
      IDLE: begin
        if (in == 0) begin
          next_state = START;
        end else begin
          next_state = IDLE;
        end
        end
      START: begin
        next_state = BIT0;
        bit_count = 0;
      end
      BIT0: next_state = BIT1;
      BIT1: next_state = BIT2;
      BIT2: next_state = BIT3;
      BIT3: next_state = BIT4;
      BIT4: next_state = BIT5;
      BIT5: next_state = BIT6;
      BIT6: next_state = BIT7;
      BIT7: next_state = STOP;
      STOP: begin
        if (in == 1) begin
          next_state = IDLE;
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

  // State update logic
  always_ff @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
      out_byte <= 0;
      done <= 0;
    end else begin
      current_state <= next_state;
      case (current_state)
        START: begin
          data_reg[0] <= in;
        end
        BIT0: begin
          data_reg[1] <= in;
        end
        BIT1: begin
          data_reg[2] <= in;
        end
        BIT2: begin
          data_reg[3] <= in;
        end
        BIT3: begin
          data_reg[4] <= in;
        end
        BIT4: begin
          data_reg[5] <= in;
        end
        BIT5: begin
          data_reg[6] <= in;
        end
        BIT6: begin
          data_reg[7] <= in;
        end
        STOP: begin
          if (in == 1) begin
            out_byte <= data_reg;
            done <= 1;
          end else begin
            done <= 0;
          end
        end
        default: done <= 0;
      endcase
    end
  end

endmodule