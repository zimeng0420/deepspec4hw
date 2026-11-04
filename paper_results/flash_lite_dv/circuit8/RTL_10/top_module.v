module top_module (
    input clk,
    input a,
    output reg p,
    output reg q
);

  always @(posedge clk) begin
    if (clk) begin
      // Positive edge of clock
      case (a)
        1'b0: begin
          p <= 0;
          q <= q;
        end
        1'b1: begin
          p <= 1;
          q <= q;
        end
      endcase
    end else begin
      // Negative edge of clock
      if(a == 1'b0) begin
          p <= 1;
          q <= 1;
      end else if (a == 1'b1) begin
          p <= 0;
          q <= 0;
      end else begin
          p <= p;
          q <= q;
      end
    end
  end
endmodule