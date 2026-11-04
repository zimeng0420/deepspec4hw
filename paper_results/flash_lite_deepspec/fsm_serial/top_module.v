module top_module (
	input clk,
	input in,
	input reset,
	output done
);

  // State Definitions
  parameter IDLE      = 3'b000;
  parameter START_BIT = 3'b001;
  parameter DATA_BITS = 3'b010;
  parameter STOP_BIT  = 3'b011;
  parameter ERROR     = 3'b100;

  // Internal Signals
  reg [2:0] state;
  reg [2:0] next_state;
  reg [2:0] bit_count;
  reg done_internal;

  // State Transition Logic
  always @(*) begin
    next_state = state;
    done_internal = 1'b0;

    case (state)
      IDLE: begin
        if (in == 1'b0) begin
          next_state = START_BIT;
        end
      end
      START_BIT: begin
        next_state = DATA_BITS;
      end
      DATA_BITS: begin
        if (bit_count == 7) begin
          next_state = STOP_BIT;
        end
      end
      STOP_BIT: begin
        if (in == 1'b1) begin
          next_state = IDLE;
          done_internal = 1'b1;
        end else begin
          next_state = ERROR;
        end
      end
      ERROR: begin
        if (in == 1'b1) begin
          next_state = IDLE;
        end
      end
      default: begin
        next_state = IDLE;
      end
    endcase
  end

  // Bit Counter Logic
  always @(posedge clk) begin
    if (reset) begin
      bit_count <= 3'b000;
    end else begin
      if (state == DATA_BITS && bit_count < 7) begin
        bit_count <= bit_count + 1'b1;
      end else if (state != DATA_BITS) begin
        bit_count <= 3'b000;
      end
    end
  end

  // State Register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  // Output Logic
  assign done = done_internal;

endmodule