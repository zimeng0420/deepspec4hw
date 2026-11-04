module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output out
);

    reg state;  // Define the state register
    reg next_state;

    parameter OFF = 0, ON = 1; // Define state values

    // State transition logic
    always @(*) begin
        case (state)
            OFF: begin
                if (j == 0)
                    next_state = OFF;
                else
                    next_state = ON;
            end
            ON: begin
                if (k == 0)
                    next_state = ON;
                else
                    next_state = OFF;
            end
            default: next_state = OFF; //default state
        endcase
    end

    // State update logic (synchronous reset)
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic
    assign out = (state == ON);

endmodule