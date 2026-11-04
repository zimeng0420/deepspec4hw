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

// Define state encoding for water levels
localparam LEVEL_BELOW_S1 = 2'b00; // None
localparam LEVEL_BETWEEN_S2_S1 = 2'b01; // s[1]
localparam LEVEL_BETWEEN_S3_S2 = 2'b10; // s[1], s[2]
localparam LEVEL_ABOVE_S3 = 2'b11; // s[1], s[2], s[3]

always @(posedge clk) begin
    if (reset) begin
        current_level <= LEVEL_BELOW_S1;
        previous_level <= LEVEL_BELOW_S1;
        fr3 <= 1;
        fr2 <= 1;
        fr1 <= 1;
        dfr <= 0;
    end else begin
        // Determine current water level
        if (s == 3'b111) begin
            current_level <= LEVEL_ABOVE_S3;
        end else if (s == 3'b110) begin
            current_level <= LEVEL_BETWEEN_S3_S2;
        end else if (s == 3'b100) begin
            current_level <= LEVEL_BETWEEN_S2_S1;
        end else begin
            current_level <= LEVEL_BELOW_S1;
        end

        // Determine nominal flow rates
        case (current_level)
            LEVEL_ABOVE_S3: begin
                fr1 <= 0;
                fr2 <= 0;
                fr3 <= 0;
            end
            LEVEL_BETWEEN_S3_S2: begin
                fr1 <= 1;
                fr2 <= 0;
                fr3 <= 0;
            end
            LEVEL_BETWEEN_S2_S1: begin
                fr1 <= 1;
                fr2 <= 1;
                fr3 <= 0;
            end
            LEVEL_BELOW_S1: begin
                fr1 <= 1;
                fr2 <= 1;
                fr3 <= 1;
            end
            default: begin
                fr1 <= 0;
                fr2 <= 0;
                fr3 <= 0;
            end
        endcase

        // Determine supplemental flow rate (dfr)
        if (current_level > previous_level) begin
            dfr <= 1;
        } else begin
            dfr <= 0;
        end

        previous_level <= current_level; // Update previous level after outputs are assigned
    end
end

endmodule