module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output out
);

    // State definition
    typedef enum reg [0:0] {OFF = 1'b0, ON = 1'b1} state_t;
    state_t state, next_state;

    // Output logic
    assign out = state;

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF; // Reset to OFF state
        end else begin
            state <= next_state; // Update state on clock edge
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            OFF: begin
                if (j) begin
                    next_state = ON; // Transition to ON state
                end else begin
                    next_state = OFF; // Remain in OFF state
                end
            end
            ON: begin
                if (k) begin
                    next_state = OFF; // Transition to OFF state
                end else begin
                    next_state = ON; // Remain in ON state
                end
            end
            default: next_state = OFF; // Default case
        endcase
    end

endmodule