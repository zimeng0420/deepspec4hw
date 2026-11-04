module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_prev;

    always @(posedge clk) begin
        pedge <= 0; // Clear pedge in the beginning of each cycle
        for (int i = 0; i < 8; i++) begin
            if (in[i] && !in_prev[i]) begin
                pedge[i] <= 1;
            end
        end
        in_prev <= in;
    end

endmodule