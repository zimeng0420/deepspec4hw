module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);
    typedef enum logic [2:0] {
        A = 3'b000,
        B = 3'b001,
        C = 3'b010,
        D = 3'b011,
        E = 3'b100,
        F = 3'b101
    } state_t;
    
    state_t current_state, next_state;
    
    // State transition and output logic
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= A;  // Reset to state A
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        case (current_state)
            A: begin
                if (w)
                    next_state = A;
                else
                    next_state = B;
                z = 0;
            end
            B: begin
                if (w)
                    next_state = D;
                else
                    next_state = C;
                z = 0;
            end
            C: begin
                if (w)
                    next_state = D;
                else
                    next_state = E;
                z = 0;
            end
            D: begin
                if (w)
                    next_state = A;
                else
                    next_state = F;
                z = 0;
            end
            E: begin
                if (w)
                    next_state = D;
                else
                    next_state = E;
                z = 1;
            end
            F: begin
                if (w)
                    next_state = D;
                else
                    next_state = C;
                z = 1;
            end
            default: begin
                next_state = A;
                z = 0;
            end
        endcase
    end

endmodule