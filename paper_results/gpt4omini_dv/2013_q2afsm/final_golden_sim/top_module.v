module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    // State encoding
    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            A: begin
                if (r[1] == 1) 
                    next_state = B;
                else if (r[2] == 1)
                    next_state = C;
                else if (r[3] == 1)
                    next_state = D;
                else 
                    next_state = A;
            end
            B: begin
                if (r[1] == 1)
                    next_state = B;  // Remain in state B
                else
                    next_state = A;  // Go back to state A
            end
            C: begin
                if (r[2] == 1)
                    next_state = C;  // Remain in state C
                else
                    next_state = A;  // Go back to state A
            end
            D: begin
                next_state = A;  // Only stays in D for its purpose
            end
            default: next_state = A; // safety
        endcase
    end

    // State flip-flops
    always @(posedge clk or negedge resetn) begin
        if (~resetn)
            state <= A; // Reset to state A
        else
            state <= next_state;
    end

    // Output logic
    always @(*) begin
        case (state)
            A: begin
                g[1] = r[1];
                g[2] = r[2] & ~r[1];
                g[3] = r[3] & ~r[1] & ~r[2];
            end
            B: begin
                g[1] = 1;
                g[2] = 0;
                g[3] = 0;
            end
            C: begin
                g[1] = 0;
                g[2] = 1;
                g[3] = 0;
            end
            D: begin
                g[1] = 0;
                g[2] = 0;
                g[3] = 1;
            end
            default: begin
                g[1] = 0;
                g[2] = 0;
                g[3] = 0;
            end 
        endcase
    end

endmodule