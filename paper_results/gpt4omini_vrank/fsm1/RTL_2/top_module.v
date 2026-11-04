module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);
    // State declaration
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01
    } state_t;

    state_t state, next_state;

    // Asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B; // Reset to state B
        end else begin
            state <= next_state; // Transition to next state
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: begin
                if (in == 0) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end

            B: begin
                if (in == 0) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
            end

            default: next_state = B; // Default case
        endcase
    end

    // Output logic
    always @(state) begin
        case (state)
            A: out = 0;
            B: out = 1;
        endcase
    end
endmodule