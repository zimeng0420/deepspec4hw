module top_module (
	input clock,
	input a, 
	output reg p,
	output reg q
);
    reg q_reg;

    always @(posedge clock) begin
        if (a) begin
            p <= 1'b1;
        end else begin
            p <= 1'b0;
        end
    end

    always @(posedge clock) begin
        if (!a && p) begin
          q_reg <= 1'b1;
        end else if (a) begin
          q_reg <= 1'b1;
        end else begin
          q_reg <= 1'b0;
        end
        q <= q_reg;
    end

endmodule