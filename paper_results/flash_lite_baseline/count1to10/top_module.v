module top_module(
	input clk,
	input reset,
	output reg [3:0] q);

    reg [3:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'd1;
        end else begin
            if (count == 4'd10) begin
                count <= 4'd1;
            end else begin
                count <= count + 1;
            end
        end
    end

    always @(*) begin
        q = count;
    end

endmodule