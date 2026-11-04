module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum logic [2:0] {
        A = 3'b000,    // Initial state
        B = 3'b001,    // State to output f = 1 for 1 clock
        C = 3'b010,    // State to detect x = 1, 0, 1 pattern
        D = 3'b011,    // State to monitor y for 2 cycles with g = 1
        E = 3'b100     // Final state, g = 0 permanently
    } state_t;

    state_t state, next_state;

    // Registers for x pattern detection
    reg x_prev1, x_prev2;

    // Counter for y monitoring
    reg [1:0] y_check_counter;

    // Sequential logic (state register and data registers)
    always @(posedge clk) begin
        if (!resetn) begin
            // Synchronous reset (active low)
            state <= A;
            x_prev1 <= 0;
            x_prev2 <= 0;
            y_check_counter <= 0;
            g <= 0;
            f <= 0;
        end else begin
            // Update state and registers on clock edge
            state <= next_state;
            x_prev2 <= x_prev1;
            x_prev1 <= x;

            // Reset counters if not in state D
            if (state != D)
                y_check_counter <= 0;
        end
    end

    // Combinational logic (next state logic and output logic)
    always @(*) begin
        // Default assignments
        next_state = state;
        f = 0;

        case (state)
            A: begin
                // Initial state
                g = 0; // g is 0 in state A
                if (resetn) begin
                    next_state = B; // Transition to state B after reset is de-asserted
                end
            end

            B: begin
                // Output f = 1 for one clock cycle
                f = 1;
                next_state = C; // Go to pattern detection state
            end

            C: begin
                // Detect x pattern 1, 0, 1
                if (x_prev2 == 1 && x_prev1 == 0 && x == 1) begin
                    g = 1; // Set g = 1 when pattern is detected
                    next_state = D; // Transition to monitor y
                end
            end

            D: begin
                // Monitor y for at most 2 cycles
                g = 1; // Maintain g = 1
                if (y == 1) begin
                    // If y becomes 1 within 2 cycles, hold g = 1 permanently
                    next_state = D; // Stay in state D
                end else if (y_check_counter == 1) begin
                    // If y is not 1 within 2 cycles, set g = 0
                    g = 0;
                    next_state = E; // Transition to final state
                end
            end

            E: begin
                // Final state, g remains 0
                g = 0;
                // Remain in this state until reset
            end
        endcase
    end

    // Counter for state D, monitoring y
    always @(posedge clk) begin
        if (state == D) begin
            if (y_check_counter != 2'd2)
                y_check_counter <= y_check_counter + 1;
        end
    end

endmodule