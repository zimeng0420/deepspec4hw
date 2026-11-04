module top_module (
    input clk,
    input a, 
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a == 1) begin
            // Hold the current value of q
            q <= q;
        end else begin
            // Increment q, cycling through 0-7 (modulo 8)
            q <= (q + 1) % 8;
        end
    end
endmodule