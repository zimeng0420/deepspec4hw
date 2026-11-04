module top_module(
	input clk,
	input reset,
	output [3:1] ena,
	output reg [15:0] q);
    
    reg [3:0] ones, tens, hundreds, thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'b0000;
            tens <= 4'b0000;
            hundreds <= 4'b0000;
            thousands <= 4'b0000;
        end else begin
            if (ones < 4'b1001) begin
                ones <= ones + 1;
                ena[1] <= 0;
            end else begin
                ones <= 4'b0000;
                ena[1] <= 1;

                if (tens < 4'b1001) begin
                    tens <= tens + 1;
                end else begin
                    tens <= 4'b0000;
                    ena[2] <= 1;

                    if (hundreds < 4'b1001) begin
                        hundreds <= hundreds + 1;
                    end else begin
                        hundreds <= 4'b0000;
                        ena[3] <= 1;

                        if (thousands < 4'b1001) begin
                            thousands <= thousands + 1;
                        end else begin
                            thousands <= 4'b0000;
                        end
                    end
                end
            end
        end
    end
    
    assign q = {thousands, hundreds, tens, ones};

endmodule