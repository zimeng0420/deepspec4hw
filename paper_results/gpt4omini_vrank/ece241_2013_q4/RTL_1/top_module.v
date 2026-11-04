module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    reg [1:0] current_state, next_state;

    // State encoding
    parameter LOW_LEVEL = 2'b00, BETWEEN_S2_S1 = 2'b01, BETWEEN_S3_S2 = 2'b10, HIGH_LEVEL = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= LOW_LEVEL;    // Reset to LOW_LEVEL state
            fr1 <= 1;
            fr2 <= 1;
            fr3 <= 1;
            dfr <= 1;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        // Default outputs
        fr1 = 0;
        fr2 = 0;
        fr3 = 0;
        dfr = 0;
        case (current_state)
            LOW_LEVEL: begin
                if (s[1] == 1'b0) begin
                    fr1 = 1;
                    fr2 = 1;
                    fr3 = 1;   // Maximum flow
                end
                next_state = LOW_LEVEL;
            end
            BETWEEN_S3_S2: begin
                if (s[2] && s[1]) begin
                    fr1 = 1;
                    next_state = BETWEEN_S3_S2;
                end else begin
                    next_state = HIGH_LEVEL;
                end
            end
            BETWEEN_S2_S1: begin
                if (s[1]) begin
                    fr1 = 1;
                    fr2 = 1;
                    next_state = BETWEEN_S2_S1;
                end else begin
                    next_state = LOW_LEVEL;
                end
                dfr = 1; // Supplemental flow valve open if water level is rising
            end
            HIGH_LEVEL: begin
                if (s[3]) begin
                    next_state = HIGH_LEVEL;
                end else if (s[2]) begin
                    next_state = BETWEEN_S3_S2;
                end else if (s[1]) begin
                    next_state = BETWEEN_S2_S1;
                end else begin
                    next_state = LOW_LEVEL;
                end
            end
        endcase
    end

endmodule