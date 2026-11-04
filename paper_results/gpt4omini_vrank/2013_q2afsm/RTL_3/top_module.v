module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    // State encoding
    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] state, next_state;

    // State transition
    always @ (posedge clk or negedge resetn) begin
        if (!resetn)
            state <= A; // Reset to state A
        else
            state <= next_state;
    end

    // Next state logic
    always @ (*) begin
        case (state)
            A: begin
                if (r[1] == 1)
                    next_state = B;
                else if (r[2] == 1)
                    next_state = C;
                else
                    next_state = D;
            end
            B: begin
                if (r[1] == 1)
                    next_state = B; // Stay in B
                else
                    next_state = A; // Back to A
            end
            C: begin
                if (r[2] == 1)
                    next_state = C; // Stay in C
                else
                    next_state = A; // Back to A
            end
            D: begin
                next_state = A; // Back to A
            end
            default: next_state = A; // Safety case
        endcase
    end

    // Output logic
    always @ (*) begin
        g = 3'b000; // Default output
        case (state)
            B: g[1] = 1; // Grant to device 1
            C: g[2] = 1; // Grant to device 2
            // Device 3 (g[3]) does not have a dedicated state in the given diagram,
            // hence it is not utilized directly in the output logic.
            default: g[3] = 0; // No grant for device 3
        endcase
    end

endmodule