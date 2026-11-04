module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding using parameters
    parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;
    
    // State register
    reg [2:0] state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A; // Reset to state A
        end else begin
            state <= next_state; // Transition to next state
        end
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            A: begin
                if (w == 0) next_state = B;
                else next_state = A;
            end
            B: begin
                if (w == 0) next_state = C;
                else next_state = D;
            end
            C: begin
                if (w == 0) next_state = E;
                else next_state = D;
            end
            D: begin
                if (w == 0) next_state = F;
                else next_state = A;
            end
            E: begin
                if (w == 0) next_state = E;
                else next_state = D;
            end
            F: begin
                if (w == 0) next_state = C;
                else next_state = D;
            end
            default: next_state = A; // Default to state A
        endcase
    end
    
    // Output logic
    always @(*) begin
        case (state)
            E, F: z = 1; // Output for states E and F
            default: z = 0; // Output for states A, B, C, D
        endcase
    end

endmodule