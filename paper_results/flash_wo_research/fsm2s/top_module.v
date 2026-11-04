module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output out
);

    reg state;

    // State definition
    localparam OFF = 0;
    localparam ON = 1;

    // Output assignment (Moore machine)
    assign out = state;

    // State transition logic
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
                default: state <= OFF; // Should not happen, but good practice
            endcase
        end
    end

endmodule