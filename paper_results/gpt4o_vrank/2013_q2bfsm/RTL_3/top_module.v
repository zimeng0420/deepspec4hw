module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output reg f,
	output reg g
);

    // State Encoding
    typedef enum reg [2:0] {
        A,       // Beginning state
        F_ONE,   // State after reset where f is set to 1 for one cycle
        X_101_W0, // State where the pattern 101 is being detected, waiting for '0'
        X_101_W1, // State where the pattern 101 is being detected, waiting for '1'
        MONITOR_Y_0, // State where g = 1 and monitoring y for 2 cycles, 0 clock cycles elapsed
        MONITOR_Y_1, // State where g = 1 and monitoring y for 2 cycles, 1 clock cycle elapsed
        G_PERMANENT // State where g = 1 permanently
    } state_t;
    
    state_t current_state, next_state;
    
    always @(posedge clk) begin
        if (!resetn)
            current_state <= A;
        else
            current_state <= next_state;
    end

    always @(*) begin
        f = 0;
        g = 0;
        next_state = current_state;
        
        case(current_state)
            A: begin
                if (resetn)
                    next_state = F_ONE;
            end
            
            F_ONE: begin
                f = 1;
                if (resetn)  // After one clock cycle, move to X monitoring state
                    next_state = X_101_W0;
            end
            
            X_101_W0: begin
                if (x)
                    next_state = X_101_W1;
            end
            
            X_101_W1: begin
                if (!x)
                    next_state = X_101_W0;
                else
                    next_state = MONITOR_Y_0;
            end
            
            MONITOR_Y_0: begin
                g = 1;
                if (y)
                    next_state = G_PERMANENT;
                else
                    next_state = MONITOR_Y_1;
            end
            
            MONITOR_Y_1: begin
                g = 1;
                if (y)
                    next_state = G_PERMANENT;
                else
                    next_state = A; // Return to A (reset required) on failure
            end
            
            G_PERMANENT: begin
                g = 1; // Maintain g = 1 permanently
            end
        endcase
    end

endmodule