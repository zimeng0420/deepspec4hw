module top_module(
    input clk,
    input rst,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] out_reg;
    reg [31:0] in_prev;

    always @(posedge clk) begin
        if (rst) begin
            out_reg <= 32'b0;
            in_prev <= in; // Initialize in_prev at reset
        end else begin
            in_prev <= in;
            for (int i = 0; i < 32; i = i + 1) begin
                if (in_prev[i] && !in[i]) begin // Detecting 1 -> 0 transition
                    out_reg[i] <= 1'b1;
                end
            end
        end
    end

    assign out = out_reg;

endmodule