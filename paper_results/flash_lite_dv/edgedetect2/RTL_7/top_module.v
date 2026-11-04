module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] in_dly;
    reg [7:0] anyedge_dly; // Intermediate register to hold the edge detection results for one cycle

    always @(posedge clk) begin
        in_dly <= in;
    end

    always @(posedge clk) begin
        for (int i = 0; i < 8; i++) begin
            if (in[i] && !in_dly[i]) begin
                anyedge_dly[i] <= 1'b1;
            end else begin
                anyedge_dly[i] <= 1'b0;
            end
        end
        anyedge <= anyedge_dly;
    end

endmodule