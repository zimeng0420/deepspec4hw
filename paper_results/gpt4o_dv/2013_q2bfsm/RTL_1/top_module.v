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
        STATE_A = 3'd0,
        STATE_B = 3'd1,
        STATE_C = 3'd2,
        STATE_D = 3'd3,
        STATE_E = 3'd4
    } state_t;

    state_t current_state, next_state;
    reg [1:0] y_counter; // To count the y input monitoring cycles
    reg f_triggered; // To ensure f is only set for one clock cycle

    // State transition and output logic
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= STATE_A;
            f <= 0;
            g <= 0;
            f_triggered <= 0;
            y_counter <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == STATE_A && !f_triggered) begin
                f <= 1;
                f_triggered <= 1;
            end else begin
                f <= 0;
            end

            if (current_state == STATE_D) begin
                if (y) begin
                    g <= 1; // Maintain g = 1 permanently
                end else if (y_counter == 2) begin
                    g <= 0; // Set g = 0 permanently
                end
                y_counter <= y_counter + 1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            STATE_A: begin
                next_state = STATE_B;
            end
            STATE_B: begin
                if (x == 1) next_state = STATE_C;
                else next_state = STATE_B;
            end
            STATE_C: begin
                if (x == 0) next_state = STATE_D;
                else next_state = STATE_B;
            end
            STATE_D: begin
                if (x == 1) begin
                    next_state = STATE_E;
                    g = 1;
                    y_counter = 0; // Reset the two-cycle counter for y
                end else begin
                    next_state = STATE_B;
                end
            end
            STATE_E: begin
                next_state = STATE_E; // Stay in STATE_E until reset
            end
            default: next_state = STATE_A;
        endcase
    end

endmodule