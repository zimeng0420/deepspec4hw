module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    typedef enum reg [1:0] {
        S0 = 2'b00, // Waiting for the first '1'
        S1 = 2'b01  // Inverting bits
    } state_t;

    state_t state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            z <= 1'b1;  // Output reset to known state (2's complement of 0)
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            S0: begin
                if (x == 1'b1) begin
                    next_state = S1; // Transition to inverting bits
                end else begin
                    next_state = S0; // Stay in S0
                end
                z = 1'b1; // Output z is 1 when in S0
            end
            S1: begin
                next_state = S1; // Stay in S1
                z = ~x; // Output z is the inverted value of x
            end
            default: begin
                next_state = S0; // Default state
                z = 1'b1; // Default output
            end
        endcase
    end

endmodule