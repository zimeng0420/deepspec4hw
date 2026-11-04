module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01
    } state_t;

    state_t state, next_state;
    logic [2:0] w_count;
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_count <= 3'b000;
        end else begin
            state <= next_state;
            if (state == B) begin
                w_count <= {w_count[1:0], w}; // Shift in the current w value
                z <= (w_count[2] + w_count[1] + w) == 2; // Check if exactly two are 1
            end
        end
    end
    
    always_comb begin
        case (state)
            A: begin
                if (s) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                next_state = B; // Remain in state B
            end
            default: next_state = A; // Safe state
        endcase
    end
endmodule