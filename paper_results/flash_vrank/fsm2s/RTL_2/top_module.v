module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output out
);

    reg state;  // Current state
    reg next_state; // Next state

    // State definition
    parameter OFF = 0, ON = 1;

    // State transition logic
    always @(*) begin
        case (state)
            OFF: begin
                if (j == 0) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
            end
            ON: begin
                if (k == 0) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
            end
            default: next_state = OFF; //Should not happen but good practice
        endcase
    end

    // State update logic (synchronous reset)
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign out = (state == ON) ? 1 : 0;

endmodule