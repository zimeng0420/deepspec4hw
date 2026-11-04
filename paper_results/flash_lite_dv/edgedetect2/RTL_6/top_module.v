module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] in_dly;
    reg [7:0] anyedge_dly; // Delayed version of anyedge for the cycle after the transition

    always @(posedge clk) begin
        in_dly <= in;
    end

    always @(posedge clk) begin
        anyedge_dly <= 0;
        for (integer i = 0; i < 8; i = i + 1) begin
            if ((in[i] == 1) && (in_dly[i] == 0)) begin
                anyedge_dly[i] <= 1;
            end
        end
        anyedge <= anyedge_dly;
    end

endmodule