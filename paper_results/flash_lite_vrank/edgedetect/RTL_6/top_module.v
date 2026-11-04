module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] pedge);

    reg [7:0] prev_in;
    reg [7:0] pedge_internal;

    always @(posedge clk) begin
        pedge_internal <= 8'b0;
        for (int i = 0; i < 8; i++) begin
            if (in[i] && !prev_in[i]) begin
                pedge_internal[i] <= 1'b1;
            end
        end
        prev_in <= in;
    end

    always @(posedge clk) begin
        pedge <= pedge_internal;
    end
endmodule