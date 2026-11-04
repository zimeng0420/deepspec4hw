module top_module (
	input clock,
	input a, 
	output reg p,
	output reg q
);
    reg q_reg;
    always @(posedge clock) begin
        if (a) begin
            q_reg <= 1;
        end else begin
            q_reg <= 0;
        end
    end

    always @(*) begin
        if (a) begin
            p = q_reg;
        end else begin
            p = 0;
        end
    end
    
    always @(posedge clock) begin
        q <= q_reg;
    end

endmodule