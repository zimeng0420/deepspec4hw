module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

reg [1:0] current_level;
reg [1:0] previous_level;

always @(posedge clk) begin
    if (reset) begin
        fr3 <= 1'b1;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        dfr <= 1'b1;
        previous_level <= 2'b11; // Represents below s[1]
    end else begin
        // Determine current water level
        if (s[1] && s[2] && s[3]) begin
            current_level <= 2'b00; // Above s[3]
        end else if (s[1] && s[2] && !s[3]) begin
            current_level <= 2'b01; // Between s[3] and s[2]
        end else if (s[1] && !s[2]) begin
            current_level <= 2'b10; // Between s[2] and s[1]
        end else begin
            current_level <= 2'b11; // Below s[1]
        end

        // Nominal flow rate logic
        fr1 <= (current_level == 2'b01) || (current_level == 2'b10) || (current_level == 2'b11);
        fr2 <= (current_level == 2'b10) || (current_level == 2'b11);
        fr3 <= (current_level == 2'b11);

        // Supplemental flow rate logic
        if (current_level < previous_level) begin
            dfr <= 1'b1;
        end else begin
            dfr <= 1'b0;
        end

        // Update previous level
        previous_level <= current_level;
    end
end

endmodule