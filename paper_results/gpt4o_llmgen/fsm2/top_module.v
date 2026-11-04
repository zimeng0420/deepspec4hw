module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output reg out
);

    // State declaration
    typedef enum logic {
        OFF = 1'b0,
        ON  = 1'b1
    } state_t;

    state_t current_state, next_state;

    // State transition logic (next state logic)
    always @(*) begin
        case (current_state)
            OFF: begin
                if (j) 
                    next_state = ON;
                else 
                    next_state = OFF;
            end
            ON: begin
                if (k) 
                    next_state = OFF;
                else 
                    next_state = ON;
            end
            default: next_state = OFF;
        endcase
    end

    // State flip-flops with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) 
            current_state <= OFF; // asynchronous reset to OFF state
        else 
            current_state <= next_state;
    end

    // Output logic (Moore machine: output depends only on the current state)
    always @(*) begin
        case (current_state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule