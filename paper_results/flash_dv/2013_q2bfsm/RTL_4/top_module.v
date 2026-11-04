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
  localparam C2 = 3'b100; // Monitoring x (x = 0 after x = 1)
  localparam D = 3'b101; // g = 1
  localparam E = 3'b110; // Monitoring y
  localparam F = 3'b111; // g = 1 permanently
  localparam G = 3'b001; // g = 0 permanently

  reg [2:0] current_state;
  reg [2:0] next_state;
  reg [1:0] y_counter;

  // State register update
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
          if (y_counter < 2)
              y_counter <= y_counter + 1;
      end else begin
          y_counter <= 0;
      end
    end
  end

  // Next state logic
  always @(*) begin
    next_state = current_state; // Default next state
    f = 0; // Default f value
    case (current_state)
      A: begin // Reset state
        next_state = A;
        f = 0;
        g = 0;
      end
      B: begin // f = 1 for one cycle
        next_state = C;
        f = 0;
      end
      C: begin // Monitoring x (initial)
        if (x == 1) begin
          next_state = C1;
        end else begin
          next_state = C;
        end
      end
      C1: begin // Monitoring x (x = 1)
        if (x == 0) begin
          next_state = C2;
        end else begin
          next_state = C1;
        end
      end
      C2: begin // Monitoring x (x = 0 after x = 1)
        if (x == 1) begin
          next_state = D;
        end else begin
          next_state = C;
        end
      end
      D: begin // g = 1
        next_state = E;
      end
      E: begin // Monitoring y
        if (y == 1) begin
          next_state = F;
        end else if (y_counter == 1) begin
          next_state = G;
        end else begin
          next_state = E;
        end
      end
      F: begin // g = 1 permanently
        next_state = F;
      end
      G: begin // g = 0 permanently
        next_state = G;
      end
      default: begin
        next_state = A;
      end
    endcase
  end

  // Output logic
  always @(*) begin
    case (current_state)
      A: begin
        f = 0;
        g = 0;
      end
      B: begin
        f = 1;
        g = 0;
      end
      C, C1, C2: begin
        f = 0;
        g = 0;
      end
      D, E, F: begin
        f = 0;
        g = 1;
      end
      G: begin
        f = 0;
        g = 0;
      end
      default: begin
        f = 0;
        g = 0;
      end
    endcase
  end

endmodule