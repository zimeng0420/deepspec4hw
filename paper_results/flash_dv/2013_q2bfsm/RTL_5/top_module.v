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
  localparam C = 3'b010; // Monitoring x, initial state
  localparam C1 = 3'b011; // x = 1
  localparam C2 = 3'b100; // x = 1, 0
  localparam D = 3'b101; // g = 1
  localparam E = 3'b110; // Monitoring y
  localparam E1 = 3'b111; // Monitoring y, one cycle passed
  localparam F = 3'b001; // g = 1 permanently
  localparam G = 3'b010; // g = 0 permanently


  // State register
  reg [2:0] current_state;
  reg [2:0] next_state;

  always @(posedge clk) begin
    if (!resetn) begin
      current_state <= A;
      f <= 0;
      g <= 0;
    end else begin
      current_state <= next_state;
      if (current_state == B) begin
        f <= 0;
      end
    end
  end

  always @(*) begin
    next_state = current_state;
    f = 0;
    g = 0;

    case (current_state)
      A: begin
        next_state = A;
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
          next_state = C1;
          f = 0;
          g = 0;
        end else begin
          next_state = C;
          f = 0;
          g = 0;
        end
      end
      C1: begin
        if (x == 0) begin
          next_state = C2;
          f = 0;
          g = 0;
        end else begin
          next_state = C1;
          f = 0;
          g = 0;
        end
      end
      C2: begin
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
        next_state = E;
        f = 0;
        g = 1;
      end
      E: begin
        if (y == 1) begin
          next_state = F;
          f = 0;
          g = 1;
        end else begin
          next_state = E1;
          f = 0;
          g = 1;
        end
      end
      E1: begin
        if (y == 1) begin
          next_state = F;
          f = 0;
          g = 1;
        end else begin
          next_state = G;
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
        g = 0;
      end
      default: begin
        next_state = A;
        f = 0;
        g = 0;
      end
    end
  end

endmodule