module top_module (
    input clk,
    input in,
    input reset,
    output out
);

  // Define the state encoding
  parameter STATE_A = 2'b00;
  parameter STATE_B = 2'b01;
  parameter STATE_C = 2'b10;
  parameter STATE_D = 2'b11;

  // State register
  reg [1:0] current_state;
  reg [1:0] next_state;

  // Output register
  reg out;

  // State transition logic (sequential)
  always @(posedge clk) begin
    if (reset) begin
      current_state <= STATE_A; // Reset to state A
    end else begin
      current_state <= next_state; // Update state
    end
  end

  // Next state logic (combinational)
  always @(*) begin
    case (current_state)
      STATE_A: begin
        if (in == 0) begin
          next_state = STATE_A;
        end else begin
          next_state = STATE_B;
        end
      end
      STATE_B: begin
        if (in == 0) begin
          next_state = STATE_C;
        end else begin
          next_state = STATE_B;
        end
      end
      STATE_C: begin
        if (in == 0) begin
          next_state = STATE_A;
        end else begin
          next_state = STATE_D;
        end
      end
      STATE_D: begin
        if (in == 0) begin
          next_state = STATE_C;
        end else begin
          next_state = STATE_B;
        end
      end
      default: begin
        next_state = STATE_A; // Default to state A in case of an invalid state
      end
    endcase
  end

  // Output logic (combinational)
  always @(*) begin
    case (current_state)
      STATE_D: out = 1;
      default: out = 0;
    endcase
  end

endmodule