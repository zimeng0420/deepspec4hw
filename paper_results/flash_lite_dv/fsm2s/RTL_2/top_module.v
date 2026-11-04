module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output out
);

    // Define states
    parameter OFF = 0;
    parameter ON  = 1;

    // State register
    reg [0:0] current_state, next_state;

    // Combinational logic for next state
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
            default:
                next_state = OFF; // Default to OFF
        endcase
    end

    // Sequential logic for state update
    always @(posedge clk) begin
        if (reset)
            current_state <= OFF;
        else
            current_state <= next_state;
    end

    // Combinational logic for output
    assign out = current_state;

endmodule