module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] in_dly;
    reg [7:0] anyedge_dly;

    always @(posedge clk) begin
        in_dly <= in;
    end

    always @(posedge clk) begin
        for (integer i = 0; i < 8; i = i + 1) begin
            if (in[i] && !in_dly[i]) begin
                anyedge_dly[i] <= 1'b1;
            end else begin
                anyedge_dly[i] <= 1'b0;
            end
        end
        anyedge <= anyedge_dly;
    end

endmodule