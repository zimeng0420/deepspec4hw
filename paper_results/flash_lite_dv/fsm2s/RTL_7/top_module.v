module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output out
);

    // State declaration
    parameter OFF = 0;
    parameter ON = 1;

    // State register
    reg state;

    // Output register
    assign out = state;

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
                default: state <= OFF; //Should not happen, but good practice
            endcase
        end
    end

endmodule