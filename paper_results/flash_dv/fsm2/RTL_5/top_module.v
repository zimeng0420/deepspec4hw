module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output out
);

    // State definition
    localparam OFF = 0;
    localparam ON  = 1;

    // State register
    reg current_state;

    // Output assignment (Moore machine)
    assign out = current_state;

    // Next state logic
    reg next_state;

    always @(*) begin
        case (current_state)
            OFF: begin
                if (j == 1) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
            end
            ON: begin
                if (k == 1) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
            end
            default: next_state = OFF; // Should not happen, but good practice
        endcase
    end

    // State update (sequential logic)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= OFF;
        end else begin
            current_state <= next_state;
        end
    end

endmodule