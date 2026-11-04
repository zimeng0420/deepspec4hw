module top_module(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'b0;
    end else begin
        prev_in <= in; // Store previous state
        for (int i = 0; i < 32; i = i + 1) begin
            if (prev_in[i] == 1 && in[i] == 0) begin
                out[i] <= 1'b1; // Set output high on transition
            end
        end
    end
end

endmodule