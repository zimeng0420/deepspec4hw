module top_module (
	input clk,
	input a,
	input b,
	output q,
	output state
);

    reg q;
    reg prev_a;
    reg prev_b;

    always @(posedge clk) begin
        prev_a <= a;
        prev_b <= b;

        if (a == 1 && b == 1) begin
            q <= ~q;
        end
        else if (a != b) begin
            q <= ~q;
        end
    end

    assign state = q;

endmodule