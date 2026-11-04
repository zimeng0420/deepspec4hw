module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE      = 3'b000,
        ONE       = 3'b001,
        TWO_ONES  = 3'b010,
        THREE_ONES= 3'b011,
        FOUR_ONES = 3'b100,
        FIVE_ONES = 3'b101,
        SIX_ONES  = 3'b110,
        SEVEN_ONES= 3'b111
    } state_t;
    
    state_t current_state, next_state;
    
    // State transition logic
    always @ (posedge clk) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end
    
    // Next state and output logic
    always @ (*) begin
        // Default outputs
        disc = 0;
        flag = 0;
        err  = 0;
        
        case (current_state)
            IDLE: begin
                if (in)
                    next_state = ONE;
                else
                    next_state = IDLE;
            end
            
            ONE: begin
                if (in)
                    next_state = TWO_ONES;
                else
                    next_state = IDLE;
            end
            
            TWO_ONES: begin
                if (in)
                    next_state = THREE_ONES;
                else
                    next_state = IDLE;
            end
            
            THREE_ONES: begin
                if (in)
                    next_state = FOUR_ONES;
                else
                    next_state = IDLE;
            end
            
            FOUR_ONES: begin
                if (in)
                    next_state = FIVE_ONES;
                else
                    next_state = IDLE;
            end
            
            FIVE_ONES: begin
                if (in)
                    next_state = SIX_ONES;
                else
                    next_state = IDLE;
            end
            
            SIX_ONES: begin
                if (in) begin
                    next_state = SEVEN_ONES;
                    err = 1;
                end else begin
                    next_state = IDLE;
                    // 0111110: Discard the bit
                    disc = 1;
                end
            end
            
            SEVEN_ONES: begin
                if (in)
                    next_state = SEVEN_ONES;
                else
                    next_state = IDLE;
                err = 1;
            end
            
            default: next_state = IDLE; // Default case for safety
        endcase
        
        // Separate handling for the flag (01111110)
        if (current_state == SIX_ONES && !in) begin
            flag = 1;
        end
    end

endmodule