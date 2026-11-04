module top_module (
    input clk,
    input in,
    input reset,
    output out
);

  reg state;
  localparam A = 0, B = 1;

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
        default: state <= B; //default state
      endcase
    end
  end

  assign out = (state == B) ? 1 : 0;

endmodule