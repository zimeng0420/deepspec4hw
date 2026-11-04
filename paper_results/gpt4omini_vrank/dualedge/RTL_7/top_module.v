module top_module(
    input clk,
    input d,
    output reg q
);

    reg d1, d2;

    always @(posedge clk) begin
        d1 <= d; // Sample on rising edge
        q <= d1; // Output on rising edge
    end

    always @(negedge clk) begin
        d2 <= d; // Sample on falling edge
        q <= d2; // Output on falling edge
    end

endmodule