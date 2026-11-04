module top_module(
	input clk,
	input reset,
	output [3:1] ena,
	output reg [15:0] q);

    // Internal registers for each digit
    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    // Intermediate signals for carry-out and enable
    wire ones_carry;
    wire tens_carry;
    wire hundreds_carry;

    // Instantiate the ones digit counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ones <= 4'b0000;
        end else begin
            if (ones == 4'b1001) begin // If ones digit is 9
                ones <= 4'b0000; // Roll over to 0
            end else begin
                ones <= ones + 1'b1; // Increment
            end
        end
    end

    assign ones_carry = (ones == 4'b1001); // Carry out from ones digit

    // Instantiate the tens digit counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tens <= 4'b0000;
        end else begin
            if (ones_carry) begin // Increment if ones digit rolls over
                if (tens == 4'b1001) begin
                    tens <= 4'b0000;
                end else begin
                    tens <= tens + 1'b1;
                end
            end
        end
    end

    assign tens_carry = (tens == 4'b1001) && ones_carry; // Carry out from tens digit

    // Instantiate the hundreds digit counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hundreds <= 4'b0000;
        end else begin
            if (tens_carry) begin // Increment if tens digit rolls over
                if (hundreds == 4'b1001) begin
                    hundreds <= 4'b0000;
                end else begin
                    hundreds <= hundreds + 1'b1;
                end
            end
        end
    end

    assign hundreds_carry = (hundreds == 4'b1001) && tens_carry; // Carry out from hundreds digit

    // Instantiate the thousands digit counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            thousands <= 4'b0000;
        end else begin
            if (hundreds_carry) begin // Increment if hundreds digit rolls over
                if (thousands == 4'b1001) begin
                    thousands <= 4'b0000;
                end else begin
                    thousands <= thousands + 1'b1;
                end
            end
        end
    end

    // Assign enable signals
    assign ena[1] = ones_carry;
    assign ena[2] = tens_carry;
    assign ena[3] = hundreds_carry;

    // Assign the output q
    always @(*) begin
        q = {thousands, hundreds, tens, ones};
    end

endmodule