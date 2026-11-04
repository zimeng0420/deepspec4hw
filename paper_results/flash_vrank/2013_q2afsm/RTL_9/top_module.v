module top_module (
	input clk,
	input resetn,
	input [3:1] r,
	output [3:1] g
);

  // State encoding:
  // A: 2'b00
  // B: 2'b01
  // C: 2'b10

  reg [1:0] current_state, next_state;

  // State flip-flops (sequential always block)
  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      current_state <= 2'b00; // State A
    end else begin
      current_state <= next_state;
    end
  end

  // State table (combinational always block)
  always @(*) begin
    case (current_state)
      2'b00: begin // State A
        if (r[1]) begin
          next_state = 2'b01; // State B
        end else if (r[2]) begin
          next_state = 2'b10; // State C
        end else if (r[3]) begin
          next_state = 2'b00; // Stay in A. Since only request 3, give grant later
		  //next_state = 2'b11;  // State D, but we're encoding only A,B,C, so staying in A works.
        end else begin
          next_state = 2'b00; // Stay in A
        end
      end
      2'b01: begin // State B
        if (r[1]) begin
          next_state = 2'b01; // Stay in B
        end else begin
          next_state = 2'b00; // Go to A
        end
      end
      2'b10: begin // State C
        if (r[2]) begin
          next_state = 2'b10; // Stay in C
        end else begin
          next_state = 2'b00; // Go to A
        end
      end
      default: next_state = 2'b00; // Default to state A
    endcase
  end

  // Output logic
  always @(*) begin
    case (current_state)
      2'b00: begin
        g[1] = 1'b0;
        g[2] = 1'b0;
        g[3] = r[3];
      end
      2'b01: begin
        g[1] = 1'b1;
        g[2] = 1'b0;
        g[3] = 1'b0;
      end
      2'b10: begin
        g[1] = 1'b0;
        g[2] = 1'b1;
        g[3] = 1'b0;
      end
      default: begin
        g[1] = 1'b0;
        g[2] = 1'b0;
        g[3] = 1'b0;
      end
    endcase
  end

endmodule