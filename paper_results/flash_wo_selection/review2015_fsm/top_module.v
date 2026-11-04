module top_module(
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

  // Define states
  localparam IDLE       = 3'b000;
  localparam SHIFT_ENA1 = 3'b001;
  localparam SHIFT_ENA2 = 3'b010;
  localparam SHIFT_ENA3 = 3'b011;
  localparam SHIFT_ENA4 = 3'b100;
  localparam COUNTING   = 3'b101;
  localparam DONE       = 3'b110;

  // State register
  reg [2:0] current_state;
  reg [2:0] next_state;

  // Data shift register for pattern detection
  reg [3:0] data_shift_reg;

  // State transition logic
  always @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end

  // Next state logic
  always @(*) begin
    next_state = current_state; // Default: stay in the same state
    case (current_state)
      IDLE: begin
        if (data_shift_reg == 4'b1101) begin
          next_state = SHIFT_ENA1;
        end
      end
      SHIFT_ENA1: next_state = SHIFT_ENA2;
      SHIFT_ENA2: next_state = SHIFT_ENA3;
      SHIFT_ENA3: next_state = SHIFT_ENA4;
      SHIFT_ENA4: next_state = COUNTING;
      COUNTING: begin
        if (done_counting) begin
          next_state = DONE;
        end
      end
      DONE: begin
        if (ack) begin
          next_state = IDLE;
        end
      end
      default: next_state = IDLE;
    endcase
  end

  // Output logic
  always @(*) begin
    shift_ena = 0;
    counting = 0;
    done = 0;

    case (current_state)
      SHIFT_ENA1: shift_ena = 1;
      SHIFT_ENA2: shift_ena = 1;
      SHIFT_ENA3: shift_ena = 1;
      SHIFT_ENA4: shift_ena = 1;
      COUNTING: counting = 1;
      DONE: done = 1;
      default: begin
        shift_ena = 0;
        counting = 0;
        done = 0;
      end
    endcase
  end

  // Data shift register update
  always @(posedge clk) begin
    if (reset) begin
      data_shift_reg <= 4'b0000;
    end else begin
      data_shift_reg <= {data_shift_reg[2:0], data};
    end
  end

endmodule