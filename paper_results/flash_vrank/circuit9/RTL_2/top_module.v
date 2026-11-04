module top_module (
    input clk,
    input a,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a) begin
            q <= 4;
        } else begin
            q <= q + 1;
        end
		if (q == 7)
			q <= 0;
    end

endmodule