module top_module (
	input clock,
	input a, 
	output reg p,
	output reg q
);

    reg state;

    always @(posedge clock) begin
        if (a) begin
            state <= 1;
        end else begin
            state <= 0;
        end
    end

    always @(posedge clock) begin
        if (a) begin
            p <= state;
        end else begin
            p <= 0;
        end
    end

    always @(posedge clock) begin
        if (a && state) begin
            q <= 1;
        end
        else if (!a && state)
            q <= 1;
        else
            q <= 0;
    end

endmodule