module top_module(
	input clk,
	input reset,
	output [3:1] ena,
	output reg [15:0] q
);

    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Ones digit increment
            if (ones == 4'd9)
                ones <= 4'd0;
            else
                ones <= ones + 1'b1;

            // Tens digit increment
            if (ones == 4'd9) begin
                if (tens == 4'd9)
                    tens <= 4'd0;
                else
                    tens <= tens + 1'b1;
            end

            // Hundreds digit increment
            if (tens == 4'd9 && ones == 4'd9) begin
                if (hundreds == 4'd9)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 1'b1;
            end

            // Thousands digit increment
            if (hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 1'b1;
            end
        end
    end

    // Ena signals
    assign ena[1] = (ones == 4'd9);
    assign ena[2] = (tens == 4'd9 && ones == 4'd9);
    assign ena[3] = (hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9);
   
    always @(*) begin
        q[3:0]   = ones;
        q[7:4]   = tens;
        q[11:8]  = hundreds;
        q[15:12] = thousands;
    end

endmodule