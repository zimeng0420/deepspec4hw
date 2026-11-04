module top_module (
	input clk,
	input reset,
	input s,
	input w,
	output reg z
);

  // Define states
  localparam A = 3'b000;
  localparam B = 3'b001;
  localparam C = 3'b010;
  localparam D = 3'b011;
  localparam E = 3'b100;
  localparam F = 3'b101;
  localparam G = 3'b110;

  reg [2:0] current_state, next_state;
  reg [1:0] ones_count;

  always @(posedge clk) begin
    if (reset) begin
      current_state <= A;
      z <= 0;
    end else begin
      current_state <= next_state;
      if (current_state == G) begin
        z <= 0; // Default to 0. Redundant but safe
      end
    end
  end

  always @(*) begin
    next_state = current_state; // Default
    z = 0; //Default output

    case (current_state)
      A: begin
        if (s) begin
          next_state = B;
        end else begin
          next_state = A;
        end
      end
      B: begin
          next_state = C;
      end
      C: begin
          next_state = D;
      end
      D: begin
          next_state = E;
      end
      E: begin
        next_state = F;
      end
      F: begin
        next_state = G;
      end
      G: begin
        next_state = B;
      end

      default: next_state = A;
    endcase
  end

  always @(posedge clk) begin
    if (reset) begin
      ones_count <= 0;
    end else if (current_state == B) begin
        ones_count <= 0;
    end else if (current_state == C) begin
      ones_count <= w ? 1 : 0;
    end else if (current_state == D) begin
      ones_count <= (ones_count + w) > 2 ? 2 : (ones_count + w);
    end else if (current_state == E) begin
       ones_count <= (ones_count + w) > 2 ? 2 : (ones_count + w);
    end else if (current_state == F) begin
    end else if(current_state == G) begin
      if (ones_count == 2) begin
        z <= 1;
      end
    end
  end

endmodule