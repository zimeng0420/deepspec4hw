module top_module (
    input clk,
    input a,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a == 1'b1) begin
            // Hold current value when a is high
            q <= q;
        end else begin
            // Increment q on each clock cycle when a is low
            q <= (q + 1) % 8; // Modulo 8 for wrapping around
        end
    end

endmodule