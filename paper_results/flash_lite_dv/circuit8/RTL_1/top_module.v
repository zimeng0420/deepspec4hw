module top_module (
    input clock,
    input a,
    output reg p,
    output reg q
);

  always @(posedge clock) begin
    if (clock) begin
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
      if(a==1'b1) begin
        p <= 0;
        q <= 0;
      end
      else begin
        p <= p;
        q <= q;
      end

    end
    
  end

endmodule