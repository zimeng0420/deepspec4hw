module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t current_state, next_state;

    // Output logic
    always @(*) begin
        g = 3'b000; // Default state
        case (current_state)
            A: begin
                if (r[1]) g[1] = 1; // Grant to device 1
                else if (r[2]) g[2] = 1; // Grant to device 2
                else if (r[3]) g[3] = 1; // Grant to device 3
            end
            B: g[1] = 1; // Grant to device 1
            C: g[2] = 1; // Grant to device 2
            default: g = 3'b000; // No grants
        endcase
    end

    // State transition logic
    always @(*) begin
        case (current_state)
            A: begin
                if (r[1]) next_state = B;
                else if (r[2]) next_state = C;
                else if (r[3]) next_state = D;
                else next_state = A; // Remain in state A
            end
            B: begin
                if (r[1]) next_state = B; // Remain in state B
                else next_state = A; // Return to state A
            end
            C: begin
                if (r[2]) next_state = C; // Remain in state C
                else next_state = A; // Return to state A
            end
            default: next_state = A; // Default to state A
        endcase
    end

    // State flip-flop logic
    always @(posedge clk or negedge resetn) begin
        if (!resetn) 
            current_state <= A; // Reset to state A
        else 
            current_state <= next_state; // Transition to next state
    end

endmodule