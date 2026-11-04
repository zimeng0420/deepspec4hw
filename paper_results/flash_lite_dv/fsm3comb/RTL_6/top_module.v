module fsm3comb (
  input in,
  input [1:0] state,
  output reg [1:0] next_state,
  output reg out
);

  always @(*) begin
    case (state)
      2'b00: // State A
        begin
          out = 1'b0;
          if (in)
            next_state = 2'b01; // B
          else
            next_state = 2'b00; // A
        end
      2'b01: // State B
        begin
          out = 1'b0;
          if (in)
            next_state = 2'b01; // B
          else
            next_state = 2'b10; // C
        end
      2'b10: // State C
        begin
          out = 1'b0;
          if (in)
            next_state = 2'b11; // D
          else
            next_state = 2'b00; // A
        end
      2'b11: // State D
        begin
          out = 1'b1;
          if (in)
            next_state = 2'b01; // B
          else
            next_state = 2'b10; // C
        end
      default: // Handle any unexpected state
        begin
          out = 1'b0;
          next_state = 2'b00; // Default to state A
        end
    endcase
  end

endmodule