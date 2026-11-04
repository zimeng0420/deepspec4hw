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
  localparam C1 = 3'b011; // Monitoring x (x=1)
  localparam C2 = 3'b100; // Monitoring x (x=0 after x=1)
  localparam D = 3'b101; // g = 1
  localparam E = 3'b110; // Monitoring y
  localparam E1 = 3'b111; // Monitoring y (one cycle passed)
  localparam F = 3'b001; // g = 1 permanently
  localparam G = 3'b010; // g = 0 permanently


  reg [2:0] current_state;
  reg [2:0] next_state;

  // State transition logic
  always @(posedge clk) begin
    if (!resetn) begin
      current_state <= A;
    end else begin
      current_state <= next_state;
    end
  end

  // Next state logic
  always @(*) begin
    case (current_state)
      A: begin
        next_state = A;
      end
      B: begin
        next_state = C;
      end
      C: begin
        if (x == 1) begin
          next_state = C1;
        end else begin
          next_state = C;
        end
      end
      C1: begin
        if (x == 0) begin
          next_state = C2;
        end else begin
          next_state = C1;
        end
      end
      C2: begin
        if (x == 1) begin
          next_state = D;
        end else begin
          next_state = C;
        end
      end
      D: begin
        next_state = E;
      end
      E: begin
        if (y == 1) begin
          next_state = F;
        end else begin
          next_state = E1;
        end
      end
      E1: begin
        if (y == 1) begin
          next_state = F;
        end else begin
          next_state = G;
        end
      end
      F: begin
        next_state = F;
      end
      G: begin
        next_state = G;
      end
      default: begin
        next_state = A;
      end
    endcase
  end

  // Output logic
  always @(posedge clk) begin
    if (!resetn) begin
      f <= 0;
      g <= 0;
    end else begin
      case (current_state)
        A: begin
          f <= 0;
          g <= 0;
        end
        B: begin
          f <= 1;
          g <= 0;
        end
        C: begin
          f <= 0;
          g <= 0;
        end
        C1: begin
          f <= 0;
          g <= 0;
        end
        C2: begin
          f <= 0;
          g <= 0;
        end
        D: begin
          f <= 0;
          g <= 1;
        end
        E: begin
          f <= 0;
          g <= 1;
        end
        E1: begin
          f <= 0;
          g <= 1;
        end
        F: begin
          f <= 0;
          g <= 1;
        end
        G: begin
          f <= 0;
          g <= 0;
        end
        default: begin
          f <= 0;
          g <= 0;
        end
      endcase
    end
  end

  always @(posedge clk) begin
    if (!resetn) begin
      if (current_state == A)
        next_state <= A;
      else
        next_state <= A;
    end
    else if (current_state == A)
      next_state <= B;
  end

endmodule