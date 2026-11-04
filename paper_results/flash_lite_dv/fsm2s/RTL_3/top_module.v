module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);

    // State definition
    parameter OFF = 0;
    parameter ON  = 1;

    // State register
    reg state;

    // Next state logic
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: begin
                    if (j)
                        state <= ON;
                    else
                        state <= OFF;
                end
                ON: begin
                    if (k)
                        state <= OFF;
                    else
                        state <= ON;
                end
            endcase
        end
    end

    // Output logic (Moore machine)
    always @(*) begin
        case (state)
            OFF: out = 0;
            ON:  out = 1;
            default: out = 0; // Should not happen, but good practice
        endcase
    end

endmodule