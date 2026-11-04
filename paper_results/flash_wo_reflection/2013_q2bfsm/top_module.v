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
  localparam B = 3'b001; // Assert f
  localparam C = 3'b010; // Expect x = 1
  localparam D = 3'b011; // Expect x = 0
  localparam E = 3'b100; // Expect x = 1
  localparam F = 3'b101; // Assert g, monitor y
  localparam G = 3'b110; // g = 1 permanently
  localparam H = 3'b111; // g = 0 permanently

  reg [2:0] current_state;
  reg [2:0] next_state;
  reg x_history_1;
  reg x_history_2;
  reg g_asserted;
  reg [1:0] y_counter;

  // State register update
  always @(posedge clk) begin
    if (!resetn) begin
      current_state <= A;
      f <= 0;
      g <= 0;
      x_history_1 <= 0;
      x_history_2 <= 0;
      g_asserted <= 0;
      y_counter <= 0;
    end else begin
      current_state <= next_state;
      if (current_state == B) begin
        f <= 0;
      end
    end
  end

  // Next state logic
  always @(*) begin
    next_state = current_state; // Default next state
    f = 0; // Default output
    g = 0; // Default output

    case (current_state)
      A: begin
        next_state = B;
        f = 0;
        g = 0;
      end
      B: begin
        next_state = C;
        f = 1;
        g = 0;
      end
      C: begin
        if (x == 1) begin
          next_state = D;
          f = 0;
          g = 0;
        end else begin
          next_state = C;
          f = 0;
          g = 0;
        end
      end
      D: begin
        if (x == 0) begin
          next_state = E;
          f = 0;
          g = 0;
        end else begin
          next_state = C;
          f = 0;
          g = 0;
        end
      end
      E: begin
        if (x == 1) begin
          next_state = F;
          f = 0;
          g = 0;
        end else begin
          next_state = C;
          f = 0;
          g = 0;
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
        g = 1;
      end
      H: begin
        next_state = H;
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

  always @(posedge clk) begin
    if (!resetn) begin
      x_history_1 <= 0;
      x_history_2 <= 0;
      g_asserted <= 0;
      y_counter <= 0;
    end else begin
      if (current_state == C) begin
        x_history_2 <= x_history_1;
        x_history_1 <= x;
      end else if (current_state == D) begin
        x_history_2 <= x_history_1;
        x_history_1 <= x;
      end else if (current_state == E) begin
        x_history_2 <= x_history_1;
        x_history_1 <= x;
      end else if (current_state == F) begin
        if (y == 1) begin
          next_state <= G;
        end else begin
          if (y_counter < 2) begin
            y_counter <= y_counter + 1;
          end else begin
            next_state <= H;
          end
        end
      end else if (current_state == B) begin
        y_counter <= 0;
      end else if (current_state == A) begin
        y_counter <= 0;
      end else begin
        y_counter <= 0;
      end
    end
  end

  always @(*) begin
    if (current_state == F) begin
      if (y == 1) begin
        g = 1;
      end else begin
        g = 1;
      end
    end else if (current_state == G) begin
      g = 1;
    end else if (current_state == H) begin
      g = 0;
    end else if (current_state == B) begin
      g = 0;
    end else begin
      g = 0;
    end
  end

endmodule