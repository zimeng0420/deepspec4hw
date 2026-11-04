module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    pedge <= {8{1'b0}}; // Initialize to zero

    for (int i = 0; i < 8; i = i + 1) begin
        if ((prev_in[i] == 1'b0) && (in[i] == 1'b1)) begin
            pedge[i] <= 1'b1;
        end
    end
    prev_in <= in;
end

endmodule