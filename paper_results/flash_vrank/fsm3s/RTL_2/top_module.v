module top_module (
	input clk,
	input in,
	input reset,
	output out
);

  // Define states
  parameter A = 2'b00;
  parameter B = 2'b01;
  parameter C = 2'b10;
  parameter D = 2'b11;

  // State register
  reg state;

  // Next state logic
  reg next_state;

  // Output register - Moore machine: output depends only on the state
  reg out;

  // State transition logic
  always @(posedge clk) begin
    if (reset) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end

  // Next state combinational logic
  always @(*) begin
    case (state)
      A: begin
        if (in == 0) begin
          next_state = A;
        end else begin
          next_state = B;
        end
      end
      B: begin
        if (in == 0) begin
          next_state = C;
        end else begin
          next_state = B;
        end
      end
      C: begin
        if (in == 0) begin
          next_state = A;
        end else begin
          next_state = D;
        end
      end
      D: begin
        if (in == 0) begin
          next_state = C;
        end else begin
          next_state = B;
        end
      end
      default: next_state = A; // Should never happen, but good practice
    endcase
  end

  //Output Logic
  always @(*) begin
    case(state)
      A: out = 0;
      B: out = 0;
      C: out = 0;
      D: out = 1;
      default: out = 0;
    endcase
  end

endmodule