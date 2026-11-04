module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    wire mux1_out;
    wire mux2_out;
    
    assign mux_in[0] = 1'b0;
    assign mux_in[1] = 1'b0;

    assign mux1_out = (c) ? 1'b1 : 1'b0; // Select c for d=0
    assign mux2_out = (c) ? 1'b1 : 1'b1; // Select c for d=1
    
    assign mux_in[2] = (d) ? mux2_out : mux1_out; //outer mux select between mux1_out and mux2_out according to d
    assign mux_in[3] = (d) ? 1'b1 : 1'b1; //outer mux select between mux1_out and mux2_out according to d

endmodule