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

    state_t current_state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S0;
            z <= 1'b0; // Reset output
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            S0: begin
                if (x == 1'b1) begin
                    next_state = S1; // Transition to S1 on first '1'
                    z = 1'b1; // z stays the same
                end else begin
                    next_state = S0; 
                    z = 1'b1; // z is 2's complement of 0
                end
            end
            S1: begin
                next_state = S1; // Stay in S1
                z = ~x; // Output the inverted value of x
            end
            default: begin
                next_state = S0;
                z = 1'b0; // Default state
            end
        endcase
    end
endmodule