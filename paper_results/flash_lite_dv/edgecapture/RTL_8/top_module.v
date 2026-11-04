module top_module(
    input clk,
    input rst,      // Active high synchronous reset
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] out_reg;
    reg [31:0] in_prev;

    always @(posedge clk) begin
        if (rst) begin
            out_reg <= 32'b0;
            in_prev <= in;
        end else begin
            for (int i = 0; i < 32; i++) begin
                if (in_prev[i] == 1'b1 && in[i] == 1'b0) begin
                    out_reg[i] <= 1'b1;
                end
            end
            in_prev <= in;
        end
    end

    assign out = out_reg;

endmodule