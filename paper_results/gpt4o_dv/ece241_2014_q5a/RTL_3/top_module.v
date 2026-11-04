module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Define states
    typedef enum logic [1:0] {IDLE, PASS_THROUGH, INVERT} state_t;
    state_t state, next_state;
    reg first_one_detected;

    // Asynchronous reset and state transitions
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            first_one_detected <= 0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and output generation
    always @(*) begin
        case (state)
            IDLE: begin
                z = x;
                next_state = PASS_THROUGH;
            end
            PASS_THROUGH: begin
                if (!first_one_detected && x == 1) begin
                    first_one_detected = 1;
                    next_state = INVERT;
                end else begin
                    next_state = PASS_THROUGH;
                end
                z = first_one_detected ? ~x : x;
            end
            INVERT: begin
                z = ~x;
                next_state = INVERT;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule