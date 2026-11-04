module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);
    reg prev_a; // Register to store the previous value of 'a'

    always @(posedge clock) begin
        // Track the state of 'a' between clock cycles
        prev_a <= a;

        // Evaluate outputs based on the change in 'a' and other conditions
        if (a && !prev_a) begin // Detect rising edge of 'a'
            p <= 1;
        end else begin
            p <= 0;
        end

        if (p) begin  // Set 'q' only when 'p' is high
            q <= 1;
        end else if (!a) begin // Reset 'q' when 'a' becomes low
            q <= 0;
        end
    end
endmodule