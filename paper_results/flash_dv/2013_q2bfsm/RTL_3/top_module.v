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
  localparam C = 3'b010; // Monitoring x (initial)
  localparam C1 = 3'b011; // Monitoring x (x = 1)
  localparam C2 = 3'b100; // Monitoring x (x = 0)
  localparam D = 3'b101; // g = 1
  localparam E = 3'b110; // Monitoring y
  localparam E1 = 3'b111; // Monitoring y (1 cycle)
  localparam F = 3'b001; // g = 1 permanently
  localparam G = 3'b010; // g = 0 permanently

  reg [2:0] current_state;
  reg [2:0] next_state;
  reg y_seen;
  reg [1:0] y_counter;

  // State transition logic
  always @(posedge clk) begin
    if (!resetn) begin
      current_state <= A;
      f <= 0;
      g <= 0;
      y_seen <= 0;
      y_counter <= 0;
    end else begin
      current_state <= next_state;
      if (current_state == B) begin
        f <= 0;
      end
    end
  end

  // Next state and output logic
  always @(*) begin
    next_state = current_state;
    f = 0; // Default value
    g = 0; // Default value

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
        end else begin
          next_state = C1;
        end
      end

      C2: begin
        next_state = C2;
        f = 0;
        g = 0;
        if (x) begin
          next_state = D;
        end else begin
          next_state = C;
        end
      end

      D: begin
        next_state = E;
        f = 0;
        g = 1;
      end

      E: begin
        next_state = E1;
        f = 0;
        g = 1;
        if (y) begin
            next_state = F;
        end
      end

      E1: begin
        next_state = G;
        f = 0;
        g = 1;
        if (y) begin
            next_state = F;
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