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
        A,  // State A
        F_SET, // f = 1 set state
        MONITOR_X, // Monitor x state
        CHECK_Y_1, // Check y state phase 1
        CHECK_Y_2, // Check y state phase 2
        G_SET // g = 1 set state
    } state_t;

    state_t current_state, next_state;

    // Sequential block for state transition
    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= A;
            f <= 0;
            g <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational block for next state and outputs
    always_ff @(current_state or x or y) begin
        // Default assignments
        next_state = current_state;
        f = 0; // Default f
        g = 0; // Default g

        case (current_state)
            A: begin
                next_state = F_SET; // Move to f = 1 set state
            end
            
            F_SET: begin
                f = 1; // Set f = 1 for one clock cycle
                next_state = MONITOR_X; // Move to monitor x state
            end
            
            MONITOR_X: begin
                if (x == 1) begin
                    // Check for x at the next clock cycles
                    next_state = CHECK_Y_1; // Proceed to check y
                end else begin
                    next_state = MONITOR_X; // Stay in monitor
                end
            end
            
            CHECK_Y_1: begin
                next_state = CHECK_Y_2; // Move to next check for y
            end
            
            CHECK_Y_2: begin
                if (y == 1) begin
                    g = 1; // Set g = 1 permanently
                    next_state = G_SET; // Move to g set state
                end else begin
                    next_state = A; // Reset to state A if y is not 1
                end
            end
            
            G_SET: begin
                g = 1; // Maintain g = 1 permanently
                if (y != 1) begin
                    next_state = A; // Reset to state A if y is not 1
                end
            end
        
            default: next_state = A; // Default to state A
        endcase
    end

endmodule