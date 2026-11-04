module top_module (
    input clk,
    input rst,
    input [31:0] input_signal,
    output reg [31:0] output_signal
);

    reg [31:0] prev_input;

    always @(posedge clk) begin
        prev_input <= input_signal;
    end

    always @(posedge clk) begin
        if (rst) begin
            output_signal <= 32'b0;
        end else begin
            for (int i = 0; i < 32; i = i + 1) begin
                if (prev_input[i] && !input_signal[i]) begin
                    output_signal[i] <= 1'b1;
                end
            end
        end
    end

endmodule