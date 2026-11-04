module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state
);

    reg q_reg;
    assign q = q_reg;
    assign state = q_reg;

    always @(posedge clk) begin
        if (a == 0 && b == 0) begin
            q_reg <= 0;
        end else if (a == 1 && b == 1) begin
            q_reg <= 1;
        end else begin
            // Keep previous state
        end
		if(a == 0 && b ==1)
			q_reg <=0;
		if(a == 1 && b==0)
			q_reg <= 0;
    end

endmodule