module top_module (
	input clk,
	input a,
	input b,
	output q,
	output state
);

    reg q_reg;

    always @(posedge clk) begin
        if ((a & b) | ((~a) & (~b))) begin
            q_reg <= 0;
        end else begin
            q_reg <= (a ^ b) ? ~q_reg : q_reg;
        end
    end

    assign q = q_reg;
    assign state = q_reg;

endmodule