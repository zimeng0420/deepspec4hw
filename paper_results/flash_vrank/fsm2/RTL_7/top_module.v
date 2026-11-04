module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output out
);

    reg state;
    localparam OFF = 0, ON = 1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: begin
                    if (j == 1) begin
                        state <= ON;
                    end else begin
                        state <= OFF;
                    end
                end
                ON: begin
                    if (k == 1) begin
                        state <= OFF;
                    end else begin
                        state <= ON;
                    end
                end
                default: state <= OFF;
            endcase
        end
    end

    assign out = state;

endmodule