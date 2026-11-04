module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    typedef enum logic [1:0] {
        STATE_A, // Initial state waiting for reset
        STATE_B, // State after reset, f = 1 for one cycle
        STATE_C, // Monitoring sequence of x
        STATE_D  // Monitoring y to decide on g
    } state_t;

    state_t state, next_state;
    logic [2:0] x_seq; // To track the x values
    logic [1:0] y_count; // To count the clock ticks for y

    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= STATE_A;
            f <= 0;
            g <= 0;
            x_seq <= 0;
            y_count <= 0;
        end else begin
            state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        case (state)
            STATE_A: begin
                f <= 0; // State A, outputs are low
                g <= 0;
            end
            STATE_B: begin
                f <= 1; // Set f = 1 for one cycle
            end
            STATE_C: begin
                // Shift in x values for pattern recognition
                x_seq <= {x_seq[1:0], x};
                if (x_seq == 3'b101) begin
                    g <= 1; // Set g = 1 if sequence is 101
                    y_count <= 0; // Initialize y count for g logic
                end
            end
            STATE_D: begin
                if (y_count < 2) begin
                    y_count <= y_count + 1; // Increment y count
                    if (y == 1) begin
                        // Maintain g = 1 if y is 1 within 2 cycles
                        g <= 1;
                    end
                end else begin
                    g <= 0; // Set g = 0 if y is not 1 in 2 cycles
                end
            end
        endcase
    end

    always_comb begin
        case (state)
            STATE_A: next_state = resetn ? STATE_B : STATE_A;
            STATE_B: next_state = STATE_C;
            STATE_C: next_state = (x_seq == 3'b101) ? STATE_D : STATE_C;
            STATE_D: next_state = STATE_D; // Stay in STATE_D until reset
            default: next_state = STATE_A; // Default case for safety
        endcase
    end

endmodule