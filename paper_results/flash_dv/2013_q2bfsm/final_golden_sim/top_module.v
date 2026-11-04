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
  localparam C = 3'b010; // Monitoring x (start)
  localparam C1 = 3'b011; // Monitoring x (x=1)
  localparam C2 = 3'b100; // Monitoring x (x=0 after x=1)
  localparam D = 3'b101; // g = 1
  localparam E = 3'b110; // Monitoring y (first cycle)
  localparam F = 3'b111; // g = 1 permanently
  localparam G = 3'b001; // g = 0 permanently
  localparam E1 = 3'b010; // Monitoring y (second cycle)

  // State register
  reg [2:0] current_state;
  reg [2:0] next_state;

  // y_seen register
  reg y_seen;

  // State transition logic
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

  // Next state logic
  always @(*) begin
    next_state = current_state;
    f = 0;
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
        g = 0;
        if (x == 1) begin
          next_state = C1;
        end
      end
      C1: begin
        next_state = C;
        g = 0;
        if (x == 0) begin
          next_state = C2;
        end else begin
          next_state = C1;
        end
      end
      C2: begin
        next_state = C;
        g = 0;
        if (x == 1) begin
          next_state = D;
        end else begin
          next_state = C;
        end
      end
      D: begin
        next_state = E;
        g = 1;
      end
      E: begin
        g = 1;
        if (y == 1) begin
          next_state = F;
        end else begin
          next_state = E1;
        end
      end
      E1: begin
        g = 1;
        if (y == 1) begin
          next_state = F;
        end else begin
          next_state = G;
        end
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
        f = 0;
        g = 0;
      end
    endcase
  end

endmodule