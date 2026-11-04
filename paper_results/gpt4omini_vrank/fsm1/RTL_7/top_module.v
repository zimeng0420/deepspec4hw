module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    // State encoding
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01
    } state_t;

    state_t current_state, next_state;

    // Asynchronous reset to state B
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= B;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic
    always_ff @(current_state) begin
        case (current_state)
            A: out = 0;
            B: out = 1;
            default: out = 1'bx; // Undefined case
        endcase
    end

    // Next state logic
    always_ff @(current_state or in) begin
        case (current_state)
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
            default: next_state = B; // Undefined case, transition to B
        endcase
    end

endmodule