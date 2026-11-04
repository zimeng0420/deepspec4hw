module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    typedef enum reg [1:0] {A, B} state_t;
    state_t state, next_state;

    // State transition
    always @(*) begin
        case (state)
            A: begin
                if (in == 0)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (in == 0)
                    next_state = A;
                else
                    next_state = B;
            end
            default: next_state = B; // Default to state B for safety
        endcase
    end

    // State update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B; // Asynchronous reset to state B
        else
            state <= next_state;
    end

    // Output logic
    always @(state) begin
        case (state)
            A: out = 0;
            B: out = 1;
        endcase
    end

endmodule