module top_module(
    input clk,
    input reset,
    input w,
    output z
);

    // State Definition
    parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;
    reg [2:0] current_state, next_state;

    // State Flip-Flops
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next State Logic and Output Logic
    always @(*) begin
        case (current_state)
            A: begin
                if (w)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (w)
                    next_state = C;
                else
                    next_state = D;
            end
            C: begin
                if (w)
                    next_state = E;
                else
                    next_state = D;
            end
            D: begin
                if (w)
                    next_state = F;
                else
                    next_state = A;
            end
            E: begin
                if (w)
                    next_state = E;
                else
                    next_state = D;
            end
            F: begin
                if (w)
                    next_state = C;
                else
                    next_state = D;
            end
            default: next_state = A; // Handle any undefined state
        endcase
    end

    // Output Logic
    assign z = (current_state == E || current_state == F) ? 1 : 0;

endmodule