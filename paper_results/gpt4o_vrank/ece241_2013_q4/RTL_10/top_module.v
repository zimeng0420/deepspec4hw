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
        STATE_ABOVE_S3 = 2'd0,
        STATE_BETWEEN_S3_S2 = 2'd1,
        STATE_BETWEEN_S2_S1 = 2'd2,
        STATE_BELOW_S1 = 2'd3
    } state_t;

    state_t current_state, next_state;
    reg [3:1] prev_sensors;

    // Sequential logic for state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= STATE_BELOW_S1;
            prev_sensors <= 3'b000;
        end else begin
            current_state <= next_state;
            prev_sensors <= s;
        end
    end

    // Combinational logic for determining the next state
    always @(*) begin
        case (current_state)
            STATE_ABOVE_S3: begin
                if (s != 3'b111) begin
                    if (s == 3'b011)
                        next_state = STATE_BETWEEN_S3_S2;
                    else if (s == 3'b001)
                        next_state = STATE_BETWEEN_S2_S1;
                    else
                        next_state = STATE_BELOW_S1;
                end else begin
                    next_state = STATE_ABOVE_S3;
                end
            end

            STATE_BETWEEN_S3_S2: begin
                if (s == 3'b111)
                    next_state = STATE_ABOVE_S3;
                else if (s == 3'b001)
                    next_state = STATE_BETWEEN_S2_S1;
                else if (s == 3'b000)
                    next_state = STATE_BELOW_S1;
                else
                    next_state = STATE_BETWEEN_S3_S2;
            end

            STATE_BETWEEN_S2_S1: begin
                if (s == 3'b111)
                    next_state = STATE_ABOVE_S3;
                else if (s == 3'b011)
                    next_state = STATE_BETWEEN_S3_S2;
                else if (s == 3'b000)
                    next_state = STATE_BELOW_S1;
                else
                    next_state = STATE_BETWEEN_S2_S1;
            end

            STATE_BELOW_S1: begin
                if (s == 3'b111)
                    next_state = STATE_ABOVE_S3;
                else if (s == 3'b011)
                    next_state = STATE_BETWEEN_S3_S2;
                else if (s == 3'b001)
                    next_state = STATE_BETWEEN_S2_S1;
                else
                    next_state = STATE_BELOW_S1;
            end

            default: next_state = STATE_BELOW_S1;
        endcase
    end

    // Output logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fr3 <= 1;
            fr2 <= 1;
            fr1 <= 1;
            dfr <= 1;
        end else begin
            case (current_state)
                STATE_ABOVE_S3: begin
                    fr3 <= 0;
                    fr2 <= 0;
                    fr1 <= 0;
                    dfr <= 0;
                end

                STATE_BETWEEN_S3_S2: begin
                    fr3 <= 0;
                    fr2 <= 0;
                    fr1 <= 1;
                    dfr <= (prev_sensors < s) ? 1 : 0;
                end

                STATE_BETWEEN_S2_S1: begin
                    fr3 <= 0;
                    fr2 <= 1;
                    fr1 <= 1;
                    dfr <= (prev_sensors < s) ? 1 : 0;
                end

                STATE_BELOW_S1: begin
                    fr3 <= 1;
                    fr2 <= 1;
                    fr1 <= 1;
                    dfr <= 1;
                end
            endcase
        end
    end

endmodule