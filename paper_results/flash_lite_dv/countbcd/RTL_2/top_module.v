module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q
);

    reg [3:0] ones_digit;
    reg [3:0] tens_digit;
    reg [3:0] hundreds_digit;
    reg [3:0] thousands_digit;

    // Combinational Logic for Enable Signals
    assign ena[1] = (ones_digit == 4'd9);
    assign ena[2] = (tens_digit == 4'd9) && (ones_digit == 4'd9);
    assign ena[3] = (hundreds_digit == 4'd9) && (tens_digit == 4'd9) && (ones_digit == 4'd9);

    // Sequential Logic (Counter)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ones_digit <= 4'd0;
            tens_digit <= 4'd0;
            hundreds_digit <= 4'd0;
            thousands_digit <= 4'd0;
        end else begin
            if (ena[3])
                thousands_digit <= (thousands_digit == 4'd9) ? 4'd0 : thousands_digit + 4'd1;
            if (ena[2])
                hundreds_digit <= (hundreds_digit == 4'd9) ? 4'd0 : hundreds_digit + 4'd1;
            if (ena[1])
                tens_digit <= (tens_digit == 4'd9) ? 4'd0 : tens_digit + 4'd1;
            ones_digit <= (ones_digit == 4'd9) ? 4'd0 : ones_digit + 4'd1;
        end
    end

    // Combinational Logic for Output q
    always @(*) begin
      q = {thousands_digit, hundreds_digit, tens_digit, ones_digit};
    end

endmodule