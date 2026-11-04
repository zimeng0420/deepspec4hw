module top_module(
    input clk,
    input rst,
    input [31:0] data_in,
    output [31:0] data_out
);

    reg [31:0] data_out_reg;
    reg [31:0] prev_data_in;

    always @(posedge clk) begin
        if (rst) begin
            data_out_reg <= 32'b0;
            prev_data_in <= data_in;
        end else begin
            data_out_reg <= data_out_reg | (~data_in & prev_data_in);
            prev_data_in <= data_in;
        end
    end

    assign data_out = data_out_reg;

endmodule