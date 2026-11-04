module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);
    reg prev_a;

    always @(posedge clock) begin
        // Record previous 'a' value
        prev_a <= a;

        // At rising edge of clock, set 'p' if 'a' was high in the previous cycle
        if (prev_a)
            p <= 1;
        else
            p <= 0;
    end

    always @(negedge clock) begin
        // At the falling edge, 'q' should follow 'p'
        q <= p;
    end

    initial begin
        p = 0;
        q = 0;
        prev_a = 0;
    end
endmodule