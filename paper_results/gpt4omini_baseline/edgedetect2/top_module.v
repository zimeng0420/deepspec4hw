module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] anyedge
);

reg [7:0] in_prev;

always @(posedge clk) begin
    anyedge <= 0; // Reset output
    anyedge[0] <= (in[0] == 1 && in_prev[0] == 0);
    anyedge[1] <= (in[1] == 1 && in_prev[1] == 0);
    anyedge[2] <= (in[2] == 1 && in_prev[2] == 0);
    anyedge[3] <= (in[3] == 1 && in_prev[3] == 0);
    anyedge[4] <= (in[4] == 1 && in_prev[4] == 0);
    anyedge[5] <= (in[5] == 1 && in_prev[5] == 0);
    anyedge[6] <= (in[6] == 1 && in_prev[6] == 0);
    anyedge[7] <= (in[7] == 1 && in_prev[7] == 0);
    in_prev <= in; // Update previous input
end

endmodule