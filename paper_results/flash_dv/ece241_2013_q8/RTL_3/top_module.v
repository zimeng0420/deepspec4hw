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

  // Combinational Logic (Next State and Output)
  always @(*) begin
    case (state)
      S0: begin
        if (x) begin
          next_state = S1;
          z = 0;
        end else begin
          next_state = S0;
          z = 0;
        end
      end
      S1: begin
        if (x) begin
          next_state = S1;
          z = 0;
        end else begin
          next_state = S2;
          z = 0;
        end
      end
      S2: begin
        if (x) begin
          next_state = S1;
          z = 1;
        end else begin
          next_state = S0;
          z = 0;
        end
      end
      default: begin
        next_state = S0;
        z = 0;
      end
    endcase
  end

  // Sequential Logic (State Update)
  always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
      state <= S0;
    end else begin
      state <= next_state;
    end
  end

endmodule