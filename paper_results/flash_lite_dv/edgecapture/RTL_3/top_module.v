module top_module (
    input clk,
    input rst,
    input [31:0] data_in,
    output reg [31:0] data_out
);

    reg [31:0] data_in_reg;

    always @(posedge clk) begin
        data_in_reg <= data_in;
    end

    always @(posedge clk) begin
        if (rst) begin
            data_out <= 32'b0;
        end else begin
            for (int i = 0; i < 32; i = i + 1) begin
                if (data_in_reg[i] == 1'b1 && data_in[i] == 1'b0) begin
                    data_out[i] <= 1'b1;
                end
            end
        end
    end

endmodule