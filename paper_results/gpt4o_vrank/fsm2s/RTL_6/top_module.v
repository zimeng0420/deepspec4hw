module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);

    // Define states
    typedef enum reg {OFF = 1'b0, ON = 1'b1} state_t;
    state_t state, next_state;

    // State transition
    always @(posedge clk) begin
        if (reset)
            state <= OFF; // Active high synchronous reset to OFF
        else
            state <= next_state;
    end

    // Next state logic and output logic
    always @(*) begin
        case(state)
            OFF: begin
                out = 1'b0;    // Output for OFF state
                if (j)
                    next_state = ON;
                else
                    next_state = OFF;
            end
            ON: begin
                out = 1'b1;    // Output for ON state
                if (k)
                    next_state = OFF;
                else
                    next_state = ON;
            end
        endcase
    end

endmodule