module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

  parameter A = 0, B = 1, C0 = 2, C1 = 3, C2 = 4, C3 = 5;
  reg [2:0] current_state, next_state;
  reg [1:0] w_count;

  always @(posedge clk) begin
    if (reset) begin
      current_state <= A;
      z <= 0;
      w_count <= 0;
    end else begin
      current_state <= next_state;
    end
  end

  always @(*) begin
    next_state = current_state;
    z = 0; // Default output

    case (current_state)
      A: begin
        if (s) begin
          next_state = B;
        end else begin
          next_state = A;
        end
      end
      B: begin
        next_state = C0;
        w_count = 0;
      end
      C0: begin
        if (w) begin
          next_state = C1;
        end else begin
          next_state = C1;
        end
      end
      C1: begin
        if (w) begin
          next_state = C2;
        end else begin
          next_state = C2;
        end
      end
      C2: begin
        if (w) begin
          next_state = C3;
        end else begin
          next_state = C3;
        end
      end

      C3: begin
        if ((w && (!w)) || ((!w) && w)) begin
          z = 1;
        end
        next_state = B;
      end
      default: next_state = A;
    end
  end

  always @(posedge clk) begin
    if(reset) begin
        w_count <= 0;
    end else begin
      if (current_state == C0) begin
          w_count <= 0;
      end else if(current_state == C0 || current_state == C1 || current_state == C2) begin
        if(w) begin
            w_count <= w_count + 1;
        end
      end
    end
  end

  always @(*) begin
    if (current_state == C3) begin
        if(w_count == 2) begin
            z = 1;
        end else begin
            z = 0;
        end
    end
  end

endmodule