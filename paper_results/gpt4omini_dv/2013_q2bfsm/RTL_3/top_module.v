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
        STATE_A = 3'b000,
        STATE_WAIT = 3'b001,
        STATE_1 = 3'b010,
        STATE_0 = 3'b011,
        STATE_1_DONE = 3'b100
    } state_t;

    state_t current_state, next_state;
    reg [1:0] y_counter; // Counter for y input
    reg sequence_detected;

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= STATE_A;
            f <= 0;
            g <= 0;
            sequence_detected <= 0;
            y_counter <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == STATE_WAIT) begin
                f <= 1; // Set output f to 1 for one clock cycle
            end else begin
                f <= 0; // Clear f in other states
            end
        end
    end

    always @(*) begin
        next_state = current_state;
        sequence_detected = 0;
        
        case(current_state)
            STATE_A: begin
                next_state = STATE_WAIT; // Move to wait state on reset release
            end
            STATE_WAIT: begin
                next_state = STATE_1; // Transition to detect 1
            end
            STATE_1: begin
                if (x) begin
                    next_state = STATE_0; // Transition to detect 0
                end
            end
            STATE_0: begin
                if (!x) begin
                    next_state = STATE_1_DONE; // Transition to final state if 0 detected
                end
            end
            STATE_1_DONE: begin
                sequence_detected = 1; // Sequence detected
                g <= 1; // Set g to 1 after sequence
                if (y) begin
                    g <= 1; // If y is 1, maintain g
                end else if (y_counter < 2) begin
                    y_counter = y_counter + 1; // Increment y counter
                end else begin
                    g <= 0; // Reset g if y is not 1 within 2 cycles
                end
            end
        endcase
    end

endmodule