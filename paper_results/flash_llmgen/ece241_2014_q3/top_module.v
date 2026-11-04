module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

wire not_d;
wire or_cd;
wire and_cd;

assign not_d = ~d;

// Implement c | ~d using a 2-to-1 mux
assign or_cd = d ? c : 1'b1;

// Implement c & d using a 2-to-1 mux
assign and_cd = d ? c : 1'b0;

assign mux_in[0] = or_cd;
assign mux_in[1] = 1'b0;
assign mux_in[2] = and_cd;
assign mux_in[3] = or_cd;

endmodule