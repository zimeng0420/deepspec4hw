module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

reg [2:0] prev_level;

always @(posedge clk) begin
    if (reset) begin
        fr1 <= 1;
        fr2 <= 1;
        fr3 <= 1;
        dfr <= 1;
        prev_level <= 3'b000; // Represents no sensors asserted (below s[1])
    end else begin
        // Nominal flow rates
        fr1 <= (s[1] & s[2] & ~s[3]) | (s[1] & ~s[2]) | (~s[1]);
        fr2 <= (s[1] & ~s[2]) | (~s[1]);
        fr3 <= ~s[1];

        // Supplemental flow rate (dfr)
        case ({s[3], s[2], s[1]})
            3'b111: begin // Above s[3]
                if (prev_level < 3'b111) dfr <= 1; else dfr <= 0;
                prev_level <= 3'b111;
            end
            3'b011: begin // Between s[3] and s[2]
                if (prev_level < 3'b011) dfr <= 1; else dfr <= 0;
                prev_level <= 3'b011;
            end
            3'b001: begin // Between s[2] and s[1]
                if (prev_level < 3'b001) dfr <= 1; else dfr <= 0;
                prev_level <= 3'b001;
            end
            3'b000: begin // Below s[1]
                if (prev_level < 3'b000) dfr <= 1; else dfr <= 0;
                prev_level <= 3'b000;
            end
            default: dfr <= 0;
        endcase
    end
end

endmodule