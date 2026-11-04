module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    // State encoding
    typedef enum logic [1:0] {
        A = 2'b00,  // State A
        B = 2'b01,  // State B
        C = 2'b10   // State C
    } state_t;

    state_t current_state, next_state;

    // Sequential block for state registers
    always_ff @(posedge clk or negedge resetn) begin
        if (~resetn)
            current_state <= A;  // Reset to state A
        else
            current_state <= next_state;  // Transition to next state
    end

    // Combinational block for next state logic
    always_comb begin
        // Default next state and outputs 
        next_state = current_state;
        g = 3'b000;  // Default grant outputs

        case (current_state)
            A: begin
                if (r[1]) begin
                    next_state = B;  // Priority: Device 1
                end else if (r[2]) begin
                    next_state = C;  // Priority: Device 2
                end else if (r[3]) begin
                    next_state = A;  // Device 3 (lowest priority)
                end else begin
                    next_state = A;  // Stay in A if no requests
                end
            end

            B: begin
                g[1] = 1;  // Grant to device 1
                if (~r[1]) begin
                    next_state = A;  // Go back to A if device 1 deasserts request
                end else begin
                    next_state = B;  // Remain in B as device 1 still has a request
                end
            end

            C: begin
                g[2] = 1;  // Grant to device 2
                if (~r[2]) begin
                    next_state = A;  // Go back to A if device 2 deasserts request
                end else begin
                    next_state = C;  // Remain in C as device 2 still has a request
                end
            end

            default: next_state = A;  // Fallback to state A
        endcase
    end

endmodule