module top_module (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

  // Define the states
  localparam IDLE          = 3'b000;
  localparam START_DETECTED = 3'b001;
  localparam RECEIVE_DATA  = 3'b010;
  localparam CHECK_STOP    = 3'b011;
  localparam ERROR_WAIT_STOP = 3'b100;
  localparam DONE          = 3'b101;

  reg [2:0] current_state;
  reg [2:0] next_state;
  reg [7:0] data_reg;
  reg done_reg;
  reg [2:0] bit_count;

  // Output assignments
  assign out_byte = data_reg;
  assign done = done_reg;

  // State transition logic
  always @(*) begin
    next_state = current_state; // Default: stay in the same state
    case (current_state)
      IDLE: begin
        if (in == 0) begin
          next_state = START_DETECTED;
        end
      end
      START_DETECTED: begin
        next_state = RECEIVE_DATA;
      end
      RECEIVE_DATA: begin
        if (bit_count == 3'b111) begin // 7 (0 to 7)
          next_state = CHECK_STOP;
        end
      end
      CHECK_STOP: begin
        if (in == 1) begin
          next_state = DONE;
        end else begin
          next_state = ERROR_WAIT_STOP;
        end
      end
      ERROR_WAIT_STOP: begin
        if (in == 1) begin
          next_state = DONE;
        end
      end
      DONE: begin
        next_state = IDLE;
      end
      default: begin
        next_state = IDLE;
      end
    endcase
  end

  // State and data register update
  always @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
      data_reg <= 8'b0;
      done_reg <= 1'b0;
      bit_count <= 3'b000;
    end else begin
      current_state <= next_state;

      case (current_state)
        IDLE: begin
          done_reg <= 1'b0;
          bit_count <= 3'b000;
        end
        START_DETECTED: begin
          done_reg <= 1'b0;
        end
        RECEIVE_DATA: begin
          data_reg[bit_count] <= in;
          bit_count <= bit_count + 1'b1;
          done_reg <= 1'b0;
        end
        CHECK_STOP: begin
          done_reg <= 1'b0;
        end
        ERROR_WAIT_STOP: begin
          done_reg <= 1'b0;
        end
        DONE: begin
          done_reg <= 1'b1;
        end
        default: begin
          done_reg <= 1'b0;
          bit_count <= 3'b000;
        end
      endcase
    end
  end

endmodule