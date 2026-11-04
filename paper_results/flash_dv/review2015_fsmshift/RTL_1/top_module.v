module top_module(
    input clk,
    input reset,
    output shift_ena
);

  reg [2:0] count;
  reg shift_ena;

  always @(posedge clk) begin
    if (reset) begin
      count <= 0;
      shift_ena <= 1'b1;
    end else begin
      if (count < 3) begin
        count <= count + 1;
        shift_ena <= 1'b1;
      end else begin
        count <= 3;
        shift_ena <= 1'b0;
      end
    end
  end

endmodule