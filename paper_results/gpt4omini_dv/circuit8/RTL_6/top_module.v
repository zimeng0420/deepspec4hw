module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);

    always @(posedge clock) begin
        if (a == 1) begin
            p <= p + 1; // Increment p based on previous state
            q <= 0;     // Reset q to 0 when a is high
        end else begin
            if (p > 0) begin
                q <= 1; // Set q to 1 if p is non-zero
            end else begin
                q <= 0; // Ensure q is 0 if p is also 0
            end
        end
    end

    // Initialization
    initial begin
        p = 0;
        q = 0;
    end

endmodule