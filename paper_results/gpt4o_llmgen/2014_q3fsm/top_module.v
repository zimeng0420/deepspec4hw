module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State Definitions
    typedef enum reg [2:0] {
        A = 3'b000,
        B = 3'b001,
        C = 3'b010,
        D = 3'b011,
        E = 3'b100
    } fsm_state_t;

    fsm_state_t state, next_state;
    reg [1:0] count;

    // State Transition Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 2'b00;
        end else begin
            state <= next_state;
            if (state == A) count <= 2'b00; // Reset count when entering State B
        end
    end

    // Next State and Output Logic
    always @(*) begin
        next_state = state; // Default to stay in the current state
        z = 0; // Default output

        case (state)
            A: begin
                if (s)
                    next_state = B;
            end
            B: begin
                count = (w) ? count + 1 : count;
                next_state = C;
            end
            C: begin
                count = (w) ? count + 1 : count;
                next_state = D;
            end
            D: begin
                count = (w) ? count + 1 : count;
                next_state = E;
            end
            E: begin
                z = (count == 2'b10) ? 1'b1 : 1'b0;
                next_state = B; // Continue to check next batch
            end
        endcase
    end
    
endmodule