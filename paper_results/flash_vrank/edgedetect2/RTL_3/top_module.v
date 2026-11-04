module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    anyedge <= 0; // Reset every clock cycle

    for (int i = 0; i < 8; i++) begin
        if (in[i] && !prev_in[i]) begin
            anyedge[i] <= 1; // Set if transition from 0 to 1 occurred
        end
    end

    prev_in <= in; // Store current input for next cycle
end

endmodule