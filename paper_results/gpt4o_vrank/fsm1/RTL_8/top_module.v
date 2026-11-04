module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    // State encoding
    typedef enum reg [1:0] {STATE_A = 2'd0, STATE_B = 2'd1} state_t;
    state_t state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            STATE_A: begin
                if (in)
                    next_state = STATE_A; // A --1--> A
                else
                    next_state = STATE_B; // A --0--> B
            end
            STATE_B: begin
                if (in)
                    next_state = STATE_B; // B --1--> B
                else
                    next_state = STATE_A; // B --0--> A
            end
            default: next_state = STATE_B;
        endcase
    end

    // State flip-flops with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_B;
        else
            state <= next_state;
    end

    // Output logic
    always @(*) begin
        case (state)
            STATE_A: out = 1'b0;
            STATE_B: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule