module top_module (
    input clk,
    input in,
    input reset,
    output out
);

  reg state;
  reg out;

  // State definition
  localparam A = 0, B = 1;

  // State transition logic
  always @(posedge clk) begin
    if (reset) begin
      state <= B;
    end else begin
      case (state)
        A: begin
          if (in == 0) begin
            state <= B;
          end else begin
            state <= A;
          end
        end
        B: begin
          if (in == 0) begin
            state <= A;
          end else begin
            state <= B;
          end
        end
        default: state <= B; // Should not happen, but good practice
      endcase
    end
  end

  // Output logic (Moore machine)
  always @(state) begin
    case (state)
      A: out = 0;
      B: out = 1;
      default: out = 1; // Should not happen, but good practice
    endcase
  end

endmodule