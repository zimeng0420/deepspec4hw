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

  // Output register
  reg [23:0] out_bytes_reg;
  reg done_reg;

  // Next state logic
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

  // Sequential logic
  always_ff @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
      byte1 <= 0;
      byte2 <= 0;
      byte3 <= 0;
      out_bytes_reg <= 0;
      done_reg <= 0;
    end else begin
      current_state <= next_state;
      case (current_state)
        IDLE: begin
          if (in[3]) begin
            byte1 <= in;
            done_reg <= 0;
          end
        end
        BYTE1: byte2 <= in;
        BYTE2: byte3 <= in;
        BYTE3: begin
          out_bytes_reg <= {byte1, byte2, byte3};
          done_reg <= 1;
        end
        default: ;
      endcase
    end
  end

  // Output logic
  assign out_bytes = out_bytes_reg;
  assign done = done_reg;

endmodule