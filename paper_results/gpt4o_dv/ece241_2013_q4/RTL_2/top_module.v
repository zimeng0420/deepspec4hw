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
    typedef enum logic [1:0] {
        BELOW_S1       = 2'b00,
        BETWEEN_S2_S1  = 2'b01,
        BETWEEN_S3_S2  = 2'b10,
        ABOVE_S3       = 2'b11
    } state_t;
    
    reg [1:0] state, next_state;
    reg [1:0] prev_state;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset state to BELOW_S1 and all outputs to 1
            state <= BELOW_S1;
            prev_state <= BELOW_S1;
            fr3 <= 1;
            fr2 <= 1;
            fr1 <= 1;
            dfr <= 1;
        end else begin
            // Update state
            prev_state <= state;
            state <= next_state;

            // Determine flow rate outputs based on state
            case (next_state)
                ABOVE_S3: begin
                    fr3 <= 0;
                    fr2 <= 0;
                    fr1 <= 0;
                    dfr <= 0;
                end
                
                BETWEEN_S3_S2: begin
                    fr3 <= 0;
                    fr2 <= 0;
                    fr1 <= 1;
                    dfr <= (prev_state == BELOW_S1 || prev_state == BETWEEN_S2_S1);
                end
                
                BETWEEN_S2_S1: begin
                    fr3 <= 0;
                    fr2 <= 1;
                    fr1 <= 1;
                    dfr <= (prev_state == BELOW_S1);
                end
                
                BELOW_S1: begin
                    fr3 <= 1;
                    fr2 <= 1;
                    fr1 <= 1;
                    dfr <= 1; // Since it's below s1, dfr is always 1
                end
            endcase
        end
    end

    always_comb begin
        case (s)
            3'b111: next_state = ABOVE_S3;        // Above s[3]
            3'b011: next_state = BETWEEN_S3_S2;   // Between s[3] and s[2]
            3'b001: next_state = BETWEEN_S2_S1;   // Between s[2] and s[1]
            default: next_state = BELOW_S1;       // Below s[1]
        endcase
    end

endmodule