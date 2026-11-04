module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output reg out
);

    typedef enum reg {OFF, ON} state_t;
    state_t state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            OFF: next_state = (j == 1) ? ON : OFF;
            ON:  next_state = (k == 1) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State register logic
    always @(posedge clk or posedge areset) begin
        if (areset) 
            state <= OFF;
        else 
            state <= next_state;
    end

    // Output logic
    assign out = (state == ON) ? 1 : 0;

endmodule