module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    anyedge <= 0; // Reset anyedge at the start of each cycle
    for (int i = 0; i < 8; i = i + 1) begin
        if (in[i] == 1'b1 && prev_in[i] == 1'b0) begin
            anyedge[i] <= 1'b1;
        end
    end
    prev_in <= in;
end

endmodule