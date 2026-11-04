module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

  // Define the states
  localparam S0 = 3'b000;
  localparam S1 = 3'b001;
  localparam S2 = 3'b010;
  localparam S3 = 3'b011;
  localparam S4 = 3'b100;
  localparam S5 = 3'b101;

  // State register
  reg [2:0] current_state;
  reg [2:0] next_state;

  // State transition logic
  always @(posedge clk) begin
    if (reset) begin
      current_state <= S0;
      start_shifting <= 0;
    end else begin
      current_state <= next_state;
      if (current_state == S4)
        start_shifting <= 1;
    end
  end

  // Next state logic
  always @(*) begin
    case (current_state)
      S0: begin
        if (data)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if (data)
          next_state = S2;
        else
          next_state = S0;
      end
      S2: begin
        if (data)
          next_state = S1;
        else
          next_state = S3;
      end
      S3: begin
        if (data)
          next_state = S4;
        else
          next_state = S0;
      end
      S4: begin
        next_state = S5;
      end
      S5: begin
        next_state = S5;
      end
      default: next_state = S0; // Should never happen, but good practice
    endcase
  end

  // Output logic (Alternative implementation)
  always @(posedge clk) begin
    if (reset)
      start_shifting <= 0;
    else if (current_state == S4)
      start_shifting <= 1;
  end

endmodule