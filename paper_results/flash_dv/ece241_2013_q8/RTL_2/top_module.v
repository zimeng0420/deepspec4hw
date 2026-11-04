module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

  reg [1:0] state;
  reg [1:0] next_state;

  // State Encoding
  localparam S0 = 2'b00;
  localparam S1 = 2'b01;
  localparam S2 = 2'b10;

  // Next State Logic
  always @(*) begin
    case (state)
      S0: begin
        if (x)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if (x)
          next_state = S1;
        else
          next_state = S2;
      end
      S2: begin
        if (x)
          next_state = S1;
        else
          next_state = S0;
      end
      default: next_state = S0; // Default case to avoid latch
    endcase
  end

  // Output Logic
  always @(*) begin
    if (state == S2 && x == 1)
      z = 1;
    else
      z = 0;
  end

  // State Update Logic
  always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
      state <= S0;
    end else begin
      state <= next_state;
    end
  end

endmodule