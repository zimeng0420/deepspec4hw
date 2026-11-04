module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    // State definitions
    typedef enum logic [1:0] {
        LOW = 2'b00,       // Below s[1]
        BETWEEN_S1_S2 = 2'b01, // Between s[2] and s[1]
        BETWEEN_S2_S3 = 2'b10, // Between s[3] and s[2]
        ABOVE_S3 = 2'b11    // Above s[3]
    } state_t;

    state_t current_state, next_state;
    state_t previous_state; // To track the previous water level

    // State and output update on clock edge
    always @(posedge clk) begin
        if (reset) begin
            current_state <= LOW;
            previous_state <= LOW;
            fr3 <= 1'b1;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            current_state <= next_state;
            if (current_state != next_state) begin
                previous_state <= current_state;
            end
        end
    end

    // Next state logic and output logic
    always @(*) begin
        // Default outputs
        fr3 = 0;
        fr2 = 0;
        fr1 = 0;
        dfr = 0;

        case (current_state)
            LOW: begin
                fr3 = 1'b1;
                fr2 = 1'b1;
                fr1 = 1'b1;
                next_state = (s[1]) ? BETWEEN_S1_S2 : LOW;
            end
            
            BETWEEN_S1_S2: begin
                fr2 = 1'b1;
                fr1 = 1'b1;
                if (!s[1]) next_state = LOW;
                else if (s[2]) next_state = BETWEEN_S2_S3;
                else next_state = BETWEEN_S1_S2;

                if (previous_state == LOW) begin
                    dfr = 1'b1; // Open supplemental valve
                end
            end

            BETWEEN_S2_S3: begin
                fr1 = 1'b1;
                if (!s[2]) next_state = BETWEEN_S1_S2;
                else if (s[3]) next_state = ABOVE_S3;
                else next_state = BETWEEN_S2_S3;

                if (previous_state == BETWEEN_S1_S2) begin
                    dfr = 1'b1; // Open supplemental valve
                end
            end

            ABOVE_S3: begin
                // No flow rate required
                if (!s[3]) next_state = BETWEEN_S2_S3;
                else next_state = ABOVE_S3;
            end

            default: next_state = LOW;
        endcase
    end

endmodule