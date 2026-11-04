module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    typedef enum reg [1:0] {
        BELOW_LOWEST = 2'b00,   // Below s[1]
        BETWEEN_LOW_MID = 2'b01, // Between s[2] and s[1]
        BETWEEN_MID_HIGH = 2'b10, // Between s[3] and s[2]
        ABOVE_HIGHEST = 2'b11 // Above s[3]
    } state_t;

    state_t current_state, next_state;
    reg previous_level_higher; // Track if the previous level was higher than the current level

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= BELOW_LOWEST;
            previous_level_higher <= 0;
            fr1 <= 1;
            fr2 <= 1;
            fr3 <= 1;
            dfr <= 1;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            BELOW_LOWEST: begin
                fr1 = 1; fr2 = 1; fr3 = 1; dfr = 1;
                if (s[1])
                    next_state = BETWEEN_LOW_MID;
                else
                    next_state = BELOW_LOWEST;
            end
            BETWEEN_LOW_MID: begin
                fr1 = 1; fr2 = 1; fr3 = 0; dfr = previous_level_higher;
                if (s[2])
                    next_state = BETWEEN_MID_HIGH;
                else if (~s[1])
                    next_state = BELOW_LOWEST;
                else
                    next_state = BETWEEN_LOW_MID;
            end
            BETWEEN_MID_HIGH: begin
                fr1 = 1; fr2 = 0; fr3 = 0; dfr = previous_level_higher;
                if (s[3])
                    next_state = ABOVE_HIGHEST;
                else if (~s[2])
                    next_state = BETWEEN_LOW_MID;
                else
                    next_state = BETWEEN_MID_HIGH;
            end
            ABOVE_HIGHEST: begin
                fr1 = 0; fr2 = 0; fr3 = 0; dfr = 0;
                if (~s[3])
                    next_state = BETWEEN_MID_HIGH;
                else
                    next_state = ABOVE_HIGHEST;
            end
            default: begin
                fr1 = 1; fr2 = 1; fr3 = 1; dfr = 1;
                next_state = BELOW_LOWEST;
            end
        endcase
    end

    always @(posedge clk) begin
        if (current_state != next_state) begin
            if (next_state > current_state)
                previous_level_higher <= 1;
            else
                previous_level_higher <= 0;
        end
    end

endmodule