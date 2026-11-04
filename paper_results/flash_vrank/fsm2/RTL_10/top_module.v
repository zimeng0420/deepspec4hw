module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output out
);

    reg state;
    reg next_state;

    // State definition
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // Output logic (Moore machine)
    assign out = state;

    // State transition logic
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
            default: next_state = OFF; // Should not happen, but good practice
        endcase
    end

    // State update logic (sequential)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

endmodule