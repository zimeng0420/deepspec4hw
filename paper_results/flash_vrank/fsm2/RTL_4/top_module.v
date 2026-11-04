module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output out
);

    reg state;
    parameter OFF = 0, ON = 1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
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
                default: state <= OFF; // Should never happen, but good practice
            endcase
        end
    end

    assign out = state; // Moore output depends only on the state

endmodule