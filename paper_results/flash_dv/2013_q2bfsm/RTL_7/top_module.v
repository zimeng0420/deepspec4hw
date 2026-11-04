module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

  // Define the states
  localparam A = 3'b000; // Reset state
  localparam B = 3'b001; // f = 1 for one cycle
  localparam C = 3'b010; // Waiting for x = 1
  localparam C1 = 3'b011; // x = 1
  localparam C2 = 3'b100; // x = 1, 0
  localparam D = 3'b101; // x = 1, 0, 1; g = 1
  localparam E = 3'b110; // Monitoring y
  localparam E1 = 3'b111; // Monitoring y (second cycle)
  localparam F = 3'b000; // g = 1 permanently
  localparam G = 3'b001; // g = 0 permanently

  reg [2:0] current_state;
  reg [2:0] next_state;

  // State transition logic
  always @(posedge clk) begin
    if (!resetn) begin
      current_state <= A;
      f <= 0;
      g <= 0;
    end else begin
      current_state <= next_state;
      if (next_state == B) begin
        f <= 1;
      end else begin
        f <= 0;
      end
    end
  end

  // Next state logic
  always @(*) begin
    case (current_state)
      A: begin
        next_state = A;
        g = 0;
      end
      B: begin
        next_state = C;
        g = 0;
      end
      C: begin
        if (x) begin
          next_state = C1;
        end else begin
          next_state = C;
        end
        g = 0;
      end
      C1: begin
        if (!x) begin
          next_state = C2;
        end else begin
          next_state = C1;
        end
        g = 0;
      end
      C2: begin
        if (x) begin
          next_state = D;
        end else begin
          next_state = C;
        end
        g = 0;
      end
      D: begin
        next_state = E;
        g = 1;
      end
      E: begin
        if (y) begin
          next_state = F;
        end else begin
          next_state = E1;
        end
        g = 1;
      end
      E1: begin
        if (y) begin
          next_state = F;
        end else begin
          next_state = G;
        end
        g = 1;
      end
      F: begin
        next_state = F;
        g = 1;
      end
      G: begin
        next_state = G;
        g = 0;
      end
      default: begin
        next_state = A;
        g = 0;
      end
    endcase
  end

endmodule