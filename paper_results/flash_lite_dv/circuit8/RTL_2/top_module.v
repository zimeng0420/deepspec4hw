module top_module (
    input clock,
    input a,
    output reg p,
    output reg q
);

  always @(posedge clock) begin
    if (clock) begin
        if (a) begin
            p <= !q;
            q <= 1'b1;
        end else begin
            p <= 1'b0;
            q <= q;
        end
    end else begin
      
    end
  end

endmodule