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
      shift_ena <= 1;
    end else begin
      if (count < 3) begin
        shift_ena <= 1;
        count <= count + 1;
      end else begin
        shift_ena <= 0;
        count <= 4; 
      end
    end
  end

endmodule