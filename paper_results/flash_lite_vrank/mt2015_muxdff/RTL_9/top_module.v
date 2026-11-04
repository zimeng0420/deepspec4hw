module top_module(
	input clk,
	input L,
	input q_in,
	input r_in,
	output reg Q
);

  // Submodule: Flip-Flop and 2:1 Multiplexer
  module ff_mux (
    input clk,
    input L,
    input r,
    input q_in,
    output reg Q
  );

    always @(posedge clk) begin
      if (L) begin
        Q <= r;
      end else begin
        Q <= q_in;
      end
    end

  endmodule


  // Instantiate the submodule three times
  reg [2:0] r_internal;
  reg [2:0] q_internal;

  always @(*) begin
    r_internal[0] = r_in;
    r_internal[1] = (L) ? r_in : q_internal[1] ^ q_internal[2];
    r_internal[2] = (L) ? r_in : q_internal[2];
  end


  ff_mux ff_mux_inst0 (
    .clk(clk),
    .L(L),
    .r(r_internal[0]),
    .q_in(q_internal[0]),
    .Q(q_internal[0])
  );

  ff_mux ff_mux_inst1 (
    .clk(clk),
    .L(L),
    .r(r_internal[1]),
    .q_in(q_internal[1]),
    .Q(q_internal[1])
  );

  ff_mux ff_mux_inst2 (
    .clk(clk),
    .L(L),
    .r(r_internal[2]),
    .q_in(q_internal[2]),
    .Q(Q)
  );
endmodule