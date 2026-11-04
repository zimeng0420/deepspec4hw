module top_module (
    input clk,
    input d,
    output reg q
);
    reg d_ff1, d_ff2;

    always @(posedge clk) begin
        d_ff1 <= d; // Capture D on rising edge
    end

    always @(posedge clk) begin
        d_ff2 <= d_ff1; // Pass the value from the first flip-flop to the second
        q <= d_ff2; // Update output at the next rising edge
    end

    always @(negedge clk) begin
        q <= d_ff1; // Update output on falling edge
    end
endmodule