module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    // State encoding
    typedef enum reg [1:0] {
        STATE_A = 2'b00,
        STATE_B = 2'b01,
        STATE_C = 2'b10,
        STATE_D = 2'b11
    } state_t;

    state_t current_state, next_state;

    // State flip-flops
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            current_state <= STATE_A; // Initialize to state A
        else
            current_state <= next_state;
    end

    // State table
    always @(*) begin
        case (current_state)
            STATE_A: begin
                if (r[1])
                    next_state = STATE_B;
                else if (r[2])
                    next_state = STATE_C;
                else if (r[3])
                    next_state = STATE_D;
                else
                    next_state = STATE_A;
            end
            STATE_B: begin
                if (!r[1])
                    next_state = STATE_A;
                else
                    next_state = STATE_B;
            end
            STATE_C: begin
                if (!r[2])
                    next_state = STATE_A;
                else
                    next_state = STATE_C;
            end
            STATE_D: begin
                next_state = STATE_A; // Since r[3] must be 0 to arrive in STATE_D and has the lowest priority
            end
            default: next_state = STATE_A;
        endcase
    end

    // FSM Outputs
    always @(*) begin
        g = 3'b000; // Default values for g
        case (current_state)
            STATE_B: g[1] = 1'b1; // Grant device 1
            STATE_C: g[2] = 1'b1; // Grant device 2
            // STATE_D would not set any grant as device 3 gets access without explicit grant output
            default: g = 3'b000; // No grants
        endcase
    end

endmodule