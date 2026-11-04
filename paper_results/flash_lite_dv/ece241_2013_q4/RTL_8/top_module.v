module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    always @(posedge clk) begin
        if (reset) begin
            fr1 <= 1;
            fr2 <= 1;
            fr3 <= 1;
            dfr <= 1;
        end else begin
            fr1 <= s[1] | s[2];
            fr2 <= s[1];
            fr3 <= s[1] & s[2] & s[3];
            dfr <= 0;
        end
    end

endmodule