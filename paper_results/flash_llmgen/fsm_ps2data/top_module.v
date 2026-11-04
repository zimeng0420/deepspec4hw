module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output [23:0] out_bytes,
    output done
);

  // State Definition
  localparam IDLE  = 2'b00;
  localparam BYTE1 = 2'b01;
  localparam BYTE2 = 2'b10;
  localparam BYTE3 = 2'b11;

  // State Register
  reg [1:0] current_state;
  reg [1:0] next_state;

  // Data Registers
  reg [7:0] byte1;
  reg [7:0] byte2;
  reg [7:0] byte3;
  reg [23:0] out_bytes_reg; // Internal register for out_bytes
  reg done_reg;

  // Output Assignment
  assign out_bytes = out_bytes_reg;
  assign done = done_reg;

  // State Transition Logic
  always @(*) begin
    case (current_state)
      IDLE: begin
        if (in[3]) begin
          next_state = BYTE1;
        end else begin
          next_state = IDLE;
        end
      end
      BYTE1: begin
        next_state = BYTE2;
      end
      BYTE2: begin
        next_state = BYTE3;
      end
      BYTE3: begin
        next_state = IDLE;
      end
      default: begin
        next_state = IDLE; // Default case for safety
      end
    endcase
  end

  // State Update Logic
  always @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
      byte1 <= 0;
      byte2 <= 0;
      byte3 <= 0;
      out_bytes_reg <= 0;
      done_reg <= 0;
    end else begin
      current_state <= next_state;
      done_reg <= 0; // Default to 0, set to 1 only in BYTE3

      case (current_state)
        IDLE: begin
          if (in[3]) begin
            byte1 <= in;
          end
        end
        BYTE1: begin
          byte2 <= in;
        end
        BYTE2: begin
          byte3 <= in;
        end
        BYTE3: begin
          out_bytes_reg <= {byte1, byte2, byte3};
          done_reg <= 1; // Assert done signal
        end
        default: begin
          byte1 <= 0;
          byte2 <= 0;
          byte3 <= 0;
          out_bytes_reg <= 0;
          done_reg <= 0;
        end
      endcase
    end
  end

endmodule