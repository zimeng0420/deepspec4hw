module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

  // Define states
  localparam A = 3'b000; // Reset state
  localparam B = 3'b001; // f = 1 for one cycle
  localparam C = 3'b010; // Waiting for x = 1
  localparam C1 = 3'b011; // x = 1
  localparam C2 = 3'b100; // x = 1, 0
  localparam D = 3'b101; // x = 1, 0, 1, g = 1
  localparam E = 3'b110; // Monitoring y
  localparam F = 3'b111; // g = 1 permanently
  localparam G = 3'b001; // g = 0 permanently (reusing state B)


  reg [2:0] current_state;
  reg [2:0] next_state;
  reg [1:0] y_counter;

  // State transition logic
  always @(posedge clk) begin
    if (!resetn) begin
      current_state <= A;
      f <= 0;
      g <= 0;
      y_counter <= 0;
    end else begin
      current_state <= next_state;
      if (current_state == B) begin
        f <= 0;
      end
      if (current_state == E) begin
        if (y_counter < 2) begin
          y_counter <= y_counter + 1;
        end
      end
    end
  end

  // Next state logic
  always @(*) begin
    next_state = current_state; // Default: stay in the same state
    f = 0; // Default
    g = 0; // Default

    case (current_state)
      A: begin
        next_state = A;
        f = 0;
        g = 0;
        if (resetn) begin
          next_state = B;
        end
      end
      B: begin
        next_state = C;
        f = 1;
        g = 0;
      end
      C: begin
        next_state = C;
        f = 0;
        g = 0;
        if (x) begin
          next_state = C1;
        end
      end
      C1: begin
        next_state = C1;
        f = 0;
        g = 0;
        if (!x) begin
          next_state = C2;
        end else if (x) begin
          next_state = C1;
        end
      end
      C2: begin
        next_state = C2;
        f = 0;
        g = 0;
        if (x) begin
          next_state = D;
        end else if (!x) begin
          next_state = C2;
        end else begin
           next_state = C;
        end
      end
      D: begin
        next_state = E;
        f = 0;
        g = 1;
        y_counter = 0;
      end
      E: begin
        f = 0;
        g = 1;
        if (y) begin
          next_state = F;
        } else if (y_counter == 1) begin
          next_state = G;
          g = 0;
        } else begin
          next_state = E;
        end
      end
      F: begin
        next_state = F;
        f = 0;
        g = 1;
      end
      G: begin
        next_state = G;
        f = 0;
        g = 0;
      end
      default: begin
        next_state = A;
        f = 0;
        g = 0;
      end
    endcase
  end

endmodule