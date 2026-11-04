module top_module(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        // Shift operation if shift_ena is high
        if (shift_ena) begin
            q <= {data, q[3:1]}; // Shift left, new bit in MSB
        end
        // Count down operation if count_ena is high
        else if (count_ena) begin
            if (q > 0) begin
                q <= q - 1; // Decrement the counter
            end
        end
    end
endmodule