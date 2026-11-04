module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    // State encoding
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t current_state, next_state;

    // Output logic
    always @(*) begin
        g = 3'b000; // Default output
        case (current_state)
            A: g = 3'b000; // No grants in state A
            B: g[1] = 1'b1; // Grant to device 1 in state B
            C: g[2] = 1'b1; // Grant to device 2 in state C
            D: g[3] = 1'b1; // Grant to device 3 in state D
        endcase
    end

    // State transition logic
    always @(*) begin
        case (current_state)
            A: begin
                if (r[1])
                    next_state = B;
                else if (r[2])
                    next_state = C;
                else if (r[3])
                    next_state = D;
                else
                    next_state = A;
            end
            B: begin
                if (r[1])
                    next_state = B;
                else
                    next_state = A;
            end
            C: begin
                if (r[2])
                    next_state = C;
                else
                    next_state = A;
            end
            D: begin
                if (r[3])
                    next_state = D;
                else
                    next_state = A;
            end
            default: next_state = A; // Safety measure
        endcase
    end

    // State flip-flops
    always @(posedge clk) begin
        if (!resetn)
            current_state <= A; // Reset state
        else
            current_state <= next_state;
    end

endmodule