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
        STATE_A = 3'b000,       // Initial state
        STATE_B = 3'b001,       // After f = 1 for one cycle
        STATE_C = 3'b010,       // After detecting x sequence 1,0
        STATE_D = 3'b011,       // After detecting x = 1 (sequence complete)
        STATE_E = 3'b100,       // Monitor y for two cycles
        STATE_F = 3'b101        // g remains set
    } state_t;
    
    state_t current_state, next_state;
    reg [1:0] y_count;         // Counter to monitor y input
    reg x_prev, x_prev2;       // Registers to store previous x values

    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= STATE_A;
            f <= 0;
            g <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(posedge clk) begin
        if (!resetn) begin
            x_prev <= 0;
            x_prev2 <= 0;
        end else begin
            x_prev2 <= x_prev;
            x_prev <= x;
        end
    end

    always @(*) begin
        next_state = current_state;  // Default to hold state
        f = 0;        // Default output values
        g = 0;
        
        case (current_state)
            STATE_A: begin
                f = 1'b0; 
                if (!resetn) begin
                    next_state = STATE_A;
                end else begin
                    f = 1'b1;    // Set f = 1 for one cycle
                    next_state = STATE_B;
                end
            end
            STATE_B: begin
                f = 1'b0;    // f returns to 0
                if (x_prev2 == 1 && x_prev == 0 && x == 1) begin
                    next_state = STATE_D;    // Detected sequence 1,0,1
                end else if (x_prev == 1 && x == 0) begin
                    next_state = STATE_C;    // Detected 1,0
                end
            end
            STATE_C: begin
                if (x == 1) begin
                    next_state = STATE_D;    // Complete sequence 1,0,1
                end else begin
                    next_state = STATE_B;
                end
            end
            STATE_D: begin
                g = 1'b1;
                next_state = STATE_E;    // Monitor y
            end
            STATE_E: begin
                g = 1'b1;
                if (y == 1) begin
                    next_state = STATE_F;    // Keep g = 1 permanently
                end else if (y_count == 2) begin
                    g = 0;
                    next_state = STATE_A;    // Return to initial state
                end
            end
            STATE_F: begin
                g = 1'b1;    // Maintain g = 1
            end
        endcase
    end

    // Counter logic for y monitoring
    always @(posedge clk) begin
        if (current_state == STATE_D) begin
            y_count <= 0;    // Reset counter when entering STATE_E
        end else if (current_state == STATE_E) begin
            y_count <= y_count + 1;
        end
    end

endmodule