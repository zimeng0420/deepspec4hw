module top_module(
	input x,
	input y,
	output z
);

  reg z_internal;
  reg [6:0] counter;

  always @(posedge x or posedge y) begin
    if (x || y) begin
      counter <= counter + 1'b1;
    end else begin
        counter <= 0;
    end

    case (counter)
      0, 1, 2, 3, 4, 5:        z_internal <= 1;
      6, 7:                   z_internal <= 0;
      8, 9:                   z_internal <= 0;
      10, 11:                 z_internal <= 1;
      12:                     z_internal <= 1;
      13,14,15,16:                 z_internal <= 0;
      17, 18, 19:                 z_internal <= 0;
      20, 21, 22:                 z_internal <= 1;
      default:                z_internal <= 0;
    endcase
  end

  assign z = z_internal;
endmodule