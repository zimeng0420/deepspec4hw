module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    // State encoding
    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] current_state, next_state;

    // State flip-flops
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            current_state <= A; // Reset to state A
        else
            current_state <= next_state; // Transition to next state
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: begin
                if (r[1]) 
                    next_state = B; // Go to state B if r1 is high
                else if (r[2]) 
                    next_state = C; // Go to state C if r2 is high
                else if (r[3]) 
                    next_state = D; // Go to state D if r3 is high
                else 
                    next_state = A; // Stay in state A
            end
            B: begin
                if (r[1]) 
                    next_state = B; // Stay in state B if r1 is high
                else 
                    next_state = A; // Go back to state A if r1 is low
            end
            C: begin
                if (r[2]) 
                    next_state = C; // Stay in state C if r2 is high
                else 
                    next_state = A; // Go back to state A if r2 is low
            end
            D: begin
                if (r[3]) 
                    next_state = D; // Stay in state D if r3 is high
                else 
                    next_state = A; // Go back to state A if r3 is low
            end
            default: next_state = A; // Default to state A
        endcase
    end

    // Output logic
    always @(*) begin
        // Default outputs
        g = 3'b000;
        case (current_state)
            A: begin
                if (r[1])
                    g[1] = 1; // Grant to device 1
                else if (r[2])
                    g[2] = 1; // Grant to device 2
                else if (r[3])
                    g[3] = 1; // Grant to device 3
            end
            B: g[1] = 1; // Always grant to device 1
            C: g[2] = 1; // Always grant to device 2
            D: g[3] = 1; // Always grant to device 3
        endcase
    end

endmodule