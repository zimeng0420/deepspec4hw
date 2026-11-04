module top_module(
    input clk,
    input d,
    output reg q
);
    reg d_ff1, d_ff2;

    always @(posedge clk) begin
        d_ff1 <= d; // Capture the data on the rising edge
    end

    always @(negedge clk) begin
        d_ff2 <= d_ff1; // Capture the output of d_ff1 on the falling edge
    end

    always @(posedge clk or negedge clk) begin
        q <= (clk) ? d_ff1 : d_ff2; // Update q based on the clock edge
    end
endmodule