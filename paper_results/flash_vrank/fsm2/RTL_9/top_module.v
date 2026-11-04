module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output out
);

    reg state;
    reg next_state;

    parameter OFF = 0;
    parameter ON = 1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            OFF: begin
                if (j == 0) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
            end
            ON: begin
                if (k == 0) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
            end
            default: next_state = OFF;
        endcase
    end

    assign out = (state == ON) ? 1 : 0;

endmodule