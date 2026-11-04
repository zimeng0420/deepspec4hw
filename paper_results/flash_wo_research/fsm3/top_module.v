module top_module (
    input clk,
    input in,
    input areset,
    output out
);

  reg [1:0] state;
  reg [1:0] next_state;

  // State encoding:
  // A: 2'b00
  // B: 2'b01
  // C: 2'b10
  // D: 2'b11

  // Next state logic
  always @(*) begin
    case (state)
      2'b00: begin // State A
        if (in == 0)
          next_state = 2'b00; // A
        else
          next_state = 2'b01; // B
      end
      2'b01: begin // State B
        if (in == 0)
          next_state = 2'b10; // C
        else
          next_state = 2'b01; // B
      end
      2'b10: begin // State C
        if (in == 0)
          next_state = 2'b00; // A
        else
          next_state = 2'b11; // D
      end
      2'b11: begin // State D
        if (in == 0)
          next_state = 2'b10; // C
        else
          next_state = 2'b01; // B
      end
      default: next_state = 2'b00;
    endcase
  end

  // State register
  always @(posedge clk, posedge areset) begin
    if (areset) begin
      state <= 2'b00; // Reset to state A
    end else begin
      state <= next_state;
    end
  end

  // Output logic
  assign out = (state == 2'b11); // Output is 1 only in state D

endmodule