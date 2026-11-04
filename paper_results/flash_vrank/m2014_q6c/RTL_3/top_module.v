module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);

    assign Y2 = y[1] & ~w;  // B is next state, transitions from A with input 0
    assign Y4 = y[2] & w | y[3] & w | y[5] & w | y[6] & w;  // D is next state, transitions from B with input 1, C with input 1, E with input 1, F with input 1
    
endmodule