module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);
    typedef enum reg [2:0] {A, B, C, D, E, F} state_t;
    state_t current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            A: begin
                z = 0;
                if (w == 0)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                z = 0;
                if (w == 0)
                    next_state = C;
                else
                    next_state = D;
            end
            C: begin
                z = 0;
                if (w == 0)
                    next_state = E;
                else
                    next_state = D;
            end
            D: begin
                z = 0;
                if (w == 0)
                    next_state = F;
                else
                    next_state = A;
            end
            E: begin
                z = 1;
                if (w == 0)
                    next_state = E;
                else
                    next_state = D;
            end
            F: begin
                z = 1;
                if (w == 0)
                    next_state = C;
                else
                    next_state = D;
            end
            default: next_state = A; // Default case to handle unexpected states
        endcase
    end
endmodule