module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);
    
    typedef enum logic [1:0] {
        ABOVE_S3 = 2'b00,
        BETWEEN_S3_S2 = 2'b01,
        BETWEEN_S2_S1 = 2'b10,
        BELOW_S1 = 2'b11
    } state_t;

    state_t current_state, next_state;
    logic prev_level_lower;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= BELOW_S1; // Reset state equivalent to empty reservoir
            fr3 <= 1;
            fr2 <= 1;
            fr1 <= 1;
            dfr <= 1;
            prev_level_lower <= 1; // Assuming empty state
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (current_state != next_state) begin
            prev_level_lower <= (current_state < next_state);
        end
    end

    always_comb begin
        case (current_state)
            ABOVE_S3: begin
                fr3 = 0;
                fr2 = 0;
                fr1 = 0;
                dfr = 0;
                next_state = (s[3]) ? ABOVE_S3 : (s[2]) ? BETWEEN_S3_S2 : (s[1]) ? BETWEEN_S2_S1 : BELOW_S1;
            end
            
            BETWEEN_S3_S2: begin
                fr3 = 0;
                fr2 = 0;
                fr1 = (prev_level_lower) ? 1 : 0;
                dfr = (prev_level_lower) ? 1 : 0;
                next_state = (s[3]) ? ABOVE_S3 : (s[2]) ? BETWEEN_S3_S2 : (s[1]) ? BETWEEN_S2_S1 : BELOW_S1;
            end
            
            BETWEEN_S2_S1: begin
                fr3 = 0;
                fr2 = 1;
                fr1 = (prev_level_lower) ? 1 : 0;
                dfr = (prev_level_lower) ? 1 : 0;
                next_state = (s[3]) ? ABOVE_S3 : (s[2]) ? BETWEEN_S3_S2 : (s[1]) ? BETWEEN_S2_S1 : BELOW_S1;
            end
            
            BELOW_S1: begin
                fr3 = 1;
                fr2 = 1;
                fr1 = 1;
                dfr = 1;
                next_state = (s[3]) ? ABOVE_S3 : (s[2]) ? BETWEEN_S3_S2 : (s[1]) ? BETWEEN_S2_S1 : BELOW_S1;
            end

            default: begin
                fr3 = 1;
                fr2 = 1;
                fr1 = 1;
                dfr = 1;
                next_state = BELOW_S1;
            end
        endcase
    end
    
endmodule