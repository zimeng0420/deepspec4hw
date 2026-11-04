module top_module (
	input in,
	input [1:0] state,
	output reg [1:0] next_state,
	output out
);

  always @(*) begin
    case (state)
      2'b00: begin // A
        next_state = (in == 0) ? 2'b00 : 2'b01;
        out = 0;
      end
      2'b01: begin // B
        next_state = (in == 0) ? 2'b10 : 2'b01;
        out = 0;
      end
      2'b10: begin // C
        next_state = (in == 0) ? 2'b00 : 2'b11;
        out = 0;
      end
      2'b11: begin // D
        next_state = (in == 0) ? 2'b10 : 2'b01;
        out = 1;
      end
      default: begin
        next_state = 2'b00; // Default to A
        out = 0;
      end
    endcase
  end
endmodule