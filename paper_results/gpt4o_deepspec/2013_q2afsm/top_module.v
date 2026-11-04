module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    // State encoding
    typedef enum reg [1:0] {STATE_A = 2'b00, STATE_B = 2'b01, STATE_C = 2'b10, STATE_D = 2'b11} state_t;
    state_t state, next_state;

    // Next-state logic
    always @(*) begin
        case (state)
            STATE_A: begin
                if (r[1]) 
                    next_state = STATE_B;  // Device 1 request
                else if (r[2]) 
                    next_state = STATE_C;  // Device 2 request
                else if (r[3]) 
                    next_state = STATE_D;  // Device 3 request
                else 
                    next_state = STATE_A;  // Remain in state A
            end
            STATE_B: begin
                if (r[1]) 
                    next_state = STATE_B;  // Remain in state B if device 1 still requesting
                else 
                    next_state = STATE_A;  // Transition back to A if no request from device 1
            end
            STATE_C: begin
                if (r[2]) 
                    next_state = STATE_C;  // Remain in state C if device 2 still requesting
                else 
                    next_state = STATE_A;  // Transition back to A if no request from device 2
            end
            STATE_D: begin
                if (r[3]) 
                    next_state = STATE_D;  // Remain in state D if device 3 still requesting
                else 
                    next_state = STATE_A;  // Transition back to A if no request from device 3
            end
            default: next_state = STATE_A; // Default state
        endcase
    end

    // State flip-flops
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= STATE_A; // Synchronous reset to state A
        else
            state <= next_state;
    end

    // Output logic
    always @(*) begin
        g = 3'b000; // Default all grants to 0
        case (state)
            STATE_B: g[1] = 1; // Grant device 1
            STATE_C: g[2] = 1; // Grant device 2
            STATE_D: g[3] = 1; // Grant device 3
        endcase
    end

endmodule