module top_module(
	input clk,
	input L,
	input q_in,
	input r_in,
	output reg Q);

  // Submodule: flipflop_mux
  module flipflop_mux (
    input clk,
    input L,
    input data_in,
    input r,
    output reg q
  );

    always @(posedge clk) begin
      if (L) begin
        q <= r;
      end else begin
        q <= data_in;
      end
    end

  endmodule

  wire [2:0] r_internal;
  wire [2:0] q_internal;

  // Instantiate three flipflop_mux modules

  flipflop_mux ff_mux_0 (
    .clk(clk),
    .L(L),
    .data_in(q_internal[1] ^ q_internal[2]),
    .r(r_in),
    .q(q_internal[0])
  );

  flipflop_mux ff_mux_1 (
    .clk(clk),
    .L(L),
    .data_in(q_internal[0]),
    .r(r_in),
    .q(q_internal[1])
  );

  flipflop_mux ff_mux_2 (
    .clk(clk),
    .L(L),
    .data_in(q_internal[2]),
    .r(r_in),
    .q(q_internal[2])
  );

  assign Q = q_internal[0];


  // Assign input to q_internal to start the chain.
  always @(posedge clk) begin
      q_internal[0] <= q_in;
      q_internal[1] <= q_in;
      q_internal[2] <= q_in;
  end



endmodule