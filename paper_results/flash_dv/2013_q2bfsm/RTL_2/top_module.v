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
  localparam E1 = 3'b111; //Monitoring y (one cycle passed)
  localparam F = 3'b001; // g = 1 permanently
  localparam G = 3'b010; // g = 0 permanently

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
    end
  end

  // Next state logic
  always @(*) begin
    case (current_state)
      A: next_state = B;
      B: next_state = C;
      C: begin
        if (x) next_state = C1;
        else next_state = C;
      end
      C1: begin
        if (!x) next_state = C2;
        else next_state = C1;
      end
      C2: begin
        if (x) next_state = D;
        else next_state = C;
      end
      D: next_state = E;
      E: begin
        if (y) next_state = F;
        else next_state = E1;
      end
      E1: begin
        if (y) next_state = F;
        else next_state = G;
      end
      F: next_state = F;
      G: next_state = G;
      default: next_state = A;
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

  always @(*) begin
    if (current_state == B) f = 1;
    else f = 0;

    if (current_state == D || current_state == E || current_state == E1 || current_state == F) g = 1;
    else if(current_state == G) g = 0;
    else g = 0;
  end

endmodule