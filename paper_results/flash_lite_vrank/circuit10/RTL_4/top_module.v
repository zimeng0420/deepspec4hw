module top_module (
	input clk,
	input a,
	input b,
	output q,
	output state
);

    reg q_reg;

    always @(posedge clk) begin
        if (a & b) begin
            q_reg <= 1'b0;
        end else if (~a & b) begin
            q_reg <= 1'b0;
        end else if (a & ~b) begin
            q_reg <= 1'b0;
        end else if (~a & ~b) begin
            q_reg <= q_reg;
        end
        else if (~q_reg & ~b) begin
            q_reg <= q_reg;
        end
        else if(q_reg & ~b) begin
            q_reg <= 1'b1;
        end
        else
            q_reg <= q_reg;
    end

    assign q = q_reg;
    assign state = q_reg;

endmodule