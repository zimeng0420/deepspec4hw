module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum reg [3:0] {
        STATE_A,
        STATE_F,
        STATE_X1,
        STATE_X0,
        STATE_X1_FINAL,
        STATE_G1,
        STATE_WAIT_Y1,
        STATE_CHECK_Y2,
        STATE_G0
    } state_t;
    
    state_t current_state, next_state;
    reg [1:0] y_counter; // Counter to track clock cycles when checking y input

    // State transition logic
    always @ (posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= STATE_A;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and output logic
    always @ (*) begin
        // Default outputs
        f = 0;
        g = 0;
        next_state = current_state; // Remain in current state by default
        case (current_state)
            STATE_A: begin
                if (!resetn)
                    next_state = STATE_F; // Move to next state when resetn is de-asserted
            end
            STATE_F: begin
                f = 1; // Set f to 1 for one clock cycle
                next_state = STATE_X1;
            end
            STATE_X1: begin
                if (x == 1)
                    next_state = STATE_X0;
            end
            STATE_X0: begin
                if (x == 0)
                    next_state = STATE_X1_FINAL;
            end
            STATE_X1_FINAL: begin
                if (x == 1)
                    next_state = STATE_G1;
            end
            STATE_G1: begin
                g = 1;
                next_state = STATE_WAIT_Y1;
            end
            STATE_WAIT_Y1: begin
                g = 1;
                if (y == 1)
                    next_state = STATE_G1; // Maintain g = 1 permanently
                else
                    next_state = STATE_CHECK_Y2; // Check y one more cycle
            end
            STATE_CHECK_Y2: begin
                g = 1;
                if (y == 1)
                    next_state = STATE_G1; // Maintain g = 1 permanently
                else
                    next_state = STATE_G0; // Set g = 0 permanently
            end
            STATE_G0: begin
                g = 0; // Keep g = 0 permanently
            end
        endcase
    end
endmodule