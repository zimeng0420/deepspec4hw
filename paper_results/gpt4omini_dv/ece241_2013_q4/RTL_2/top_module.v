module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

reg [3:1] previous_s;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        fr3 <= 1'b1;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        dfr <= 1'b0;
        previous_s <= 3'b000;
    end else begin
        previous_s <= s;
        
        // Combinational Logic
        if (s[3]) begin // Above s[3]
            fr3 <= 1'b0;
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            dfr <= 1'b0;
        end else if (!s[1]) begin // Below s[1]
            fr3 <= 1'b1;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            dfr <= 1'b0;
        end else if (s[2]) begin // Between s[3] and s[2]
            fr3 <= 1'b0;
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            dfr <= (previous_s < s) ? 1'b1 : 1'b0; // rise in water level
        end else if (s[1]) begin // Between s[2] and s[1]
            fr3 <= 1'b0;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            dfr <= (previous_s < s) ? 1'b1 : 1'b0; // rise in water level
        end
    end
end

endmodule