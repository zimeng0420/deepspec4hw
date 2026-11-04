module top_module (
    input clk,
    input a, 
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a == 1) begin
            // Hold previous value
            q <= q;
        end else begin
            // Increment q on every clock cycle when a is low
            q <= (q + 1) % 8; // Count mod 8
        end
    end

endmodule