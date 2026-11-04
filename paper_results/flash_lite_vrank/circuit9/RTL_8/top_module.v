module top_module (
	input clk,
	input a, 
	output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'b100; // 4
    end else begin
        if (q == 3'b100) begin // 4
            q <= q + 1;
        end else if (q == 3'b101) begin // 5
            q <= q + 1;
        end else if (q == 3'b110) begin // 6
            q <= 3'b000; // 0
        end else begin
            q <= q + 1;
        end
    end
end

endmodule