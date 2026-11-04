module top_module(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // Combinational logic implementation
    always @(*) begin
        if (L) begin
            Q = r_in;
        end else begin
            Q = q_in ^ r_in;
        end
    end

endmodule