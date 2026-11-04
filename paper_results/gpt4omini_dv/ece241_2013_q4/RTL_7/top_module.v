module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

reg previous_level; // To store previous level for dfr control

always @(posedge clk) begin
    if (reset) begin
        // Reset state: simulate low water level condition
        fr3 <= 1;
        fr2 <= 1;
        fr1 <= 1;
        dfr <= 0;
        previous_level <= 0; // Low level
    end else begin
        // Update flow rates based on sensor inputs
        if (s[3]) begin
            fr3 <= 0;
            fr2 <= 0;
            fr1 <= 0;
        end else if (s[2]) begin
            fr3 <= 0;
            fr2 <= 0;
            fr1 <= 1;
        end else if (s[1]) begin
            fr3 <= 0;
            fr2 <= 1;
            fr1 <= 1;
        end else begin
            fr3 <= 1;
            fr2 <= 1;
            fr1 <= 1;
        end

        // Determine dfr based on level change
        if ({s[3], s[2], s[1]} > previous_level) begin
            dfr <= 1; // Level has risen
        end else begin
            dfr <= 0; // Level has not risen
        end
        
        // Update previous level for future comparisons
        previous_level <= {s[3], s[2], s[1]};
    end
end

endmodule