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
        BELOW_S1 = 2'b00,
        BETWEEN_S1_S2 = 2'b01,
        BETWEEN_S2_S3 = 2'b10,
        ABOVE_S3 = 2'b11
    } state_t;
    
    reg [1:0] current_state, next_state;
    reg previous_level_direction;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= BELOW_S1;
            fr3 <= 1;
            fr2 <= 1;
            fr1 <= 1;
            dfr <= 1;
            previous_level_direction <= 0;
        end
        else begin
            current_state <= next_state;

            case (next_state)
                BELOW_S1: begin
                    fr3 <= 1;
                    fr2 <= 1;
                    fr1 <= 1;
                    dfr <= 0;
                end
                BETWEEN_S1_S2: begin
                    fr3 <= 0;
                    fr2 <= 1;
                    fr1 <= 1;
                    dfr <= previous_level_direction;
                end
                BETWEEN_S2_S3: begin
                    fr3 <= 0;
                    fr2 <= 0;
                    fr1 <= 1;
                    dfr <= previous_level_direction;
                end
                ABOVE_S3: begin
                    fr3 <= 0;
                    fr2 <= 0;
                    fr1 <= 0;
                    dfr <= 0;
                end
            endcase
        end
    end

    always @(*) begin
        case (current_state)
            BELOW_S1: begin
                if (s[3]) begin
                    next_state = ABOVE_S3;
                    previous_level_direction = 0;
                end else if (s[2]) begin
                    next_state = BETWEEN_S2_S3;
                    previous_level_direction = 1;
                end else if (s[1]) begin
                    next_state = BETWEEN_S1_S2;
                    previous_level_direction = 1;
                end else begin
                    next_state = BELOW_S1;
                end
            end
            BETWEEN_S1_S2: begin
                if (s[3]) begin
                    next_state = ABOVE_S3;
                    previous_level_direction = 0;
                end else if (s[2]) begin
                    next_state = BETWEEN_S2_S3;
                    previous_level_direction = 0;
                end else begin
                    next_state = BELOW_S1;
                    previous_level_direction = 0;
                end
            end
            BETWEEN_S2_S3: begin
                if (s[3]) begin
                    next_state = ABOVE_S3;
                    previous_level_direction = 0;
                end else if (s[2]) begin
                    next_state = BETWEEN_S2_S3;
                end else if (s[1]) begin
                    next_state = BETWEEN_S1_S2;
                    previous_level_direction = 0;
                end else begin
                    next_state = BELOW_S1;
                    previous_level_direction = 0;
                end
            end
            ABOVE_S3: begin
                if (!s[3]) begin
                    next_state = BETWEEN_S2_S3;
                    previous_level_direction = 0;
                end else begin
                    next_state = ABOVE_S3;
                end
            end
        endcase
    end

endmodule