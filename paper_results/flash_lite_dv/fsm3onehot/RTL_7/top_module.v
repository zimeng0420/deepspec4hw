module top_module(
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

  // Define state constants (one-hot encoding)
  localparam A = 4'b0001;
  localparam B = 4'b0010;
  localparam C = 4'b0100;
  localparam D = 4'b1000;

  // Next state logic
  always @(*) begin
    case (1'b1) // Use a constant for the case expression to make it combinational
      1'b1: begin
        next_state = 4'b0000; // Default to prevent latch inference.

        if (state == A) begin
          if (!in) next_state = A;
          else     next_state = B;
        end
        else if (state == B) begin
          if (!in) next_state = C;
          else     next_state = B;
        end
        else if (state == C) begin
          if (!in) next_state = A;
          else     next_state = D;
        end
        else if (state == D) begin
          if (!in) next_state = C;
          else     next_state = B;
        end
      end
    endcase
  end

  // Output logic
  always @(*) begin
      case (state)
        D: out = 1'b1;
        default: out = 1'b0;
      endcase
  end

endmodule