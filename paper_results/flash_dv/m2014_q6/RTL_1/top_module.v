module top_module (
    input clk,
    input reset,
    input w,
    output z
);

  // Define the states
  localparam A = 3'b000;
  localparam B = 3'b001;
  localparam C = 3'b010;
  localparam D = 3'b011;
  localparam E = 3'b100;
  localparam F = 3'b101;

  // State register
  reg [2:0] current_state;
  reg [2:0] next_state;

  // Output signal
  wire z;

  // Next state logic
  always @(*) begin
    case (current_state)
      A: begin
        if (w == 0) begin
          next_state = B;
        end else begin
          next_state = A;
        end
      end
      B: begin
        if (w == 0) begin
          next_state = C;
        end else begin
          next_state = D;
        end
      end
      C: begin
        if (w == 0) begin
          next_state = E;
        end else begin
          next_state = D;
        end
      end
      D: begin
        if (w == 0) begin
          next_state = F;
        end else begin
          next_state = A;
        end
      end
      E: begin
        if (w == 0) begin
          next_state = E;
        end else begin
          next_state = D;
        end
      end
      F: begin
        if (w == 0) begin
          next_state = C;
        end else begin
          next_state = D;
        end
      end
      default: next_state = A; // Should not happen, but good practice
    endcase
  end

  // State update logic
  always @(posedge clk) begin
    if (reset) begin
      current_state <= A;
    end else begin
      current_state <= next_state;
    end
  end

  // Output logic
  assign z = (current_state == E) || (current_state == F);

endmodule