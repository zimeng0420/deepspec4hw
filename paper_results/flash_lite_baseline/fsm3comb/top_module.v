module top_module (
	input in,
	input [1:0] state,
	output reg [1:0] next_state,
	output out
);

  always @(*) begin
    case (state)
      2'b00: // State A
        begin
          next_state = (in == 0) ? 2'b00 : 2'b01; // A or B
          out = 0;
        end
      2'b01: // State B
        begin
          next_state = (in == 0) ? 2'b10 : 2'b01; // C or B
          out = 0;
        end
      2'b10: // State C
        begin
          next_state = (in == 0) ? 2'b00 : 2'b11; // A or D
          out = 0;
        end
      2'b11: // State D
        begin
          next_state = (in == 0) ? 2'b10 : 2'b01; // C or B
          out = 1;
        end
      default:
        begin
          next_state = 2'b00; // Default to A
          out = 0;
        end
    endcase
  end

endmodule