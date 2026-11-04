module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output [23:0] out_bytes,
    output done
);

  // Define states
  typedef enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2,
    BYTE3
  } state_t;

  // State register
  reg state_t current_state;
  reg state_t next_state;

  // Data registers
  reg [7:0] byte1;
  reg [7:0] byte2;
  reg [7:0] byte3;
  reg [23:0] out_bytes_reg;
  reg done_reg;

  // Combinational logic for next state
  always_comb begin
    case (current_state)
      IDLE: begin
        if (in[3]) begin
          next_state = BYTE1;
        end else begin
          next_state = IDLE;
        end
      end
      BYTE1: next_state = BYTE2;
      BYTE2: next_state = BYTE3;
      BYTE3: next_state = IDLE;
      default: next_state = IDLE;
    endcase
  end

  // Combinational logic for output 'done'
  assign done = done_reg;
  assign out_bytes = out_bytes_reg;

  // Sequential logic for state update and data capture
  always @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
      byte1 <= 8'b0;
      byte2 <= 8'b0;
      byte3 <= 8'b0;
      out_bytes_reg <= 24'b0;
      done_reg <= 1'b0;
    end else begin
      current_state <= next_state;
      case (current_state)
        IDLE: begin
          done_reg <= 1'b0;
        end
        BYTE1: begin
          byte1 <= in;
          done_reg <= 1'b0;
        end
        BYTE2: begin
          byte2 <= in;
          done_reg <= 1'b0;
        end
        BYTE3: begin
          byte3 <= in;
          out_bytes_reg <= {byte1, byte2, byte3};
          done_reg <= 1'b1;
        end
        default: begin
          done_reg <= 1'b0;
        end
      endcase
    end
  end

endmodule