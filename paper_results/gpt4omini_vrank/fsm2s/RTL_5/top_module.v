module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);

    // State encoding
    typedef enum reg [1:0] {OFF, ON} state_t;
    state_t state, next_state;

    // Synchronous reset and state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            OFF: begin
                if (j) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
                out = 0;
            end
            ON: begin
                if (k) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
                out = 1;
            end
            default: begin
                next_state = OFF; // default state
                out = 0;
            end
        endcase
    end

endmodule