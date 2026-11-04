module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);

  reg [2:0] current_state;
  reg [2:0] next_state;

  // State Definitions (Optional, but improves readability)
  localparam S000 = 3'b000;
  localparam S001 = 3'b001;
  localparam S010 = 3'b010;
  localparam S011 = 3'b011;
  localparam S100 = 3'b100;

  // State Register Update (Synchronous Reset)
  always @(posedge clk) begin
    if (reset) begin
      current_state <= S000; // Reset to state 000
    end else begin
      current_state <= next_state;
    end
  end

  // Next State Logic (Combinational)
  always @(*) begin
    case (current_state)
      S000: begin
        if (x == 0) next_state = S000;
        else next_state = S001;
      end
      S001: begin
        if (x == 0) next_state = S001;
        else next_state = S100;
      end
      S010: begin
        if (x == 0) next_state = S010;
        else next_state = S001;
      end
      S011: begin
        if (x == 0) next_state = S001;
        else next_state = S010;
      end
      S100: begin
        if (x == 0) next_state = S011;
        else next_state = S100;
      end
      default: next_state = S000; // Default to reset state in case of unexpected state
    endcase
  end

  // Output Logic (Combinational)
  always @(*) begin
    case (current_state)
      S000: z = 0;
      S001: z = 0;
      S010: z = 0;
      S011: z = 1;
      S100: z = 1;
      default: z = 0; // Default output
    endcase
  end

endmodule