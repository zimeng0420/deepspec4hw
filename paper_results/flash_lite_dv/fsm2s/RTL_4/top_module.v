module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output out
);

    // Define states
    parameter OFF = 0;
    parameter ON = 1;

    // State register
    reg state;

    // Output register
    reg out;

    // Next state logic
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: begin
                    if (j) begin
                        state <= ON;
                    end else begin
                        state <= OFF;
                    end
                end
                ON: begin
                    if (k) begin
                        state <= OFF;
                    end else begin
                        state <= ON;
                    end
                end
            endcase
        end
    end

    // Output logic (Moore machine)
    always @(*) begin
        case (state)
            OFF: out = 0;
            ON: out = 1;
            default: out = 0; // Should not happen, but good practice
        endcase
    end

endmodule