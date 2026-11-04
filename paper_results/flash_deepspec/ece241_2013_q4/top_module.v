module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

reg [3:1] prev_s;

always @(posedge clk) begin
    if (reset) begin
        fr1 <= 1;
        fr2 <= 1;
        fr3 <= 1;
        dfr <= 1;
        prev_s <= 3'b000;
    end else begin
        case (s)
            3'b111: begin
                fr1 <= 0;
                fr2 <= 0;
                fr3 <= 0;
            end
            3'b110: begin
                fr1 <= 1;
                fr2 <= 0;
                fr3 <= 0;
            end
            3'b010: begin
                fr1 <= 1;
                fr2 <= 0;
                fr3 <= 0;
            end
            3'b001: begin
                fr1 <= 1;
                fr2 <= 1;
                fr3 <= 0;
            end
            3'b000: begin
                fr1 <= 1;
                fr2 <= 1;
                fr3 <= 1;
            end
            default: begin
                fr1 <= 1;
                fr2 <= 1;
                fr3 <= 1;
            end
        endcase

        if ((s > prev_s) && !reset) begin
            dfr <= 1;
        end else begin
            dfr <= 0;
        end

        prev_s <= s;
    end
end

endmodule