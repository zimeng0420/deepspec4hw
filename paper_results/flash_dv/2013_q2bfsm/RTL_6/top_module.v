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
  localparam C1 = 3'b011; // x = 1, waiting for x = 0
  localparam C2 = 3'b100; // x = 1, x = 0, waiting for x = 1
  localparam D = 3'b101; // g = 1
  localparam E = 3'b110; // Monitoring y
  localparam F = 3'b111; // g = 1 permanently
  localparam G = 3'b001; // g = 0 permanently

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
    end
  end

  // Next state logic
  always @(*) begin
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
        if (x) begin
          next_state = C1;
        } else begin
          next_state = C;
        end
        f = 0;
        g = 0;
      end
      C1: begin
        if (!x) begin
          next_state = C2;
        } else begin
          next_state = C1;
        end
        f = 0;
        g = 0;
      end
      C2: begin
        if (x) begin
          next_state = D;
        } else begin
          next_state = C;
        end
        f = 0;
        g = 0;
      end
      D: begin
        next_state = E;
        f = 0;
        g = 1;
      end
      E: begin
        if (y) begin
          next_state = F;
        end else begin
          next_state = E;
        end
        f = 0;
        g = 1;
      end
      F: begin
        next_state = F;
        f = 0;
        g = 1;
      end
      default: begin  // G
        next_state = G;
        f = 0;
        g = 0;
      end
    endcase
  end

  always @(posedge clk) begin
    if(!resetn)
      y_counter <= 0;
    else if (current_state == E) begin
      if (y)
        y_counter <= 0;
      else if (y_counter < 2)
        y_counter <= y_counter + 1;
      else
        next_state <= G;
    end
    else
      y_counter <= 0;
  end

  always @(*) begin
    if (current_state == G)
      g = 0;
    else if (current_state == F || current_state == D || current_state == E)
      g = 1;
    else
      g = 0;

    if (current_state == B)
      f = 1;
    else
      f = 0;
  end

endmodule