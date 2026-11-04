module top_module(
	input clk, 
	input load, 
	input [9:0] data, 
	output tc
);

  reg [9:0] counter;
  wire tc_internal;

  assign tc = tc_internal;

  always @(posedge clk) begin
    if (load) begin
      counter <= data;
    end else begin
      if (counter > 0) begin
        counter <= counter - 1;
      end
    end
  end

  assign tc_internal = (counter == 0);

endmodule