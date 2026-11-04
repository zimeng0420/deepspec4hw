module top_module(
    input clk,
    input d,
    output reg q
);
    reg d_ff_pos; // Register to hold d value on rising edge
    reg d_ff_neg; // Register to hold d value on falling edge

    always @(posedge clk) begin
        d_ff_pos <= d; // Capture the d value on rising edge
    end

    always @(negedge clk) begin
        d_ff_neg <= d; // Capture the d value on falling edge
    end

    always @(posedge clk or negedge clk) begin
        q <= d_ff_pos; // Update q on rising edge
        q <= d_ff_neg; // Update q on falling edge
    end
endmodule