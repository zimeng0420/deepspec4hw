module top_module(
    input clk,
    input rst,
    input [31:0] input_vector,
    output reg [31:0] output_vector
);

    reg [31:0] prev_input_vector;

    always @(posedge clk) begin
        if (rst) begin
            output_vector <= 32'b0;
        end else begin
            prev_input_vector <= input_vector;
            for (int i = 0; i < 32; i++) begin
                if (input_vector[i] == 0 && prev_input_vector[i] == 1) begin
                    output_vector[i] <= 1;
                end
            end
        end
    end
endmodule