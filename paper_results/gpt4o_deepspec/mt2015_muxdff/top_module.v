module top_module(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);
    // Combinational logic: 2-to-1 multiplexer
    always @(*) begin
        if (L) begin
            Q = r_in;
        end else begin
            Q = q_in;
        end
    end
endmodule

module full_module (
    input [2:0] r,
    input L,
    input clk,
    output reg [2:0] q
);
    wire [2:0] mux_output;

    // Instantiating top_module 3 times for 3-bit hierarchical design
    top_module mux0 (
        .clk(clk), 
        .L(L), 
        .q_in(q[0]), 
        .r_in(r[0]), 
        .Q(mux_output[0])
    );

    top_module mux1 (
        .clk(clk), 
        .L(L), 
        .q_in(q[1]), 
        .r_in(r[1]), 
        .Q(mux_output[1])
    );

    top_module mux2 (
        .clk(clk), 
        .L(L), 
        .q_in(q[2]), 
        .r_in(r[2]), 
        .Q(mux_output[2])
    );

    // Sequential logic: Updating q on positive edge of clk
    always @(posedge clk) begin
        q <= mux_output;
    end
endmodule