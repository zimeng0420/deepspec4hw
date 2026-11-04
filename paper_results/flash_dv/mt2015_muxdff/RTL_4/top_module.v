module top_module(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

reg mux_out;

always @(*) begin
    if (L) begin
        mux_out = r_in;
    end else begin
        mux_out = q_in;
    end
end

always @(posedge clk) begin
    Q <= mux_out;
end

endmodule