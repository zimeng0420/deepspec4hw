module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] pedge
);
    reg [7:0] in_reg;
    reg [7:0] pedge_temp;

    always @(posedge clk) begin
        in_reg <= in;
        pedge_temp <= 8'b0; // Reset temporary positive edge signals

        for (int i = 0; i < 8; i++) begin
            if (in_reg[i] == 1'b0 && in[i] == 1'b1) begin
                pedge_temp[i] <= 1'b1; // Set temporary positive edge signal
            end
        end
    end

    always @(posedge clk) begin
        pedge <= pedge_temp;
    end

endmodule