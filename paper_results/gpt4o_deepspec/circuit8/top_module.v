module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);

    always @(posedge clock) begin
        p <= a;        // 'p' follows the value of 'a' on the rising edge of the clock
        q <= p;        // 'q' follows the value of 'p' (with a one clock cycle delay)
    end

endmodule