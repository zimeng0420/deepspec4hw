module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    pedge <= {8{1'b0}}; // Reset pedge every clock cycle
    for (int i = 0; i < 8; i++) begin
        if (!prev_in[i] && in[i]) begin
            pedge[i] <= 1'b1;
        end
    end
    prev_in <= in;
end

endmodule