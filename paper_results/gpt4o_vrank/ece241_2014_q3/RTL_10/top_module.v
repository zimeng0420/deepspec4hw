module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    // Implementing the Karnaugh map with minimal use of 2-to-1 multiplexers

    // mux_in[0] corresponds to ab=00
    assign mux_in[0] = 1'b0; // Always 0
    
    // mux_in[1] corresponds to ab=01
    assign mux_in[1] = 1'b0; // Always 0

    // mux_in[2] corresponds to ab=11
    assign mux_in[2] = c; // When ab=11, the output is 1 if c=1
    
    // mux_in[3] corresponds to ab=10
    assign mux_in[3] = (~c & ~d) | (c & d); // Implementing the logic for this case

endmodule