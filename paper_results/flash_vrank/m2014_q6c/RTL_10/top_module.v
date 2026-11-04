module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);

    assign Y2 = y[1] & ~w;  // Next state B (y[2]) is reached from A (y[1]) with input 0 (~w)
    assign Y4 = y[2] & w | y[3] & w | y[5] & w | y[6] & w; // Next state D (y[4]) is reached from B(y[2]) with input w OR from C(y[3]) with input w OR from E(y[5]) with input w OR from F(y[6]) with input w

endmodule