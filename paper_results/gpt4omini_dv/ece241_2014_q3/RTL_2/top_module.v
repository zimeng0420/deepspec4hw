module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    wire mux1_out; // Output of 1st 2-to-1 MUX for mux_in[1]
    wire mux2_out; // Output of 2nd 2-to-1 MUX for mux_in[2]
    
    // mux_in[0] is always 0
    assign mux_in[0] = 0;
    
    // mux_in[1]: direct connection to c
    assign mux_in[1] = c; 
    
    // mux_in[2] = c + d
    // Using 2-to-1 MUX to realize c + d
    // When d=0, select c; when d=1, select 1 (logical high)
    // The output will be high if c is high or d is high
    assign mux2_out = d ? 1'b1 : c;
    assign mux_in[2] = mux2_out;

    // mux_in[3]: direct connection to c
    assign mux_in[3] = c;

endmodule