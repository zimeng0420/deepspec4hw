module top_module (
	input clk,
	input a,
	input b,
	output q,
	output state
);

    reg q_reg;

    always @(posedge clk) begin
        if ((a & b) == 1'b1) begin
            q_reg <= 1'b0;
        end else if ((a == 1'b0) && (b == 1'b1)) begin
            q_reg <= 1'b0;
        end else if ((a == 1'b1) && (b == 1'b0)) begin
            q_reg <= 1'b0;
        end else if ((a == 1'b0) && (b == 1'b0) && (q_reg == 1'b1)) begin
            q_reg <= 1'b1;
        end else if ((a == 1'b0) && (b == 1'b0) && (q_reg == 1'b0)) begin
           q_reg <= 1'b0;
        end
    end

    assign q = q_reg;
    assign state = q_reg;

endmodule