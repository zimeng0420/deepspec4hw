module top_module(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

  reg [9:0] counter;
  reg tc_internal; // Internal signal for tc

  always @(posedge clk) begin
    if (load) begin
      counter <= data;
      tc_internal <= 0; // Reset tc when loading a new value
    } else begin
      if (counter > 0) begin
        counter <= counter - 1;
        tc_internal <= 0; // tc is low while counting
      } else begin
        counter <= 0; // Stay at 0 once reached
        tc_internal <= 1; // tc is high when count is 0
      end
    end
  end

  assign tc = tc_internal; // Assign internal signal to output

endmodule