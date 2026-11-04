module top_module (
	input clk,
	input reset,
	input s,
	input w,
	output reg z
);

  reg [2:0] state;
  reg [1:0] count; // Count of 1s in the last three cycles
  reg z_next;

  // State definitions
  localparam A = 3'b000; // Reset state
  localparam B = 3'b001; // Monitoring state 1
  localparam C = 3'b010; // Monitoring state 2
  localparam D = 3'b011; // Monitoring state 3
  localparam E = 3'b100; // Output state

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      z <= 0;
    end else begin
      state <= state_next;
      z <= z_next;
    end
  end

  always @(*) begin
    state_next = state;
    z_next = 0; // Default value

    case (state)
      A: begin
        if (s) begin
          state_next = B;
        end else begin
          state_next = A;
        end
        z_next = 0;
      end
      B: begin
        state_next = C;
        count = w ? 2'b01 : 2'b00;
      end
      C: begin
        state_next = D;
        count = {count[0], w};
      end
      D: begin
        state_next = E;
        count = {count[0], w};
      end
      E: begin
        state_next = B;
        if (count == 2'b10) begin
          z_next = 1;
        end else begin
          z_next = 0;
        end
      end
      default: state_next = A; // Should not happen, but good practice
    end
  end

endmodule