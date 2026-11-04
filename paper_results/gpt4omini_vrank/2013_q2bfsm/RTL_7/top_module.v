module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    typedef enum logic [2:0] {
        STATE_A,
        STATE_B,
        STATE_C,
        STATE_D
    } state_t;

    state_t current_state, next_state;
    logic [2:0] x_sequence; // To track x sequence

    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= STATE_A;
            f <= 0;
            g <= 0;
            x_sequence <= 3'b000;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (current_state == STATE_A) begin
            f <= 0;
            g <= 0;
            x_sequence <= 3'b000;
        end else if (current_state == STATE_B) begin
            f <= 1;
            x_sequence <= {x_sequence[1:0], x}; // Shift in the new x value
        end else if (current_state == STATE_C) begin
            g <= 1;
        end else if (current_state == STATE_D) begin
            // Maintain value of g based on y
            if (y) begin
                g <= 1; // Maintain g = 1 if y is 1
            end else if (x_sequence == 3'b101) begin
                g <= 1; // Transition to STATE_C
            end else begin
                g <= 0; // Set g = 0 if conditions are not met
            end
        end
    end

    always_comb begin
        case (current_state)
            STATE_A: begin
                next_state = resetn ? STATE_A : STATE_B; // Transition to state B
            end
            STATE_B: begin
                if (x_sequence == 3'b101) begin
                    next_state = STATE_C; // If x has 1,0,1
                end else begin
                    next_state = STATE_B; // Stay in state B
                end
            end
            STATE_C: begin
                next_state = STATE_D; // Transition to STATE_D
            end
            STATE_D: begin
                next_state = STATE_D; // Stay in STATE_D
            end
            default: next_state = STATE_A; // Default to STATE_A
        endcase
    end
endmodule