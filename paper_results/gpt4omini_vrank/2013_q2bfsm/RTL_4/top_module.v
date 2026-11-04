module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    typedef enum reg [2:0] {STATE_A, STATE_F_ONE, STATE_X_MONITOR, STATE_G_ONE, STATE_Y_MONITOR} state_t;
    state_t current_state, next_state;
    
    reg [2:0] x_seq_count;
    reg [1:0] y_count;

    // State transition logic
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= STATE_A;
            f <= 0;
            g <= 0;
            x_seq_count <= 0;
            y_count <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and output logic
    always @* begin
        // Default assignments
        next_state = current_state;
        f = 0;

        case (current_state)
            STATE_A: begin
                if (!resetn) begin
                    next_state = STATE_F_ONE;
                    f = 1; // Output f = 1 for one clock cycle
                end
            end

            STATE_F_ONE: begin
                next_state = STATE_X_MONITOR;
            end
            
            STATE_X_MONITOR: begin
                if (x_seq_count < 3) begin
                    if (x == 1) begin
                        if (x_seq_count == 0 || x_seq_count == 2) begin
                            x_seq_count = x_seq_count + 1;
                        end
                    end else if (x == 0 && x_seq_count == 1) begin
                        x_seq_count = x_seq_count + 1;
                    end
                end
                if (x_seq_count == 3) begin
                    next_state = STATE_G_ONE;
                    g = 1; // Set g = 1 on the next clock cycle
                end
            end
            
            STATE_G_ONE: begin
                if (y_count < 3) begin
                    if (y == 1) begin
                        g = 1; // Maintain g = 1 permanently
                        next_state = STATE_G_ONE; // Stay in g state
                        y_count = 0; // Reset y_count since y = 1
                    end else if (y == 0) begin
                        y_count = y_count + 1; // Count cycles until y = 1
                    end
                    if (y_count == 2) begin
                        g = 0; // Set g = 0 permanently if y does not become 1
                        next_state = STATE_G_ONE; // Stay in g state
                    end
                end
            end
        
            default: begin
                next_state = STATE_A;
            end
        endcase
    end
endmodule