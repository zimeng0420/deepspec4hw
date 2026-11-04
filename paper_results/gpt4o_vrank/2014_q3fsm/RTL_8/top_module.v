module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum logic [2:0] {
        A = 3'b000,
        B = 3'b001,
        C = 3'b010,
        D = 3'b011,
        E = 3'b100
    } state_t;
    
    state_t state, next_state;
    reg [1:0] count;  // Count for w = 1 occurrences in 3 cycles

    // State transition logic
    always_ff @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state and output logic
    always_comb begin
        next_state = state; // Default to remain in the current state
        z = 0;             // Default output

        case (state)
            A: begin
                if (s)
                    next_state = B;
            end
            
            B: begin
                count = (w == 1) ? count + 1 : count;
                next_state = C;
            end
            
            C: begin
                count = (w == 1) ? count + 1 : count;
                next_state = D;
            end
            
            D: begin
                count = (w == 1) ? count + 1 : count;
                if (count == 2)
                    z = 1;
                if (reset)
                    next_state = A;
                else
                    next_state = B;
            end
        endcase
    end

endmodule