module top_module(
    input clk,
    input reset,
    output reg shift_ena
);

  reg [1:0] count;

  always @(posedge clk) begin
    if (reset) begin
      count <= 0;
      shift_ena <= 1;
    } else begin
      if (count < 3) begin
        count <= count + 1;
        shift_ena <= 1;
      } else begin
        count <= 3;
        shift_ena <= 0;
      end
    end
  end

endmodule