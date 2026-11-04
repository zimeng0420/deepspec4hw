module top_module (
    input a, 
    input b, 
    input c, 
    input d,
    output q
);

// Logic implementation derived from the simulation waveforms
assign q = (a & b & c) | (a & b & ~d) | (a & ~b & d) | (~a & b & d);

endmodule