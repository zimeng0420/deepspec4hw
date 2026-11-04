module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    anyedge <= 0; // Reset anyedge every clock cycle
    for (int i = 0; i < 8; i++) begin
        if (!prev_in[i] && in[i]) begin
            anyedge[i] <= 1;
        end
    end
    prev_in <= in;
end

endmodule