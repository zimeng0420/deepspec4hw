module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    // Define states
    typedef enum reg [1:0] {
        STATE_LOW = 2'b00,
        STATE_BETWEEN_S1_S2 = 2'b01,
        STATE_BETWEEN_S2_S3 = 2'b10,
        STATE_HIGH = 2'b11
    } state_t;

    reg [1:0] current_state, next_state;
    reg previous_level_lower;
    
    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= STATE_LOW;
            previous_level_lower <= 1'b0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            STATE_LOW: begin
                if (s[3:1] == 3'b001)
                    next_state = STATE_BETWEEN_S1_S2;
                else
                    next_state = STATE_LOW;
            end
            STATE_BETWEEN_S1_S2: begin
                if (s[3:1] == 3'b011)
                    next_state = STATE_BETWEEN_S2_S3;
                else if (s[3:1] == 3'b000)
                    next_state = STATE_LOW;
            end
            STATE_BETWEEN_S2_S3: begin
                if (s[3:1] == 3'b111)
                    next_state = STATE_HIGH;
                else if (s[3:1] == 3'b001)
                    next_state = STATE_BETWEEN_S1_S2;
            end
            STATE_HIGH: begin
                if (s[3:1] == 3'b011)
                    next_state = STATE_BETWEEN_S2_S3;
                else if (s[3:1] == 3'b001)
                    next_state = STATE_BETWEEN_S1_S2;
            end
            default: next_state = STATE_LOW;
        endcase
    end
    
    // Output logic and previous level tracking
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fr3 <= 1'b1;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            case (current_state)
                STATE_LOW: begin
                    fr3 <= 1'b1;
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    dfr <= 1'b1;
                end
                STATE_BETWEEN_S1_S2: begin
                    fr3 <= 1'b0;
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    dfr <= previous_level_lower;
                    previous_level_lower <= (s[3:1] == 3'b000);
                end
                STATE_BETWEEN_S2_S3: begin
                    fr3 <= 1'b0;
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    dfr <= previous_level_lower;
                    previous_level_lower <= (s[3:1] == 3'b011);
                end
                STATE_HIGH: begin
                    fr3 <= 1'b0;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    dfr <= 1'b0;
                end
                default: begin
                    fr3 <= 1'b1;
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    dfr <= 1'b1;
                end
            endcase
        end
    end

endmodule