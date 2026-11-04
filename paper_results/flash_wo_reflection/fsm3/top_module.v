module top_module (
    input clk,
    input in,
    input areset,
    output out
);

  reg [1:0] current_state;
  reg [1:0] next_state;

  // State encoding:
  // A = 00
  // B = 01
  // C = 10
  // D = 11

  // Next state logic
  always @(*) begin
    case (current_state)
      2'b00: begin // A
        if (in == 0) next_state = 2'b00; // A
        else next_state = 2'b01; // B
      end
      2'b01: begin // B
        if (in == 0) next_state = 2'b10; // C
        else next_state = 2'b01; // B
      end
      2'b10: begin // C
        if (in == 0) next_state = 2'b00; // A
        else next_state = 2'b11; // D
      end
      2'b11: begin // D
        if (in == 0) next_state = 2'b10; // C
        else next_state = 2'b01; // B
      end
      default: next_state = 2'b00;
    endcase
  end

  // State update
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= 2'b00; // Reset to state A
    end else begin
      current_state <= next_state;
    end
  end

  // Output logic
  assign out = (current_state == 2'b11);

endmodule