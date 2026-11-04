module top_module (
    input c,
    input d,
    output [3:0] mux_in
);
    wire w1, w2, w3, w4;
    
    // Implement conditions based on the K-map for each mux_in output
    
    // For mux_in[0] (ab = 00, cd = 00)
    assign mux_in[0] = 1'b0; // K-map value for cd = 00
    
    // For mux_in[1] (ab = 01, cd = 01)
    assign mux_in[1] = 1'b0; // K-map value for cd = 01
    
    // For mux_in[2] (ab = 11, cd = 11)
    assign w1 = c; // K-map value for cd = 11, output should be 1 when c = 1
    assign mux_in[2] = w1; // K-map value for cd = 11
    
    // For mux_in[3] (ab = 10, cd = 10)
    assign w2 = c; // K-map value for cd = 10, output should be 1 when c = 1    
    assign w3 = 1'b1; // K-map value for cd = 01, output should be 1
    assign mux_in[3] = (d) ? w3 : w2; // Select between 0 (when d=0) or 1 (when d=1) based on c and d

endmodule