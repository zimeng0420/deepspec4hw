module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    // State encoding
    typedef enum reg [1:0] {
        ABOVE_S3 = 2'b00,
        BETWEEN_S3_S2 = 2'b01,
        BETWEEN_S2_S1 = 2'b10,
        BELOW_S1 = 2'b11
    } state_t;

    state_t current_state, next_state;
    reg previous_sensors; // Store previous sensor state for determining direction change

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= BELOW_S1;
            fr3 <= 1;
            fr2 <= 1;
            fr1 <= 1;
            dfr <= 1;
            previous_sensors <= 0;
        end else begin
            current_state <= next_state;
            previous_sensors <= s;
        end
    end

    always @(*) begin
        // Default flow rates settings
        fr3 = 0;
        fr2 = 0;
        fr1 = 0;
        dfr = 0;

        case (current_state)
            ABOVE_S3: begin
                fr3 = 0;
                fr2 = 0;
                fr1 = 0;
                dfr = 0;
                if (s == 3'b011) next_state = BETWEEN_S3_S2;
                else if (s == 3'b001) next_state = BETWEEN_S2_S1;
                else if (s == 3'b000) next_state = BELOW_S1;
                else next_state = ABOVE_S3;
            end

            BETWEEN_S3_S2: begin
                fr1 = 1;
                if (s == 3'b111) next_state = ABOVE_S3;
                else if (s == 3'b001) next_state = BETWEEN_S2_S1;
                else if (s == 3'b000) next_state = BELOW_S1;
                else next_state = BETWEEN_S3_S2;
            end

            BETWEEN_S2_S1: begin
                fr1 = 1;
                fr2 = 1;
                if(s > previous_sensors) dfr = 1; // Supplemental flow valve on upward movement
                if (s == 3'b111) next_state = ABOVE_S3;
                else if (s == 3'b011) next_state = BETWEEN_S3_S2;
                else if (s == 3'b000) next_state = BELOW_S1;
                else next_state = BETWEEN_S2_S1;
            end

            BELOW_S1: begin
                fr1 = 1;
                fr2 = 1;
                fr3 = 1;
                dfr = 1;
                if (s == 3'b111) next_state = ABOVE_S3;
                else if (s == 3'b011) next_state = BETWEEN_S3_S2;
                else if (s == 3'b001) next_state = BETWEEN_S2_S1;
                else next_state = BELOW_S1;
            end

            default: next_state = BELOW_S1; // Safe default state
        endcase
    end

endmodule