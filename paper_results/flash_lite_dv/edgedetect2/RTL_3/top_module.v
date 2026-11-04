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
        anyedge_dly[0] <= (in[0] & ~in_dly[0]);
        anyedge_dly[1] <= (in[1] & ~in_dly[1]);
        anyedge_dly[2] <= (in[2] & ~in_dly[2]);
        anyedge_dly[3] <= (in[3] & ~in_dly[3]);
        anyedge_dly[4] <= (in[4] & ~in_dly[4]);
        anyedge_dly[5] <= (in[5] & ~in_dly[5]);
        anyedge_dly[6] <= (in[6] & ~in_dly[6]);
        anyedge_dly[7] <= (in[7] & ~in_dly[7]);
        anyedge <= anyedge_dly;
    end

endmodule