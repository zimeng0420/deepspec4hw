module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

reg [1:0] previous_level; // 0: below s[1], 1: between s[2] and s[1], 2: between s[3] and s[2], 3: above s[3]
reg [1:0] current_level;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        fr3 <= 1;
        fr2 <= 1;
        fr1 <= 1;
        dfr <= 0;
        previous_level <= 0; // Assume low water level
    end else begin
        // Determine current level based on sensor inputs
        if (s[3]) begin
            current_level <= 3; // Above s[3]
        end else if (s[2]) begin
            current_level <= 2; // Between s[3] and s[2]
        end else if (s[1]) begin
            current_level <= 1; // Between s[2] and s[1]
        end else begin
            current_level <= 0; // Below s[1]
        end

        // Flow rate control logic
        case (current_level)
            3: begin
                fr3 <= 0;
                fr2 <= 0;
                fr1 <= 0;
            end
            2: begin
                fr3 <= 0;
                fr2 <= 0;
                fr1 <= 1;
            end
            1: begin
                fr3 <= 0;
                fr2 <= 1;
                fr1 <= 1;
            end
            0: begin
                fr3 <= 1;
                fr2 <= 1;
                fr1 <= 1;
            end
        endcase
        
        // Determine dfr based on previous and current level
        dfr <= (previous_level < current_level) ? 1 : 0;

        // Update previous level to current level
        previous_level <= current_level;
    end
end

endmodule