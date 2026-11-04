module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    typedef enum reg [1:0] {
        S0 = 2'b00, // Waiting for first '1'
        S1 = 2'b01  // Inverting bits
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S0;
            z <= 1'b1; // Reset output to 1
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            S0: begin
                if (x == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
                z = 1'b1; // For z during state S0
            end
            S1: begin
                next_state = S1; // Stay in S1
                z = ~x; // Output inverted value of x
            end
            default: begin
                next_state = S0;
                z = 1'b1; // Default output
            end
        endcase
    end
endmodule