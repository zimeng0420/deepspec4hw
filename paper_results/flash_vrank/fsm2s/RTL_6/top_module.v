module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output out
);

    reg state;  // State variable: 0 for OFF, 1 for ON
    localparam OFF = 0;
    localparam ON = 1;

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
                default: state <= OFF; // Shouldn't happen, but good practice
            endcase
        end
    end

    assign out = state;

endmodule