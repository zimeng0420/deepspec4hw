module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);

    // State encoding
    parameter OFF = 1'b0;
    parameter ON = 1'b1;

    // State register
    reg current_state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            OFF: begin
                if (j == 1)
                    next_state = ON;
                else
                    next_state = OFF;
            end
            ON: begin
                if (k == 1)
                    next_state = OFF;
                else
                    next_state = ON;
            end
            default: next_state = OFF;
        endcase
    end

    // State register and output logic (sequential)
    always @(posedge clk) begin
        if (reset)
            current_state <= OFF;
        else
            current_state <= next_state;

        // Output logic
        out <= current_state;
    end

endmodule