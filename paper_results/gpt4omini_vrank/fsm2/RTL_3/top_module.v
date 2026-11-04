module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output reg out
);
    typedef enum reg {OFF, ON} state_t;
    state_t current_state, next_state;

    // State transition
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= OFF;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @* begin
        case (current_state)
            OFF: begin
                if (j) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
            end
            ON: begin
                if (k) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
            end
            default: next_state = OFF; // Default case
        endcase
    end

    // Output logic
    always @(current_state) begin
        case (current_state)
            OFF: out = 0;
            ON: out = 1;
            default: out = 0; // Default case
        endcase
    end
endmodule