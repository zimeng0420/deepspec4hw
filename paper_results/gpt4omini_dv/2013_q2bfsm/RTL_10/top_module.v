module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum reg [2:0] {
        STATE_A,  // Reset state
        STATE_B,  // After reset state
        STATE_C,  // x = 1 detected
        STATE_D,  // x = 0 detected
        STATE_E   // Final x = 1 detected
    } state_t;

    state_t current_state, next_state;
    reg [1:0] y_timer; // Timer for y checking
    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= STATE_A;
            f <= 0;
            g <= 0;
            y_timer <= 0;
        end else begin
            current_state <= next_state;
            f <= (current_state == STATE_B) ? 1 : 0;
            if (next_state == STATE_E) begin
                if (y_timer < 2) begin
                    y_timer <= y_timer + 1;
                end else begin
                    g <= 0;  // Reset g if timer exceeds
                end
            end
        end
    end

    always @(*) begin
        case (current_state)
            STATE_A: begin
                next_state = STATE_B; // Go to STATE_B after reset
                g = 0;
                y_timer = 0;
            end
            
            STATE_B: begin
                next_state = (x) ? STATE_C : STATE_B;
            end
            
            STATE_C: begin
                next_state = (x) ? STATE_C : STATE_D; // Stay in STATE_C if x is 1, else go to STATE_D
            end
            
            STATE_D: begin
                next_state = (x) ? STATE_E : STATE_A; // Detect 1, go to STATE_E or reset
                g = 0; // Reset g until proven
            end
            
            STATE_E: begin
                g = 1; // Set g if in STATE_E
                if (y) begin
                    next_state = STATE_E; // Stay in STATE_E if y is 1
                end else if (y_timer < 2) begin
                    next_state = STATE_E; // Timer not exceeded
                end else begin
                    next_state = STATE_A; // Reset state if timeout
                end
            end
            
            default: begin
                next_state = STATE_A; // Fallback state
            end
        endcase
    end

endmodule