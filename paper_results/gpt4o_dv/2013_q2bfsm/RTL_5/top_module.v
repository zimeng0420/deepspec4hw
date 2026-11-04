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
        state_A = 3'b000,  // Initial state
        state_B = 3'b001,  // After resetn is de-asserted
        state_C = 3'b010,  // x sequence detected: 1, 0
        state_D = 3'b011,  // x sequence detected: 1, 0, 1
        state_E = 3'b100,  // Monitor y
        state_F = 3'b101   // Permanent state for g = 1
    } state_t;

    state_t current_state, next_state;
    reg [1:0] y_monitor; // Counter for y monitoring in state E

    // State register
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= state_A;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;  // Default is to stay in the same state
        case (current_state)
            state_A: begin
                if (resetn) next_state = state_B;
            end
            state_B: begin
                next_state = state_C;
            end
            state_C: begin
                if (x) next_state = state_D;
            end
            state_D: begin
                if (!x) next_state = state_E;
            end
            state_E: begin
                if (x) next_state = state_F; // Sequence 1, 0, 1 detected; monitor y
                else next_state = state_C; // Loop back if sequence didn't match
            end
            state_F: begin
                // Remain in this state until reset
            end
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (!resetn) begin
            f <= 0;
            g <= 0;
            y_monitor <= 0;
        end else begin
            case (current_state)
                state_A: begin
                    f <= 0;
                    g <= 0;
                end
                state_B: begin
                    f <= 1; // Set f to 1 for one clock cycle after reset
                    g <= 0;
                end
                state_C: begin
                    f <= 0;
                    g <= 0;
                end
                state_D: begin
                    f <= 0;
                    g <= 0;
                end
                state_E: begin
                    f <= 0;
                    if (x) begin
                        g <= 1;
                        y_monitor <= 2; // Start monitoring y
                    end else if (y) begin
                        y_monitor <= 0;
                        g <= (y_monitor != 0);
                    end else if (y_monitor > 0) begin
                        y_monitor <= y_monitor - 1;
                    end else begin
                        g <= 0;
                    end
                end
                state_F: begin
                    f <= 0;
                    g <= 1; // Maintain g = 1 permanently
                end
            endcase
        end
    end

endmodule