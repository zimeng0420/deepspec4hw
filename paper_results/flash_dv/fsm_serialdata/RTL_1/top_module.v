module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

  // Define the states of the FSM
  typedef enum logic [3:0] {
    IDLE,       // Waiting for start bit
    START,      // Start bit detected
    DATA0,      // Receiving data bit 0
    DATA1,      // Receiving data bit 1
    DATA2,      // Receiving data bit 2
    DATA3,      // Receiving data bit 3
    DATA4,      // Receiving data bit 4
    DATA5,      // Receiving data bit 5
    DATA6,      // Receiving data bit 6
    DATA7,      // Receiving data bit 7
    STOP,       // Waiting for stop bit
    WAIT_STOP   // Waiting for stop bit after error
  } state_t;

  reg state, next_state;
  reg [7:0] data_reg;
  reg [2:0] bit_count;

  // State transition logic
  always_comb begin
    next_state = state;
    case (state)
      IDLE: begin
        if (in == 0) begin
          next_state = START;
        end
      end
      START: begin
        next_state = DATA0;
        bit_count = 0;
      end
      DATA0: next_state = DATA1;
      DATA1: next_state = DATA2;
      DATA2: next_state = DATA3;
      DATA3: next_state = DATA4;
      DATA4: next_state = DATA5;
      DATA5: next_state = DATA6;
      DATA6: next_state = DATA7;
      DATA7: next_state = STOP;
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
      state <= IDLE;
      out_byte <= 0;
      done <= 0;
    end else begin
      state <= next_state;
      done <= 0; // Default to 0, set to 1 only when done
    end
  end

  // Data and output logic
  always_ff @(posedge clk) begin
    if (reset) begin
      data_reg <= 0;
    end else begin
      case (state)
        DATA0: data_reg[0] <= in;
        DATA1: data_reg[1] <= in;
        DATA2: data_reg[2] <= in;
        DATA3: data_reg[3] <= in;
        DATA4: data_reg[4] <= in;
        DATA5: data_reg[5] <= in;
        DATA6: data_reg[6] <= in;
        DATA7: data_reg[7] <= in;
        STOP: begin
          if (in == 1) begin
            out_byte <= data_reg;
            done <= 1;
          end
        end
        default: ;
      endcase
    end
  end

endmodule