module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);
    always @(posedge clock) begin
        // State transitions based on input `a`
        if (a) begin
            p <= 1; // Set p to 1 if a is high
            q <= q; // Keep q unchanged 
        end else begin
            p <= 0; // Set p to 0 if a is low
            if (p) begin
                q <= 1; // Set q to 1 if p was high
            end
            else begin
                q <= 0; // q remains low otherwise
            end
        end
    end
endmodule